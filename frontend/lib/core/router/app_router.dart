import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/ai/presentation/screens/ai_screen.dart';
import '../../features/booking/presentation/screens/booking_screen.dart';
import '../../features/flights/presentation/screens/flights_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../shared/widgets/bottom_navigation.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',

    routes: [
      StatefulShellRoute.indexedStack(
        builder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return MainShell(
            navigationShell: navigationShell,
          );
        },

        branches: [
          // --------------------------------------------------
          // HOME
          // --------------------------------------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) {
                  return const HomeScreen();
                },
              ),
            ],
          ),

          // --------------------------------------------------
          // FLIGHTS
          // --------------------------------------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/flights',
                name: 'flights',
                builder: (context, state) {
                  return const FlightsScreen();
                },
              ),
            ],
          ),

          // --------------------------------------------------
          // BOOKINGS
          // --------------------------------------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/bookings',
                name: 'bookings',
                builder: (context, state) {
                  return const BookingScreen();
                },
              ),
            ],
          ),

          // --------------------------------------------------
          // AI
          // --------------------------------------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/ai',
                name: 'ai',
                builder: (context, state) {
                  return const AiScreen();
                },
              ),
            ],
          ),

          // --------------------------------------------------
          // PROFILE
          // --------------------------------------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) {
                  return const _PlaceholderScreen(
                    title: 'Profile',
                    icon: Icons.person,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}


// ============================================================
// MAIN SHELL
// ============================================================

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({
    super.key,
    required this.navigationShell,
  });

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,

      // If the user taps the currently selected tab,
      // return to that tab's root screen.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,

      bottomNavigationBar: BottomNavigation(
        currentIndex: navigationShell.currentIndex,
        onTap: _onDestinationSelected,
      ),
    );
  }
}


// ============================================================
// TEMPORARY PLACEHOLDER
// ============================================================

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderScreen({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}