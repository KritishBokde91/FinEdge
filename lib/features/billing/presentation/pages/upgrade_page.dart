import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/billing_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../domain/entities/pro_product.dart';
import '../../domain/entities/purchase_result.dart';
import '../../domain/repositories/purchase_launcher.dart';

class UpgradePage extends ConsumerStatefulWidget {
  const UpgradePage({super.key});

  @override
  ConsumerState<UpgradePage> createState() => _UpgradePageState();
}

class _UpgradePageState extends ConsumerState<UpgradePage> {
  ProProduct? _selectedProduct;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _proFeatures = [
    {
      'title': 'Deep AI Financial Coaching',
      'subtitle': 'Personalized insights and NLP automated rules on SMS sync.',
      'icon': Icons.auto_awesome_rounded,
    },
    {
      'title': 'Unlimited Budgets & Goals',
      'subtitle': 'Set tracking plans for as many categories as you want.',
      'icon': Icons.account_balance_wallet_rounded,
    },
    {
      'title': 'PDF Statement Import',
      'subtitle': 'Import monthly statements from any bank (Free: 1 statement/mo).',
      'icon': Icons.picture_as_pdf_rounded,
    },
    {
      'title': 'Advanced Transaction Rules',
      'subtitle': 'Customize categorization matching rules (Free limit: 3).',
      'icon': Icons.settings_suggest_rounded,
    },
    {
      'title': 'Unlimited CSV & Excel Export',
      'subtitle': 'Export complete historical ledger data (Free limit: 100 rows).',
      'icon': Icons.download_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final productsAsync = ref.watch(productsProvider);
    final gateway = ref.watch(purchaseGatewayProvider);

    return Scaffold(
      body: Stack(
        children: [
          // ── Background Gradient ──
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0F172A),
                    theme.colorScheme.primary.withOpacity(0.15),
                    const Color(0xFF020617),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          SafeArea(
            child: CustomScrollView(
              slivers: [
                // ── Close Button App Bar ──
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                        onPressed: () => context.pop(),
                      ),
                    ],
                  ),
                ),

                // ── Title & Intro ──
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.stars_rounded,
                        color: Colors.amber,
                        size: 64,
                      ),
                      AppSpacing.h12,
                      Text(
                        'Unlock FinSight Pro',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSpacing.h8,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl,
                        ),
                        child: Text(
                          'Supercharge your financial intelligence with on-device AI rules and statement analytics.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      AppSpacing.h24,
                    ],
                  ),
                ),

