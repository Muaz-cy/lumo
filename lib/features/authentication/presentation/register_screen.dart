import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/design_system/design_system.dart';
import '../providers/auth_providers.dart';

/// Lumo Register Screen
/// Minimal friction. Never force account creation before users see value.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(authNotifierProvider.notifier).registerWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _nameController.text.trim(),
        );
    if (success && mounted) context.go(LumoRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final colors = Theme.of(context).colorScheme;
    final isLoading = authState.isLoading;

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

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: LumoSpacing.space24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: LumoSpacing.space64),

                Text(
                  'Create your\naccount.',
                  style: LumoTypography.displayMedium.copyWith(
                    color: colors.onSurface,
                  ),
                )
                    .animate()
                    .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: LumoSpacing.space8),

                Text(
                  'Join Lumo. Discover differently.',
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

                // Name
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(hintText: 'Full name'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter your name.';
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

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  decoration: const InputDecoration(hintText: 'Email address'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter your email.';
                    if (!v.contains('@')) return 'Enter a valid email.';
                    return null;
                  },
                )
                    .animate()
                    .fadeIn(
                      delay: 200.ms,
                      duration: LumoMotion.normal,
                      curve: LumoMotion.enter,
                    ),

                const SizedBox(height: LumoSpacing.space12),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _register(),
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
                    if (v == null || v.isEmpty) return 'Enter a password.';
                    if (v.length < 8) return 'Use at least 8 characters.';
                    return null;
                  },
                )
                    .animate()
                    .fadeIn(
                      delay: 250.ms,
                      duration: LumoMotion.normal,
                      curve: LumoMotion.enter,
                    ),

                const SizedBox(height: LumoSpacing.space32),

                ElevatedButton(
                  onPressed: isLoading ? null : _register,
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.onPrimary,
                          ),
                        )
                      : const Text('Create account'),
                )
                    .animate()
                    .fadeIn(
                      delay: 300.ms,
                      duration: LumoMotion.normal,
                      curve: LumoMotion.enter,
                    ),

                const SizedBox(height: LumoSpacing.space32),

                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: LumoTypography.bodyMedium.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go(LumoRoutes.login),
                        child: Text(
                          'Sign in',
                          style: LumoTypography.labelMedium.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                    ],
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
