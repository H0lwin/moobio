import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const items = <_NavItem>[
      _NavItem(icon: Icons.home_rounded, label: 'Home'),
      _NavItem(icon: Icons.fitness_center_rounded, label: 'Train'),
      _NavItem(icon: Icons.waves_rounded, label: 'Club'),
      _NavItem(icon: Icons.query_stats_rounded, label: 'Progress'),
    ];

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: 82,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: FitCoreColors.surface.withOpacity(0.9),
            border: const Border(
              top: BorderSide(color: FitCoreColors.borderSubtle),
            ),
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: List.generate(items.length, (index) {
                final isSelected = index == currentIndex;
                return Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => onTap(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOut,
                            height: 3,
                            width: isSelected ? 24 : 0,
                            margin: const EdgeInsets.only(bottom: 7),
                            decoration: BoxDecoration(
                              color: FitCoreColors.accentViolet,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: isSelected
                                  ? const [
                                      BoxShadow(
                                        color: FitCoreColors.accentViolet,
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : const [],
                            ),
                          ),
                          Icon(
                            items[index].icon,
                            color: isSelected
                                ? FitCoreColors.accentViolet
                                : FitCoreColors.textSecondary,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            items[index].label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: isSelected
                                      ? FitCoreColors.textPrimary
                                      : FitCoreColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
