import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/design_system/design_system.dart';
import '../providers/auth_providers.dart';

/// Lumo Login Screen
/// Authentication should feel trustworthy.
/// Users can explore before committing — guest access is always visible.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _navigateAfterOAuth() async {
    final rawUser = Supabase.instance.client.auth.currentUser;
    final user = await ref.read(authRepositoryProvider).fetchUserWithRole(rawUser);
    if (!mounted) return;
    if (user?.isBroker == true) {
      context.go(LumoRoutes.brokerDashboard);
    } else {
      context.go(LumoRoutes.home);
    }
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(authNotifierProvider.notifier).signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    if (!success || !mounted) return;

    // Fetch role and route accordingly
    final rawUser = Supabase.instance.client.auth.currentUser;
    final user = await ref.read(authRepositoryProvider).fetchUserWithRole(rawUser);
    if (!mounted) return;
    if (user?.isBroker == true) {
      context.go(LumoRoutes.brokerDashboard);
    } else {
      context.go(LumoRoutes.home);
    }
  }

  Future<void> _signInWithGoogle() async {
    // OAuth result arrives via authStateChanges — navigation handled by splash/router
    await ref.read(authNotifierProvider.notifier).signInWithGoogle();
  }

  Future<void> _signInWithApple() async {
    await ref.read(authNotifierProvider.notifier).signInWithApple();
  }

  Future<void> _continueAsGuest() async {
    final success = await ref.read(authNotifierProvider.notifier).continueAsGuest();
    if (success && mounted) context.go(LumoRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final colors = Theme.of(context).colorScheme;
    final isLoading = authState.isLoading;

    // Show error if present
    ref.listen(authNotifierProvider, (_, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            behavior: SnackBarBehavior.floating,
            backgroundColor: colors.error,
          ),
        );
        ref.read(authNotifierProvider.notifier).clearError();
      }
    });

    // Navigate correctly when OAuth redirect completes
    ref.listen(authStateChangesProvider, (_, next) {
      next.whenData((user) {
        if (user != null) _navigateAfterOAuth();
      });
    });

    return Scaffold(
      backgroundColor: LumoColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: LumoSpacing.space24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: LumoSpacing.space64),

                // Header
                Text(
                  'Welcome\nback.',
                  style: LumoTypography.displayMedium.copyWith(
                    color: colors.onSurface,
                  ),
                )
                    .animate()
                    .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: LumoSpacing.space8),

                Text(
                  'Sign in to continue.',
                  style: LumoTypography.bodyLarge.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.5),
                  ),
                )
                    .animate()
                    .fadeIn(
                      delay: 100.ms,
                      duration: LumoMotion.normal,
                      curve: LumoMotion.enter,
                    ),

                const SizedBox(height: LumoSpacing.space48),

                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: 'Email address',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter your email.';
                    if (!v.contains('@')) return 'Enter a valid email.';
                    return null;
                  },
                )
                    .animate()
                    .fadeIn(
                      delay: 150.ms,
                      duration: LumoMotion.normal,
                      curve: LumoMotion.enter,
                    ),

                const SizedBox(height: LumoSpacing.space12),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _signIn(),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                        color: colors.onSurface.withValues(alpha: 0.4),
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your password.';
                    if (v.length < 6) return 'Password is too short.';
                    return null;
                  },
                )
                    .animate()
                    .fadeIn(
                      delay: 200.ms,
                      duration: LumoMotion.normal,
                      curve: LumoMotion.enter,
                    ),

                const SizedBox(height: LumoSpacing.space8),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot password?',
                      style: LumoTypography.labelMedium.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: LumoSpacing.space24),

                // Sign in button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LumoColors.lightGold,
                      foregroundColor: LumoColors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: LumoSpacing.space16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: LumoRadius.borderLarge,
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: LumoColors.white,
                            ),
                          )
                        : const Text('Sign in'),
                  ),
                )
                    .animate()
                    .fadeIn(
                      delay: 250.ms,
                      duration: LumoMotion.normal,
                      curve: LumoMotion.enter,
                    ),

                const SizedBox(height: LumoSpacing.space24),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: colors.outline)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: LumoSpacing.space16,
                      ),
                      child: Text(
                        'or',
                        style: LumoTypography.bodySmall.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: colors.outline)),
                  ],
                ),

                const SizedBox(height: LumoSpacing.space24),

                // Social buttons
                _SocialButton(
                  label: 'Continue with Google',
                  icon: Icons.g_mobiledata_rounded,
                  onTap: isLoading ? null : _signInWithGoogle,
                ),

                const SizedBox(height: LumoSpacing.space12),

                _SocialButton(
                  label: 'Continue with Apple',
                  icon: Icons.apple_rounded,
                  onTap: isLoading ? null : _signInWithApple,
                ),

                const SizedBox(height: LumoSpacing.space32),

                // Register link
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: LumoTypography.bodyMedium.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go(LumoRoutes.register),
                        child: Text(
                          'Create one',
                          style: LumoTypography.labelMedium.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: LumoSpacing.space24),

                // Guest access — always visible, never hidden
                Center(
                  child: TextButton(
                    onPressed: isLoading ? null : _continueAsGuest,
                    child: Text(
                      'Browse without an account',
                      style: LumoTypography.labelMedium.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.35),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: LumoSpacing.space32),

                // Broker entry point — subtle, below the fold, professional
                Center(
                  child: GestureDetector(
                    onTap: () => context.push(LumoRoutes.brokerApply),
                    child: Text(
                      'Are you a broker? Apply to list on Lumo',
                      style: LumoTypography.labelSmall.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.28),
                        decoration: TextDecoration.underline,
                        decorationColor: colors.onSurface.withValues(alpha: 0.18),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: LumoSpacing.space48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return OutlinedButton(
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: colors.onSurface),
          const SizedBox(width: LumoSpacing.space12),
          Text(label),
        ],
      ),
    );
  }
}