                // ── Features List ──
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final feature = _proFeatures[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(0.12),
                                  borderRadius: AppRadius.borderMd,
                                ),
                                child: Icon(
                                  feature['icon'] as IconData,
                                  color: theme.colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      feature['title'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      feature['subtitle'] as String,
                                      style: const TextStyle(
                                        color: Colors.white60,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: _proFeatures.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: AppSpacing.h24),

                // ── Plans Catalog ──
                productsAsync.when(
                  data: (products) {
                    if (products.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            'No products available in this build.',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      );
                    }

                    // Auto-select best plan (Lifetime or Annual) on first load
                    if (_selectedProduct == null && products.isNotEmpty) {
                      // Prefer lifetime or annual
                      _selectedProduct = products.firstWhere(
                        (p) => p.type == ProductType.lifetime,
                        orElse: () => products.first,
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = products[index];
                            final isSelected = _selectedProduct?.key == product.key;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.md),
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedProduct = product),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? theme.colorScheme.primary.withOpacity(0.08)
                                        : Colors.white.withOpacity(0.03),
                                    borderRadius: AppRadius.borderLg,
                                    border: Border.all(
                                      color: isSelected
                                          ? theme.colorScheme.primary
                                          : Colors.white.withOpacity(0.1),
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(AppSpacing.lg),
                                  child: Row(
                                    children: [
                                      // Radio indicator
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isSelected
                                                ? theme.colorScheme.primary
                                                : Colors.white54,
                                            width: 2,
                                          ),
                                        ),
                                        child: isSelected
                                            ? Center(
                                                child: Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: theme.colorScheme.primary,
                                                  ),
                                                ),
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: AppSpacing.md),

                                      // Label/Plan Description
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _getPlanTitle(product.type),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              _getPlanSubtitle(product.type),
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Pricing
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            product.priceFormatted,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          if (product.originalPriceFormatted != null)
                                            Text(
                                              product.originalPriceFormatted!,
                                              style: const TextStyle(
                                                color: Colors.white54,
                                                decoration: TextDecoration.lineThrough,
                                                fontSize: 12,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: products.length,
                        ),
                      ),
                    );
                  },
                  loading: () => const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, _) => SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'Failed to load catalog: ${err.toString()}',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: AppSpacing.h24),

                // ── CTA purchase button ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      children: [
                        FilledButton(
                          onPressed: _selectedProduct == null || _isLoading
                              ? null
                              : () => _handlePurchase(gateway),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            backgroundColor: Colors.amber[600],
                            foregroundColor: Colors.black,
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppRadius.borderMd,
                            ),
                          ),
                          child: const Text(
                            'Unlock FinSight Pro Now',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        AppSpacing.h16,

                        // Restore link
                        TextButton(
                          onPressed: _isLoading ? null : () => _handleRestore(gateway),
                          child: const Text(
                            'Restore Purchases',
                            style: TextStyle(color: Colors.white54, fontSize: 13),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPlanTitle(ProductType type) {
    return switch (type) {
      ProductType.subscriptionMonthly => 'Monthly Subscription',
      ProductType.subscriptionAnnual => 'Annual Plan',
      ProductType.lifetime => 'Lifetime Founder SKU',
    };
  }

  String _getPlanSubtitle(ProductType type) {
    return switch (type) {
      ProductType.subscriptionMonthly => 'Billed monthly. Cancel anytime.',
      ProductType.subscriptionAnnual => 'Save 33% off monthly rate.',
      ProductType.lifetime => 'One-time payment. Forever Pro access.',
    };
  }

  Future<void> _handlePurchase(PurchaseLauncher gateway) async {
    if (_selectedProduct == null) return;
    setState(() => _isLoading = true);

    // Show simulated purchase sheet loader dialog
    _showSimulatedPurchaseLoader();

    final result = await gateway.launchPurchase(_selectedProduct!);

    if (!mounted) return;
    // Dismiss simulated sheet loader
    Navigator.pop(context);

    setState(() => _isLoading = false);

    if (result is PurchaseSuccess) {
      _showSuccessSheet();
    } else if (result is PurchaseFailed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Purchase failed: ${result.debugMessage}')),
      );
    }
  }

  Future<void> _handleRestore(PurchaseLauncher gateway) async {
    setState(() => _isLoading = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Checking store entitlements...')),
    );

    final result = await gateway.refresh();

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result is PurchaseSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entitlements restored successfully.')),
      );
      // Read latest Pro status and dismiss paywall if premium unlocked
      final isPro = ref.read(isProProvider).value ?? false;
      if (isPro) {
        context.pop();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No active entitlements found.')),
      );
    }
  }

  void _showSimulatedPurchaseLoader() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final theme = Theme.of(context);
        return Dialog(
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
          backgroundColor: const Color(0xFF0F172A),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Colors.amber),
                const SizedBox(height: 24),
                const Text(
                  'Connecting to Google Play...',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Verifying transaction detail offers securely',
                  style: TextStyle(
                    color: theme.hintColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessSheet() {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: const Color(0xFF0F172A),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 64,
              ),
              AppSpacing.h16,
              const Text(
                'Unlock Complete!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              AppSpacing.h8,
              const Text(
                'Welcome to FinSight Pro! You now have full access to statement parsing, advanced AI categorization, and unlimited tracking budgets.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              AppSpacing.h24,
              FilledButton(
                onPressed: () {
                  Navigator.pop(context); // Pop Success Sheet
                  this.context.pop(); // Pop Paywall Screen
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: AppColors.success,
                ),
                child: const Text('Get Started'),
              ),
            ],
          ),
        );
      },
    );
  }
}
