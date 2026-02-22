import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClubScreen extends StatelessWidget {
  const ClubScreen({super.key});

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
                  isFa ? 'باشگاه' : 'Club Hub',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  isFa
                      ? 'چالش‌ها، لیدربورد و تیمت را مدیریت کن.'
                      : 'Manage challenges, leaderboard, and your squad.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async => HapticFeedback.lightImpact(),
                  child: Text(isFa ? 'ورود به چالش' : 'Join Challenge'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
