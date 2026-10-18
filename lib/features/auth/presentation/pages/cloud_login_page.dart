import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/routing/route_names.dart';
import '../../../../core/supabase/supabase_sync_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../main.dart';

class CloudLoginPage extends ConsumerStatefulWidget {
  const CloudLoginPage({super.key});

  @override
  ConsumerState<CloudLoginPage> createState() => _CloudLoginPageState();
}

class _CloudLoginPageState extends ConsumerState<CloudLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMsg;

  final _supabase = Supabase.instance.client;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMsg = 'Please enter your email and password.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    try {
      if (_isSignUp) {
        final res = await _supabase.auth.signUp(email: email, password: password);
        if (mounted) {
          if (res.session != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account created and signed in successfully!'),
              ),
            );
            _triggerHistoricalSync();
            _navigateOnSuccess();
          } else {
            // Confirmation email is still enabled on the Supabase project
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Account created! Please check your email to verify before signing in.',
                ),
                duration: Duration(seconds: 4),
              ),
            );
            setState(() {
              _isSignUp = false;
            });
          }
        }
      } else {
        await _supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
        if (mounted) {
          _triggerHistoricalSync();
          _navigateOnSuccess();
        }
      }
    } on AuthException catch (e) {
      if (mounted) setState(() => _errorMsg = e.message);
    } catch (e) {
      if (mounted) {
        setState(() => _errorMsg = 'Something went wrong: ${e.toString()}');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Fire-and-forget historical sync — pushes all local transactions to cloud.
  void _triggerHistoricalSync() {
    final syncService = ref.read(supabaseSyncServiceProvider);
    // ignore: discarded_futures
    syncService.syncAllLocalTransactions();
  }

  void _navigateOnSuccess() {
    final prefs = ref.read(preferencesServiceProvider);
    if (!prefs.isPermissionsCompleted()) {
      context.goNamed(RouteNames.permissions);
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(onPressed: _navigateOnSuccess),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpacing.h24,

              // Cloud icon
              Center(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.cloud_outlined,
                    size: 56,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              AppSpacing.h24,

              Text(
                _isSignUp ? 'Create Cloud Account' : 'Sign In to Cloud',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.h8,
              Text(
                _isSignUp
                    ? 'Sync your data across devices and access community rules'
                    : 'Sign in to restore your cloud backup or sync data',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.h40,

              // Email field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              AppSpacing.h16,

              // Password field
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _handleEmailAuth(),
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // Error message
              if (_errorMsg != null) ...[
                AppSpacing.h12,
                Text(
                  _errorMsg!,
                  style: const TextStyle(color: AppColors.error, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
              AppSpacing.h24,

              // Primary CTA
              FilledButton(
                onPressed: _isLoading ? null : _handleEmailAuth,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _isSignUp ? 'Create Account' : 'Sign In',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
              AppSpacing.h12,

              // Toggle sign in / sign up
              TextButton(
                onPressed: () => setState(() {
                  _isSignUp = !_isSignUp;
                  _errorMsg = null;
                }),
                child: Text(
                  _isSignUp
                      ? 'Already have an account? Sign In'
                      : "Don't have an account? Sign Up",
                ),
              ),

              // Divider
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Text(
                        'OR',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
              ),

              // Continue Offline
              OutlinedButton.icon(
                onPressed: _navigateOnSuccess,
                icon: const Icon(Icons.phone_android_outlined),
                label: const Text('Continue Offline (Skip Cloud)'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              AppSpacing.h24,
              Text(
                'Your data stays on-device. Cloud features are optional.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
