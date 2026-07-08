import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/repository_providers.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../main.dart';
import '../../../../shared/widgets/buttons/app_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class PermissionsPage extends ConsumerStatefulWidget {
  const PermissionsPage({super.key});

  @override
  ConsumerState<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends ConsumerState<PermissionsPage> {
  bool _smsGranted = false;
  bool _notificationsGranted = false;
  bool _biometricsEnabled = false;
  bool _canCheckBiometrics = false;

  @override
  void initState() {
    super.initState();
    _loadPermissionState();
  }

  Future<void> _loadPermissionState() async {
    final permissionService = ref.read(permissionServiceProvider);
    final canCheck = await permissionService.canCheckBiometrics();
    final smsGranted = await permissionService.checkSmsPermission();
    final notificationsGranted = await permissionService
        .checkNotificationPermission();
    final biometricsEnabled = ref
        .read(preferencesServiceProvider)
        .isBiometricEnabled();
    if (!mounted) return;
    setState(() {
      _canCheckBiometrics = canCheck;
      _smsGranted = smsGranted;
      _notificationsGranted = notificationsGranted;
      _biometricsEnabled = biometricsEnabled;
    });
  }

  Future<void> _requestSms() async {
    final permissionService = ref.read(permissionServiceProvider);
    final granted = await permissionService.requestSmsPermission();
    if (!mounted) return;
    setState(() {
      _smsGranted = granted;
    });
  }

  Future<void> _requestNotifications() async {
    final permissionService = ref.read(permissionServiceProvider);
    final granted = await permissionService.requestNotificationPermission();
    if (!mounted) return;
    setState(() {
      _notificationsGranted = granted;
    });
  }

  Future<void> _toggleBiometrics(bool enabled) async {
    if (enabled) {
      final permissionService = ref.read(permissionServiceProvider);
      final success = await permissionService.authenticateWithBiometrics(
        reason: 'Authenticate to enable biometric passcode locks',
      );
      if (success) {
        await ref.read(preferencesServiceProvider).setBiometricEnabled(true);
        setState(() {
          _biometricsEnabled = true;
        });
      }
    } else {
      await ref.read(preferencesServiceProvider).setBiometricEnabled(false);
      setState(() {
        _biometricsEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.h40,
              Text(
                'System Security & Permissions',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSpacing.h8,
              Text(
                'FinSight operates completely on-device. Your SMS data never leaves this machine.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                ),
              ),
              AppSpacing.h32,

              // --- SMS Permission Row ---
              _buildPermissionTile(
                icon: Icons.sms_rounded,
                title: 'Financial SMS Read Access',
                description:
                    'Allows our local classifier to automatically parse and extract transactional patterns.',
                isGranted: _smsGranted,
                onTap: _requestSms,
              ),
              AppSpacing.h24,

              // --- Notifications Row ---
              _buildPermissionTile(
                icon: Icons.notifications_rounded,
                title: 'Instant Alerts & Coaching Notification',
                description:
                    'Alerts you instantly if our model flags potential transaction anomalies.',
                isGranted: _notificationsGranted,
                onTap: _requestNotifications,
              ),
              AppSpacing.h24,

              // --- Biometrics Row ---
              if (_canCheckBiometrics) ...[
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.fingerprint,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    AppSpacing.w16,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enable Biometric Lock',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Secure your dashboard using fingerprints or face unlock.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.onSurfaceVariantDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: _biometricsEnabled,
                      activeColor: theme.colorScheme.primary,
                      onChanged: _toggleBiometrics,
                    ),
                  ],
                ),
                AppSpacing.h40,
              ],

              const Spacer(),
              AppButton(
                text: 'Continue',
                onPressed: () {
                  context.goNamed(RouteNames.home);
                },
              ),
              AppSpacing.h24,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionTile({
    required IconData icon,
    required String title,
    required String description,
    required bool isGranted,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 24),
          ),
          AppSpacing.w16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariantDark,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isGranted
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked,
            color: isGranted
                ? AppColors.success
                : AppColors.onSurfaceVariantDark,
            size: 28,
          ),
        ],
      ),
    );
  }
}
