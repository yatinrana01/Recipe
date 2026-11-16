import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recipe/app/bindings/initial_binding.dart';
import 'package:recipe/features/home/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  runApp(const RecipeFinderApp());
}

class RecipeFinderApp extends StatelessWidget {
  const RecipeFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Recipe',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        scaffoldBackgroundColor: const Color(0xFFFFFBF7),
      ),
      
      home: const HomeScreen(),
    );
  }
}

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.cookie, color: Colors.deepOrange),
        title: const Text('Recipe Finder'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.restaurant_menu, size: 72, color: Colors.deepOrange),
            SizedBox(height: 16),
            Text(
              'Discover your next favourite meal',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text('Your recipe journey starts here.'),
          ],
        ),
      ),
    );
  }
}
