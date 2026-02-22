import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const IconButton(icon: Icon(Icons.fitness_center), onPressed: null, tooltip: 'FitCore'),
        title: const Text('Home'),
        actions: [
          const IconButton(
            icon: Badge(child: Icon(Icons.notifications)),
            onPressed: null,
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text('روز فشار', style: Theme.of(context).textTheme.displayLarge), // Persian for PUSH DAY
                    const SizedBox(height: 8),
                    Text('تمرین امروز', style: Theme.of(context).textTheme.bodyMedium), // Persian for Today's Workout
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              child: const Text('شروع تمرین'), // Persian for Start Workout
            ),
          ],
        ),
      ),
    );
  }
}
