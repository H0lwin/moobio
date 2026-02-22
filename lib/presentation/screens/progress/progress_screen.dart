import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

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
                  isFa ? 'تحلیل پیشرفت' : 'Progress Analytics',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  isFa
                      ? 'روند تمرین و اهداف هفتگی را بررسی کن.'
                      : 'Review trend lines and weekly targets.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async => HapticFeedback.lightImpact(),
                  child: Text(isFa ? 'نمایش گزارش کامل' : 'View Full Report'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
