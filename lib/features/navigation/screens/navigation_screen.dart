import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe/features/favorites/screens/favorites_screen.dart';
import 'package:recipe/features/home/screens/home_screen.dart';
import 'package:recipe/features/navigation/controller/navigation_controller.dart';

class NavigationScreen extends GetView<NavigationController> {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: const [HomeScreen(), FavoritesScreen()],
        ),
        bottomNavigationBar: NavigationBar(
          height: 75,
          elevation: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          indicatorColor: Theme.of(context).colorScheme.primaryContainer,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          animationDuration: const Duration(milliseconds: 300),
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: controller.changeTab,
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              selectedIcon: Icon(
                Icons.home_rounded,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.favorite_border_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              selectedIcon: Icon(
                Icons.favorite_rounded,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              label: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }
}
