import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/theme/app_theme.dart';

class TrainScreen extends StatelessWidget {
  const TrainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isFa = Localizations.localeOf(context).languageCode == 'fa';
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isFa ? 'مرکز تمرین' : 'Workout Hub',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  isFa
                      ? 'برنامه‌ها را مرور کن و جلسه بعدی را شروع کن.'
                      : 'Review plans and launch your next session.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async => HapticFeedback.lightImpact(),
                  child: Text(isFa ? 'شروع جلسه' : 'Start Session'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
