import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';

class FitCoreHeader extends StatelessWidget {
  const FitCoreHeader({
    super.key,
    required this.title,
    required this.onSettings,
    this.onNotifications,
    this.showLogo = false,
    this.showBack = false,
    this.onBack,
    this.hasUnread = true,
  });

  final String title;
  final VoidCallback onSettings;
  final VoidCallback? onNotifications;
  final bool showLogo;
  final bool showBack;
  final VoidCallback? onBack;
  final bool hasUnread;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: FitCoreColors.surface.withOpacity(0.82),
            border: const Border(
              bottom: BorderSide(color: FitCoreColors.borderSubtle),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: _buildLeading(context),
              ),
              Text(title, style: textTheme.titleMedium),
              Align(
                alignment: Alignment.centerRight,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _HeaderIconButton(
                        onPressed: onNotifications,
                        icon: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(Icons.notifications_outlined),
                            if (hasUnread)
                              const Positioned(
                                right: -1,
                                top: -1,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: FitCoreColors.danger,
                                    shape: BoxShape.circle,
                                  ),
                                  child: SizedBox(width: 8, height: 8),
                                ),
                              ),
                          ],
                        ),
                        tooltip: 'Notifications',
                      ),
                      const SizedBox(width: 8),
                      _HeaderIconButton(
                        onPressed: onSettings,
                        icon: const Icon(Icons.settings_outlined),
                        tooltip: 'Settings',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeading(BuildContext context) {
    if (showBack) {
      final isRtl = Directionality.of(context) == TextDirection.rtl;
      return _HeaderIconButton(
        onPressed: onBack,
        icon: Icon(
          isRtl
              ? Icons.arrow_forward_ios_rounded
              : Icons.arrow_back_ios_new_rounded,
        ),
        tooltip: 'Back',
      );
    }
    if (showLogo) {
      return Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [FitCoreColors.accentViolet, FitCoreColors.accentCoral],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: FitCoreColors.borderSubtle),
        ),
        child: const Icon(Icons.bolt_rounded, size: 18, color: Colors.white),
      );
    }
    return const SizedBox(width: 34, height: 34);
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.onPressed,
    required this.icon,
    required this.tooltip,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FitCoreColors.surfaceElevated,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Tooltip(
            message: tooltip,
            child: IconTheme(
              data: const IconThemeData(
                color: FitCoreColors.textPrimary,
                size: 20,
              ),
              child: Center(child: icon),
            ),
          ),
        ),
      ),
    );
  }
}
