import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../main.dart';
import '../../../../shared/widgets/inputs/app_otp_field.dart';
import '../../../../shared/widgets/buttons/app_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  bool _isLoading = false;
  String? _errorMsg;
  bool _isSetMode = false;
  bool _isConfirmStep = false;
  String? _firstEntry;
  String? _storedPin;

  static const String _pinKey = 'user_pin';

  @override
  void initState() {
    super.initState();
    _loadStoredPin();
  }

  Future<void> _loadStoredPin() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final pin = prefs.getString(_pinKey);
    setState(() {
      _storedPin = pin;
      _isSetMode = pin == null;
    });
  }

  void _handlePinEntry(String code) async {
    if (_isSetMode) {
      _handleSetPin(code);
    } else {
      _verifyPasscode(code);
    }
  }

  void _handleSetPin(String code) {
    if (!_isConfirmStep) {
      // First entry — store it and ask for confirmation
      setState(() {
        _firstEntry = code;
        _isConfirmStep = true;
        _errorMsg = null;
      });
    } else {
      // Confirm step — check if it matches the first entry
      if (code == _firstEntry) {
        _saveAndProceed(code);
      } else {
        setState(() {
          _errorMsg = 'PINs do not match. Please try again.';
          _isConfirmStep = false;
          _firstEntry = null;
        });
      }
    }
  }

  Future<void> _saveAndProceed(String pin) async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_pinKey, pin);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      context.goNamed(RouteNames.home);
    }
  }

  void _verifyPasscode(String code) async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    // Brief delay to simulate validation
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (code == _storedPin) {
        context.goNamed(RouteNames.home);
      } else {
        setState(() {
          _errorMsg = 'Incorrect passcode PIN. Please try again.';
        });
      }
    }
  }

  String get _titleText {
    if (_isSetMode) {
      return _isConfirmStep ? 'Confirm Your PIN' : 'Create Security PIN';
    }
    return 'Enter Security Passcode';
  }

  String get _subtitleText {
    if (_isSetMode) {
      return _isConfirmStep
          ? 'Re-enter your 4-digit PIN to confirm'
          : 'Set a 4-digit PIN to secure FinSight';
    }
    return 'Enter your 4-digit PIN to access FinSight vaults';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isSetMode
                      ? Icons.lock_open_rounded
                      : Icons.lock_outline_rounded,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
              ),
              AppSpacing.h24,
              Text(
                _titleText,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSpacing.h8,
              Text(
                _subtitleText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.h40,

              AppOtpField(
                key: ValueKey('$_isSetMode-$_isConfirmStep-$_errorMsg'),
                length: 4,
                onCompleted: _handlePinEntry,
              ),

              if (_errorMsg != null) ...[
                AppSpacing.h16,
                Text(
                  _errorMsg!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],

              if (_isLoading) ...[
                AppSpacing.h24,
                const CircularProgressIndicator(),
              ],

              const Spacer(),
              AppButton(
                text: 'Continue Offline',
                type: ButtonType.ghost,
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
}
