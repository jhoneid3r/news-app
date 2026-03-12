import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/article.dart';
import '../../domain/usecases/create_article.dart';

class CreateArticlePage extends StatefulWidget {
  const CreateArticlePage({super.key});

  @override
  State<CreateArticlePage> createState() => _CreateArticlePageState();
}

class _CreateArticlePageState extends State<CreateArticlePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;
  File? _pickedImage;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (picked == null) return;
      setState(() => _pickedImage = File(picked.path));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open gallery: $e')),
        );
      }
    }
  }

  Future<String?> _uploadImage(File file) async {
    final ref = FirebaseStorage.instance
        .ref('media/articles/user_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> _onPublish() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in the title and content.')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Publish Article'),
        content: Text('Are you sure you want to publish "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.fabPurple,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Publish'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isLoading = true);

    String thumbnailURL = 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=800';
    if (_pickedImage != null) {
      try {
        thumbnailURL = await _uploadImage(_pickedImage!) ?? thumbnailURL;
      } catch (_) {}
    }

    final article = Article(
      id: '',
      title: title,
      description: content.length > 150 ? '${content.substring(0, 150)}...' : content,
      content: content,
      author: 'NewsFlow User',
      sourceName: 'NewsFlow',
      sourceId: 'newsflow',
      category: 'general',
      thumbnailURL: thumbnailURL,
      publishedAt: DateTime.now(),
      url: '',
      isBreaking: false,
      tags: [],
      views: 0,
    );

    final result = await sl<CreateArticle>()(article);

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${failure.message}'),
          backgroundColor: Colors.red,
        ),
      ),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Article published successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          // Scrollable form area
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: () => context.pop(),
                  ),
                  title: const Text('New Article'),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title field
                        Container(
                          decoration: BoxDecoration(
                            color: theme.cardTheme.color,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? Colors.white12 : Colors.black12,
                            ),
                          ),
                          child: TextField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              hintText: 'Write your title here...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16),
                            ),
                            style: theme.textTheme.titleMedium,
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Attach image button
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.attachButton.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                  color: AppColors.fabPurple.withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add_photo_alternate_outlined,
                                    color: AppColors.fabPurple, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  _pickedImage != null ? 'Change Image' : 'Attach Image',
                                  style: TextStyle(
                                    color: AppColors.fabPurple,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_pickedImage != null) ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _pickedImage!,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),

                        // Content area
                        Container(
                          constraints: const BoxConstraints(minHeight: 300),
                          decoration: BoxDecoration(
                            color: theme.cardTheme.color,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? Colors.white12 : Colors.black12,
                            ),
                          ),
                          child: TextField(
                            controller: _contentController,
                            decoration: const InputDecoration(
                              hintText: 'Add article here, .....',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16),
                            ),
                            style: theme.textTheme.bodyLarge,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom "Publish Article" bar
          GestureDetector(
            onTap: _isLoading ? null : _onPublish,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              color: isDark ? AppColors.publishBarDark : AppColors.publishBar,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Icon(Icons.send_outlined,
                        color: isDark ? Colors.white70 : Colors.black87,
                        size: 20),
                  const SizedBox(width: 10),
                  Text(
                    _isLoading ? 'Publishing...' : 'Publish Article',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
