import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  static const double _progress = 0.68;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: FitCoreMotion.screenPush,
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final isFa = localeCode == 'fa';
    final textTheme = Theme.of(context).textTheme;

    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.03),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF8B6FFF), Color(0xFFFF5F3D)],
                ),
                border: Border.all(color: FitCoreColors.borderSubtle),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isFa ? 'تمرین امروز' : "Today's Workout",
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.82),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isFa ? 'روز پوش' : 'PUSH DAY',
                      style: textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _chip(isFa ? 'سینه' : 'Chest'),
                        _chip(isFa ? 'سرشانه' : 'Shoulders'),
                        _chip(isFa ? 'سه‌سر' : 'Triceps'),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        _ProgressArc(value: _progress),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            isFa ? 'پیشرفت امروز: ۶۸٪' : 'Today progress: 68%',
                            style: textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await HapticFeedback.lightImpact();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FitCoreColors.accentCoral,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(isFa ? 'شروع تمرین' : 'Start Workout'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ProgressArc extends StatelessWidget {
  const _ProgressArc({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: 1,
            strokeWidth: 6,
            color: Colors.white.withOpacity(0.28),
          ),
          CircularProgressIndicator(
            value: value,
            strokeWidth: 6,
            color: Colors.white,
            strokeCap: StrokeCap.round,
          ),
          Text(
            '${(value * 100).round()}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
