const admin = require('firebase-admin');
const fetch = require('node-fetch');
const serviceAccount = require('../service-account.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: serviceAccount.project_id + '.firebasestorage.app',
});

const db = admin.firestore();
const bucket = admin.storage().bucket();
const ARTICLES = require('./articles_data.json');

async function uploadImage(imageUrl, articleId) {
  const response = await fetch(imageUrl);
  if (!response.ok) throw new Error('Failed: ' + response.statusText);
  const buffer = await response.buffer();
  const storagePath = 'media/articles/' + articleId + '.jpg';
  const file = bucket.file(storagePath);
  await file.save(buffer, { metadata: { contentType: 'image/jpeg' } });
  await file.makePublic();
  return 'https://storage.googleapis.com/' + bucket.name + '/' + storagePath;
}

async function seed() {
  console.log('Seeding with Firebase Storage...');
  const existing = await db.collection('articles').get();
  if (!existing.empty) {
    const b = db.batch();
    existing.docs.forEach(d => b.delete(d.ref));
    await b.commit();
    console.log('Deleted ' + existing.size + ' existing articles.');
  }
  for (const article of ARTICLES) {
    const ref = db.collection('articles').doc();
    console.log('Processing: ' + article.title);
    let thumbnailURL;
    try {
      thumbnailURL = await uploadImage(article.imageUrl, ref.id);
      console.log('  Uploaded to Storage: ' + thumbnailURL);
    } catch (e) {
      console.warn('  Upload failed, using original URL:', e.message);
      thumbnailURL = article.imageUrl;
    }
    await ref.set({
      title: article.title,
      description: article.description,
      content: article.content,
      author: article.author,
      sourceName: article.sourceName,
      sourceId: article.sourceId,
      category: article.category,
      thumbnailURL: thumbnailURL,
      publishedAt: admin.firestore.Timestamp.fromDate(new Date(Date.now() - article.msAgo)),
      url: article.url,
      isBreaking: article.isBreaking,
      tags: article.tags,
      views: article.views,
    });
    console.log('  Saved to Firestore: ' + ref.id);
  }
  console.log('Done! All articles seeded with Storage URLs.');
  process.exit(0);
}

seed().catch(e => { console.error('Error:', e); process.exit(1); });