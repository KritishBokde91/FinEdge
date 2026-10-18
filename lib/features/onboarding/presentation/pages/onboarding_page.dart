import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../main.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../shared/widgets/buttons/app_button.dart';
import '../../../../core/theme/app_spacing.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'On-Device Financial SMS Intelligence',
      'description':
          'FinSight parses your financial SMS messages completely offline, keeping your private assets and transactions 100% secure.',
      'icon': 'auto_awesome',
    },
    {
      'title': 'Local ML Classifiers',
      'description':
          'Our integrated on-device Random Forest and XGBoost models organize and group your cash flows without transferring byte packets to cloud backends.',
      'icon': 'security',
    },
    {
      'title': 'AI Financial Coach',
      'description':
          'Receive smart tips, budget warnings, and transaction breakdowns directly in local chats.',
      'icon': 'chat_bubble',
    },
  ];

  Future<void> _completeOnboarding({bool openCloudLogin = false}) async {
    final prefs = ref.read(preferencesServiceProvider);
    await prefs.setOnboardingCompleted(true);
    if (!mounted) return;

    if (openCloudLogin) {
      // Navigate to cloud login first, which then proceeds to permissions/home
      context.goNamed(RouteNames.cloudLogin);
    } else {
      context.goNamed(RouteNames.permissions);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: AppButton(
                  text: 'Skip',
                  type: ButtonType.ghost,
                  onPressed: _completeOnboarding,
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = _onboardingData[index];
                  IconData pageIcon;
                  switch (item['icon']) {
                    case 'security':
                      pageIcon = Icons.security_rounded;
                      break;
                    case 'chat_bubble':
                      pageIcon = Icons.chat_bubble_rounded;
                      break;
                    default:
                      pageIcon = Icons.auto_awesome_rounded;
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xxl,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            pageIcon,
                            size: 64,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        AppSpacing.h40,
                        Text(
                          item['title']!,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        AppSpacing.h16,
                        Text(
                          item['description']!,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingData.length,
                (index) => Container(
                  width: _currentIndex == index ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withOpacity(0.24),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            AppSpacing.h40,
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxl,
                vertical: AppSpacing.lg,
              ),
              child: _currentIndex == _onboardingData.length - 1
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppButton(
                          text: 'Sign In / Create Account',
                          icon: Icons.cloud_outlined,
                          onPressed: () => _completeOnboarding(openCloudLogin: true),
                        ),
                        AppSpacing.h12,
                        AppButton(
                          text: 'Continue Offline (No Account)',
                          type: ButtonType.outlined,
                          icon: Icons.phone_android_outlined,
                          onPressed: () => _completeOnboarding(openCloudLogin: false),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        if (_currentIndex > 0)
                          Expanded(
                            child: AppButton(
                              text: 'Back',
                              type: ButtonType.outlined,
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          )
                        else
                          const Spacer(),
                        AppSpacing.w16,
                        Expanded(
                          child: AppButton(
                            text: 'Next',
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
            AppSpacing.h24,
          ],
        ),
      ),
    );
  }
}
