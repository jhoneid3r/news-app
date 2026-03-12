import 'package:flutter/material.dart';
import 'app.dart';
import 'core/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection.
  // Firebase.initializeApp() should be called here once Firebase is configured.
  // After running `flutterfire configure`, uncomment:
  //
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  await initDependencies();

  runApp(const NewsApp());
}