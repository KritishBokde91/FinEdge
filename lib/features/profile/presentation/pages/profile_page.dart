import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../main.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/di/repository_providers.dart';
import '../../../../core/di/billing_providers.dart';
import '../../../../features/billing/domain/entities/purchase_result.dart';
import '../../../../features/billing/data/repositories/simulated_billing_repository.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../core/di/backup_providers.dart';
import '../../../../features/backup/domain/entities/backup_models.dart';
import '../../../../core/di/contacts_providers.dart';
import '../../../../core/supabase/supabase_client_provider.dart';

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
    final useContactsForVpa = prefs.useContactsForVpa();
    final isPro = ref.watch(isProProvider).value ?? false;
    final gateway = ref.watch(purchaseGatewayProvider);

    final cloudUserAsync = ref.watch(currentSupabaseUserProvider);
    final cloudUser = cloudUserAsync.value ?? ref.watch(currentUserProvider);

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
                        color: theme.colorScheme.onSurfaceVariant,
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
                        child: Icon(
                          cloudUser != null ? Icons.cloud_done_rounded : Icons.person_rounded,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    cloudUser?.email?.split('@').first ?? 'FinSight User',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isPro) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: AppRadius.borderSm,
                                    ),
                                    child: const Text(
                                      'PRO',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cloudUser != null
                                  ? '☁️ ${cloudUser.email}'
                                  : (isPro ? 'Pro Member' : 'AI-Powered Financial Coach (Offline)'),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (!isPro)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber, Colors.orange],
                      ),
                      borderRadius: AppRadius.borderLg,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.stars_rounded,
                          color: Colors.black,
                          size: 36,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Upgrade to Premium',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Unlock statement importing, rules, and AI.',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              context.pushNamed(RouteNames.upgrade),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppRadius.borderMd,
                            ),
                          ),
                          child: const Text('Upgrade'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: AppSpacing.h24),

            // ── Financial Management ──
            SliverToBoxAdapter(
              child: _SettingsSection(
                title: 'Financial Management',
                children: [
                  _SettingsTile(
                    icon: Icons.subscriptions_rounded,
                    title: 'Recurring Subscriptions',
                    subtitle: 'Track active subscriptions and predict charges',
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.pushNamed(RouteNames.subscriptions),
                  ),
                  _SettingsTile(
                    icon: Icons.rule_rounded,
                    title: 'Classification Rules',
                    subtitle: 'Automated rules for categories, merchants, and tags',
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.pushNamed(RouteNames.rules),
                  ),
                ],
              ),
            ),

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
                        DropdownMenuItem(
                          value: 'system',
                          child: Text('System'),
                        ),
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
                        final rawPrefs = ref.read(sharedPreferencesProvider);
                        final pin = rawPrefs.getString('user_pin');
                        if (v && (pin == null || pin.isEmpty)) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please set a security PIN first to enable Biometric Lock.',
                                ),
                              ),
                            );
                            context.goNamed(RouteNames.auth);
                          }
                          return;
                        }

                        final permService = ref.read(permissionServiceProvider);
                        if (v) {
                          final success = await permService
                              .authenticateWithBiometrics(
                                reason: 'Enable biometric lock for FinSight',
                              );
                          if (success) {
                            await prefs.setBiometricEnabled(true);
                          } else if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Biometric authentication is unavailable on this screen right now.',
                                ),
                              ),
                            );
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
                      if (context.mounted) {
                        context.pushNamed(
                          RouteNames.auth,
                          queryParameters: {'change': 'true'},
                        );
                      }
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.contacts_rounded,
                    title: 'Resolve UPI VPAs via Contacts',
                    subtitle: useContactsForVpa ? 'Enabled' : 'Disabled',
                    trailing: Switch(
                      value: useContactsForVpa,
                      onChanged: (v) async {
                        final permService = ref.read(permissionServiceProvider);
                        if (v) {
                          final granted = await permService
                              .requestContactsPermission();
                          if (granted) {
                            await prefs.setUseContactsForVpa(true);
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Contacts permission is required to resolve VPAs.',
                                  ),
                                ),
                              );
                            }
                          }
                        } else {
                          await prefs.setUseContactsForVpa(false);
                          ref.read(contactsResolverProvider).clearCache();
                        }
                        setState(() {});
                      },
                    ),
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
                  _SettingsTile(
                    icon: Icons.restore_rounded,
                    title: 'Restore Store Purchases',
                    subtitle: 'Re-check Play Store premium entitlements',
                    onTap: () async {
                      final result = await gateway.refresh();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              result is PurchaseSuccess
                                  ? 'Store entitlements verified successfully.'
                                  : 'Failed to restore: No active purchases.',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  if (gateway is SimulatedBillingRepository)
                    _SettingsTile(
                      icon: Icons.bug_report_outlined,
                      title: 'Reset Pro Status (Simulated)',
                      subtitle: 'Revoke and reset to Free tier',
                      onTap: () async {
                        await gateway.debugResetEntitlement();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pro status has been reset.'),
                            ),
                          );
                        }
                      },
                    ),
                  _SettingsTile(
                    icon: Icons.table_chart_rounded,
                    title: 'Export Transactions CSV',
                    subtitle: 'Export spreadsheet of all recorded transactions',
                    onTap: () async {
                      try {
                        final txRepo = ref.read(transactionRepositoryProvider);
                        final transactions = await txRepo.watchAllTransactions().first;
                        if (transactions.isEmpty) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('No transactions to export.')),
                            );
                          }
                          return;
                        }

                        final csvService = await ref.read(csvExporterServiceProvider.future);
                        final filePath = await csvService.exportTransactionEntities(transactions);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('CSV Exported: ${filePath.split('/').last}')),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('CSV Export failed: $e')),
                          );
                        }
                      }
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.backup_rounded,
                    title: 'Export Backup JSON',
                    subtitle: 'Save database backup to documents folder',
                    onTap: () async {
                      final exporter = ref.read(backupExporterProvider);
                      final result = await exporter.exportBackup();
                      if (context.mounted) {
                        if (result is ExportSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Backup exported: ${result.file.path.split('/').last}',
                              ),
                            ),
                          );
                        } else if (result is ExportError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result.message)),
                          );
                        }
                      }
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.settings_backup_restore_rounded,
                    title: 'Import Backup JSON',
                    subtitle: 'Restore database and preferences from files',
                    onTap: () async {
                      final importer = ref.read(backupImporterProvider);
                      final directory =
                          await getApplicationDocumentsDirectory();
                      final dir = Directory(directory.path);
                      final files =
                          dir
                              .listSync()
                              .where(
                                (f) =>
                                    f is File &&
                                    f.path.contains('finsight_backup_'),
                              )
                              .toList()
                            ..sort((a, b) => b.path.compareTo(a.path));

                      if (context.mounted) {
                        if (files.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'No backup files found in documents folder.',
                              ),
                            ),
                          );
                          return;
                        }

                        final latestFile = files.first as File;
                        final jsonContent = await latestFile.readAsString();
                        final result = await importer.importBackup(jsonContent);

                        if (context.mounted) {
                          if (result is ImportSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Import successful! Loaded ${result.importedTransactions} transactions, ${result.importedBudgets} budgets, ${result.importedGoals} goals.',
                                ),
                              ),
                            );
                            setState(() {});
                          } else if (result is ImportError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result.message)),
                            );
                          }
                        }
                      }
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.cloud_upload_rounded,
                    title: 'Cloud Backup (Supabase)',
                    subtitle: 'Upload encrypted snapshot to cloud storage',
                    onTap: () async {
                      final client = ref.read(supabaseClientProvider);
                      final user = client.auth.currentUser;
                      if (user == null) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Please sign in to your cloud account first.',
                              ),
                              action: SnackBarAction(
                                label: 'Sign In',
                                onPressed: () =>
                                    context.push('/cloud-login'),
                              ),
                            ),
                          );
                        }
                        return;
                      }

                      final exporter = ref.read(backupExporterProvider);
                      final exportResult = await exporter.exportBackup();
                      if (exportResult is! ExportSuccess) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to generate local backup snapshot.'),
                            ),
                          );
                        }
                        return;
                      }

                      try {
                        final jsonStr = await exportResult.file.readAsString();
                        final payload = BackupPayload.fromJson(
                          jsonDecode(jsonStr) as Map<String, dynamic>,
                        );
                        final cloudRepo = ref.read(supabaseBackupRepositoryProvider);
                        final path = await cloudRepo.uploadBackup(payload);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Cloud backup uploaded! ($path)'),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Cloud backup failed: $e')),
                          );
                        }
                      }
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.cloud_download_rounded,
                    title: 'Restore from Cloud',
                    subtitle: 'Fetch and import your latest Supabase backup',
                    onTap: () async {
                      final client = ref.read(supabaseClientProvider);
                      final user = client.auth.currentUser;
                      if (user == null) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Please sign in to your cloud account first.',
                              ),
                              action: SnackBarAction(
                                label: 'Sign In',
                                onPressed: () =>
                                    context.push('/cloud-login'),
                              ),
                            ),
                          );
                        }
                        return;
                      }

                      try {
                        final cloudRepo = ref.read(supabaseBackupRepositoryProvider);
                        final payload = await cloudRepo.downloadLatestBackup();
                        if (payload == null) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No cloud backups found for your account.'),
                              ),
                            );
                          }
                          return;
                        }

                        final importer = ref.read(backupImporterProvider);
                        final jsonStr = jsonEncode(payload.toJson());
                        final importResult = await importer.importBackup(jsonStr);

                        if (context.mounted) {
                          if (importResult is ImportSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Restored! ${importResult.importedTransactions} transactions imported.',
                                ),
                              ),
                            );
                            setState(() {});
                          } else if (importResult is ImportError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(importResult.message)),
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Cloud restore failed: $e')),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),

            // ── Cloud Account ──
            SliverToBoxAdapter(
              child: _SettingsSection(
                title: 'Cloud Account',
                children: [
                  Consumer(
                    builder: (context, ref, _) {
                      final cloudUser = ref.watch(currentUserProvider);
                      if (cloudUser != null) {
                        return Column(
                          children: [
                            _SettingsTile(
                              icon: Icons.account_circle_rounded,
                              title: 'Signed In',
                              subtitle: cloudUser.email ?? 'Connected',
                            ),
                            _SettingsTile(
                              icon: Icons.logout_rounded,
                              title: 'Sign Out of Cloud',
                              subtitle: 'Disconnect from Supabase sync',
                              onTap: () async {
                                final client = ref.read(supabaseClientProvider);
                                await client.auth.signOut();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Signed out of cloud account.'),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      }
                      return _SettingsTile(
                        icon: Icons.cloud_outlined,
                        title: 'Connect Cloud Account',
                        subtitle: 'Sign in to enable cross-device backup & sync',
                        onTap: () => context.push('/cloud-login'),
                      );
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
                    subtitle: 'On-device SMS Intelligence • FinSight Engine',
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
                color: theme.colorScheme.onSurfaceVariant,
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
                    Divider(height: 1, indent: 56, color: theme.dividerColor),
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
      trailing:
          trailing ??
          (onTap != null
              ? Icon(Icons.chevron_right_rounded, color: theme.hintColor)
              : null),
      onTap: onTap,
    );
  }
}
