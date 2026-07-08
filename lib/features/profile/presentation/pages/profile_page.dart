import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../main.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/di/repository_providers.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prefs = ref.watch(preferencesServiceProvider);
    final themeMode = prefs.getThemeMode();
    final biometricEnabled = prefs.isBiometricEnabled();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile & Settings',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.h4,
                    Text(
                      'Manage your preferences and security',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Avatar Card ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: AppRadius.borderLg,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'FinSight User',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'AI-Powered Financial Coach',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: AppSpacing.h24),

            // ── Appearance ──
            SliverToBoxAdapter(
              child: _SettingsSection(
                title: 'Appearance',
                children: [
                  _SettingsTile(
                    icon: Icons.palette_rounded,
                    title: 'Theme',
                    subtitle: themeMode == 'light'
                        ? 'Light'
                        : themeMode == 'dark'
                            ? 'Dark'
                            : 'System Default',
                    trailing: DropdownButton<String>(
                      value: themeMode,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 'system', child: Text('System')),
                        DropdownMenuItem(value: 'light', child: Text('Light')),
                        DropdownMenuItem(value: 'dark', child: Text('Dark')),
                      ],
                      onChanged: (v) async {
                        if (v != null) {
                          await prefs.setThemeMode(v);
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ── Security ──
            SliverToBoxAdapter(
              child: _SettingsSection(
                title: 'Security',
                children: [
                  _SettingsTile(
                    icon: Icons.fingerprint_rounded,
                    title: 'Biometric Lock',
                    subtitle: biometricEnabled ? 'Enabled' : 'Disabled',
                    trailing: Switch(
                      value: biometricEnabled,
                      onChanged: (v) async {
                        final permService =
                            ref.read(permissionServiceProvider);
                        if (v) {
                          final success =
                              await permService.authenticateWithBiometrics(
                            reason: 'Enable biometric lock for FinSight',
                          );
                          if (success) {
                            await prefs.setBiometricEnabled(true);
                          }
                        } else {
                          await prefs.setBiometricEnabled(false);
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.lock_outline_rounded,
                    title: 'Change PIN',
                    subtitle: 'Update your app passcode',
                    onTap: () {
                      // Clear stored pin, navigate to auth which will handle set mode
                      final rawPrefs = ref.read(sharedPreferencesProvider);
                      rawPrefs.remove('user_pin');
                      if (context.mounted) {
                        context.goNamed(RouteNames.auth);
                      }
                    },
                  ),
                ],
              ),
            ),

            // ── Data & Storage ──
            SliverToBoxAdapter(
              child: _SettingsSection(
                title: 'Data & Storage',
                children: [
                  _SettingsTile(
                    icon: Icons.sync_rounded,
                    title: 'Re-sync SMS',
                    subtitle: 'Force re-import all financial SMS messages',
                    onTap: () async {
                      final prefs = ref.read(preferencesServiceProvider);
                      await prefs.setLastSmsSyncTimestamp(0);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Sync reset. Go to Dashboard and pull to refresh.',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            // ── About ──
            const SliverToBoxAdapter(
              child: _SettingsSection(
                title: 'About',
                children: [
                  _SettingsTile(
                    icon: Icons.info_outline_rounded,
                    title: 'App Version',
                    subtitle: '1.0.0 — FinSight AI',
                  ),
                  _SettingsTile(
                    icon: Icons.auto_awesome_rounded,
                    title: 'Powered By',
                    subtitle: 'On-device SMS Intelligence • PennyWise Engine',
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Text(
              title.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.onSurfaceVariantDark,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: AppRadius.borderLg,
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1)
                    Divider(
                      height: 1,
                      indent: 56,
                      color: theme.dividerColor,
                    ),
                ],
              ],
            ),
          ),
          AppSpacing.h16,
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: theme.colorScheme.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(color: theme.hintColor, fontSize: 12),
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? Icon(
                  Icons.chevron_right_rounded,
                  color: theme.hintColor,
                )
              : null),
      onTap: onTap,
    );
  }
}
