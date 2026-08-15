import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      height: 72,
      backgroundColor: Colors.white,
      indicatorColor: Colors.blue.shade100,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: "Home",
        ),
        NavigationDestination(
          icon: Icon(Icons.flight_outlined),
          selectedIcon: Icon(Icons.flight),
          label: "Flights",
        ),
        NavigationDestination(
          icon: Icon(Icons.confirmation_number_outlined),
          selectedIcon: Icon(Icons.confirmation_number),
          label: "Bookings",
        ),
        NavigationDestination(
          icon: Icon(Icons.smart_toy_outlined),
          selectedIcon: Icon(Icons.smart_toy),
          label: "AI",
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}