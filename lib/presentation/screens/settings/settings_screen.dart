import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/presentation/widgets/fitcore_header.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isFa = Localizations.localeOf(context).languageCode == 'fa';
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: FitCoreColors.background,
      body: SafeArea(
        child: Column(
          children: [
            FitCoreHeader(
              title: isFa ? 'تنظیمات و پروفایل' : 'Settings & Profile',
              showBack: true,
              onBack: () => context.pop(),
              onSettings: () {},
              onNotifications: () {},
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                children: [
                  _HeroCard(isFa: isFa),
                  const SizedBox(height: 18),
                  _Section(
                    title: 'ACCOUNT',
                    items: [
                      _row(context, isFa ? 'اطلاعات شخصی' : 'Personal Info'),
                      _row(
                        context,
                        isFa ? 'سلامت و پزشکی' : 'Health & Medical',
                      ),
                      _row(
                        context,
                        isFa ? 'اهداف ورزشی' : 'Sports & Fitness Goals',
                      ),
                      _row(
                        context,
                        isFa ? 'ترجیحات تغذیه' : 'Nutrition Preferences',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _Section(
                    title: 'PREFERENCES',
                    items: [
                      _row(context, isFa ? 'اعلان‌ها' : 'Notifications'),
                      _row(context, isFa ? 'حریم خصوصی' : 'Privacy'),
                      _row(context, isFa ? 'صدا و ویبره' : 'Sound & Vibration'),
                      _appearanceRow(
                        context: context,
                        isFa: isFa,
                        selectedMode: themeProvider.themeMode,
                        onMode: themeProvider.setThemeMode,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _Section(
                    title: 'SUPPORT',
                    items: [
                      _row(
                        context,
                        isFa ? 'راهنما و سوالات پرتکرار' : 'Help & FAQ',
                      ),
                      _row(
                        context,
                        isFa ? 'ارتباط با پشتیبانی' : 'Contact Support',
                      ),
                      _row(
                        context,
                        isFa ? 'امتیاز به FitCore' : 'Rate FitCore',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _Section(
                    title: 'ABOUT',
                    items: [
                      _row(
                        context,
                        isFa ? 'شرایط استفاده' : 'Terms of Service',
                      ),
                      _row(
                        context,
                        isFa ? 'سیاست حریم خصوصی' : 'Privacy Policy',
                      ),
                      _captionRow(isFa ? 'نسخه 2.1.0' : 'Version 2.1.0'),
                    ],
                  ),
                  const SizedBox(height: 22),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      isFa ? 'خروج از حساب' : 'Log Out',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: FitCoreColors.accentAmber,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _onDeleteAccount(context, isFa: isFa),
                    child: Text(
                      isFa ? 'حذف حساب کاربری' : 'Delete Account',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFFD76075),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _row(BuildContext context, String text) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(text),
      trailing: Icon(
        isRtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
        color: FitCoreColors.textSecondary,
      ),
      onTap: () {},
    );
  }

  static Widget _captionRow(String text) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        text,
        style: const TextStyle(
          color: FitCoreColors.textSecondary,
          fontSize: 12,
        ),
      ),
      onTap: () {},
    );
  }

  static Widget _appearanceRow({
    required BuildContext context,
    required bool isFa,
    required ThemeMode selectedMode,
    required ValueChanged<ThemeMode> onMode,
  }) {
    final label = isFa ? 'ظاهر' : 'Appearance';
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _modeChip(
                context,
                isFa ? 'تاریک' : 'Dark',
                selectedMode == ThemeMode.dark,
                () => onMode(ThemeMode.dark),
              ),
              _modeChip(
                context,
                isFa ? 'روشن' : 'Light',
                selectedMode == ThemeMode.light,
                () => onMode(ThemeMode.light),
              ),
              _modeChip(
                context,
                isFa ? 'سیستم' : 'System',
                selectedMode == ThemeMode.system,
                () => onMode(ThemeMode.system),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _modeChip(
    BuildContext context,
    String text,
    bool selected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? FitCoreColors.accentViolet.withOpacity(0.18)
              : FitCoreColors.surfaceElevated,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? FitCoreColors.accentViolet
                : FitCoreColors.borderSubtle,
          ),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: selected
                ? FitCoreColors.accentViolet
                : FitCoreColors.textPrimary,
          ),
        ),
      ),
    );
  }

  static Future<void> _onDeleteAccount(
    BuildContext context, {
    required bool isFa,
  }) async {
    final first = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: FitCoreColors.surface,
          title: Text(isFa ? 'حذف حساب؟' : 'Delete account?'),
          content: Text(
            isFa
                ? 'این عملیات قابل بازگشت نیست.'
                : 'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(isFa ? 'انصراف' : 'Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                isFa ? 'ادامه' : 'Continue',
                style: const TextStyle(color: FitCoreColors.danger),
              ),
            ),
          ],
        );
      },
    );

    if (first != true || !context.mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: FitCoreColors.surface,
          title: Text(isFa ? 'تایید نهایی' : 'Final confirmation'),
          content: Text(
            isFa
                ? 'برای حذف، دوباره تایید کن.'
                : 'Confirm again to permanently delete your account.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(isFa ? 'بازگشت' : 'Back'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                isFa ? 'حذف' : 'Delete',
                style: const TextStyle(color: FitCoreColors.danger),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.isFa});

  final bool isFa;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: FitCoreColors.borderSubtle),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8B6FFF), Color(0xFF1C1C26)],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFAE99FF), Color(0xFF8B6FFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x668B6FFF),
                  blurRadius: 18,
                  spreadRadius: 3,
                ),
              ],
              border: Border.all(color: const Color(0x99FFFFFF), width: 2),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 46,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Shaya Moobi',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            isFa ? 'سطح متوسط · ۲ سال' : 'Intermediate · 2 Years',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFB8A5FF)),
              foregroundColor: Colors.white,
            ),
            child: Text(isFa ? 'ویرایش پروفایل' : 'Edit Profile'),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.items});

  final String title;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      decoration: BoxDecoration(
        color: FitCoreColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: FitCoreColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: FitCoreColors.textSecondary,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          ...items,
        ],
      ),
    );
  }
}
