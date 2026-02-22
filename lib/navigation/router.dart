import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/presentation/screens/club/club_screen.dart';
import 'package:myapp/presentation/screens/home/home_screen.dart';
import 'package:myapp/presentation/screens/progress/progress_screen.dart';
import 'package:myapp/presentation/screens/settings/settings_screen.dart';
import 'package:myapp/presentation/screens/train/train_screen.dart';
import 'package:myapp/presentation/widgets/bottom_nav_bar.dart';
import 'package:myapp/presentation/widgets/fitcore_header.dart';
import 'package:myapp/theme/app_theme.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithBottomNavBar(location: state.uri.path, child: child);
      },
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/train',
          builder: (context, state) => const TrainScreen(),
        ),
        GoRoute(path: '/club', builder: (context, state) => const ClubScreen()),
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
  const ScaffoldWithBottomNavBar({
    super.key,
    required this.child,
    required this.location,
  });

  final Widget child;
  final String location;

  int get _currentIndex {
    if (location.startsWith('/train')) {
      return 1;
    }
    if (location.startsWith('/club')) {
      return 2;
    }
    if (location.startsWith('/progress')) {
      return 3;
    }
    return 0;
  }

  String get _title {
    switch (_currentIndex) {
      case 1:
        return 'Train';
      case 2:
        return 'Club';
      case 3:
        return 'Progress';
      default:
        return 'Home';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FitCoreColors.background,
      body: SafeArea(
        child: Column(
          children: [
            FitCoreHeader(
              title: _title,
              showLogo: _currentIndex == 0,
              onSettings: () => context.push('/settings'),
              onNotifications: () {},
            ),
            Expanded(child: child),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
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
