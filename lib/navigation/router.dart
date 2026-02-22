'''
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/presentation/screens/club/club_screen.dart';
import 'package:myapp/presentation/screens/home/home_screen.dart';
import 'package:myapp/presentation/screens/progress/progress_screen.dart';
import 'package:myapp/presentation/screens/settings/settings_screen.dart';
import 'package:myapp/presentation/screens/train/train_screen.dart';


final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithBottomNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/train',
          builder: (context, state) => const TrainScreen(),
        ),
        GoRoute(
          path: '/club',
          builder: (context, state) => const ClubScreen(),
        ),
        GoRoute(
          path: '/progress',
          builder: (context, state) => const ProgressScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

class ScaffoldWithBottomNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithBottomNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavBar(
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/train');
              break;
            case 2:
              context.go('/club');
              break;
            case 3:
              context.go('/progress');
              break;
          }
        },
      ),
    );
  }
}
''