import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../shared/design_system/design_system.dart';
import '../domain/entities/address_entity.dart';
import '../providers/checkout_providers.dart';

/// Lumo Checkout — Delivery Step
/// A clean address form. Reduce friction. Never overwhelm.
/// Users fill in what matters — nothing more.
class CheckoutDeliveryStep extends ConsumerStatefulWidget {
  const CheckoutDeliveryStep({super.key});

  @override
  ConsumerState<CheckoutDeliveryStep> createState() =>
      _CheckoutDeliveryStepState();
}

class _CheckoutDeliveryStepState extends ConsumerState<CheckoutDeliveryStep> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _line1Controller = TextEditingController();
  final _line2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _saveAddress = true;

  // Focus nodes for smooth keyboard navigation
  final _line1Focus = FocusNode();
  final _line2Focus = FocusNode();
  final _cityFocus = FocusNode();
  final _stateFocus = FocusNode();
  final _postalFocus = FocusNode();
  final _countryFocus = FocusNode();
  final _phoneFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Pre-fill if address already set in state
    final existing = ref.read(checkoutNotifierProvider).address;
    if (existing != null) {
      _fullNameController.text = existing.fullName;
      _line1Controller.text = existing.line1;
      _line2Controller.text = existing.line2 ?? '';
      _cityController.text = existing.city;
      _stateController.text = existing.state;
      _postalCodeController.text = existing.postalCode;
      _countryController.text = existing.country;
      _phoneController.text = existing.phone ?? '';
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _line1Controller.dispose();
    _line2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    _line1Focus.dispose();
    _line2Focus.dispose();
    _cityFocus.dispose();
    _stateFocus.dispose();
    _postalFocus.dispose();
    _countryFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final address = AddressEntity(
      id: const Uuid().v4(),
      fullName: _fullNameController.text.trim(),
      line1: _line1Controller.text.trim(),
      line2: _line2Controller.text.trim().isEmpty
          ? null
          : _line2Controller.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      postalCode: _postalCodeController.text.trim(),
      country: _countryController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      isDefault: _saveAddress,
    );

    ref.read(checkoutNotifierProvider.notifier).setAddress(address);
    ref.read(checkoutNotifierProvider.notifier).nextStep();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space24,
        LumoSpacing.space8,
        LumoSpacing.space24,
        LumoSpacing.space40,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delivery address',
              style: LumoTypography.headlineSmall.copyWith(
                color: colors.onSurface,
              ),
            ).animate().fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter),

            const SizedBox(height: LumoSpacing.space8),

            Text(
              'Where should we send your order?',
              style: LumoTypography.bodyMedium.copyWith(
                color: colors.onSurface.withValues(alpha: 0.5),
              ),
            ).animate().fadeIn(
                  delay: 60.ms,
                  duration: LumoMotion.normal,
                  curve: LumoMotion.enter,
                ),

            const SizedBox(height: LumoSpacing.space32),

            // Full name
            _LumoField(
              controller: _fullNameController,
              hint: 'Full name',
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => _line1Focus.requestFocus(),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter your full name.' : null,
              animationDelay: 80,
            ),

            const SizedBox(height: LumoSpacing.space12),

            // Address line 1
            _LumoField(
              controller: _line1Controller,
              hint: 'Street address',
              focusNode: _line1Focus,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => _line2Focus.requestFocus(),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter your street address.' : null,
              animationDelay: 100,
            ),

            const SizedBox(height: LumoSpacing.space12),

            // Address line 2 — optional
            _LumoField(
              controller: _line2Controller,
              hint: 'Apartment, suite, etc. (optional)',
              focusNode: _line2Focus,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => _cityFocus.requestFocus(),
              animationDelay: 120,
            ),

            const SizedBox(height: LumoSpacing.space12),

            // City + State row
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _LumoField(
                    controller: _cityController,
                    hint: 'City',
                    focusNode: _cityFocus,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _stateFocus.requestFocus(),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required.' : null,
                    animationDelay: 140,
                  ),
                ),
                const SizedBox(width: LumoSpacing.space12),
                Expanded(
                  flex: 2,
                  child: _LumoField(
                    controller: _stateController,
                    hint: 'State',
                    focusNode: _stateFocus,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _postalFocus.requestFocus(),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required.' : null,
                    animationDelay: 140,
                  ),
                ),
              ],
            ),

            const SizedBox(height: LumoSpacing.space12),

            // Postal code + Country row
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _LumoField(
                    controller: _postalCodeController,
                    hint: 'Postal code',
                    focusNode: _postalFocus,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _countryFocus.requestFocus(),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required.' : null,
                    animationDelay: 160,
                  ),
                ),
                const SizedBox(width: LumoSpacing.space12),
                Expanded(
                  flex: 3,
                  child: _LumoField(
                    controller: _countryController,
                    hint: 'Country',
                    focusNode: _countryFocus,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _phoneFocus.requestFocus(),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required.' : null,
                    animationDelay: 160,
                  ),
                ),
              ],
            ),

            const SizedBox(height: LumoSpacing.space12),

            // Phone — optional
            _LumoField(
              controller: _phoneController,
              hint: 'Phone number (optional)',
              focusNode: _phoneFocus,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _onContinue(),
              animationDelay: 180,
            ),

            const SizedBox(height: LumoSpacing.space24),

            // Save address toggle
            GestureDetector(
              onTap: () => setState(() => _saveAddress = !_saveAddress),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: LumoMotion.fast,
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: _saveAddress
                          ? colors.primary
                          : colors.secondaryContainer,
                      borderRadius: LumoRadius.borderSmall,
                      border: _saveAddress
                          ? null
                          : Border.all(color: colors.outline),
                    ),
                    child: _saveAddress
                        ? Icon(
                            Icons.check_rounded,
                            size: 14,
                            color: colors.onPrimary,
                          )
                        : null,
                  ),
                  const SizedBox(width: LumoSpacing.space12),
                  Text(
                    'Save this address for future orders',
                    style: LumoTypography.bodyMedium.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(
                  delay: 200.ms,
                  duration: LumoMotion.normal,
                  curve: LumoMotion.enter,
                ),

            const SizedBox(height: LumoSpacing.space40),

            // Continue button
            FilledButton(
              onPressed: _onContinue,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                shape: const RoundedRectangleBorder(
                  borderRadius: LumoRadius.borderMedium,
                ),
              ),
              child: Text(
                'Continue to payment',
                style: LumoTypography.labelLarge.copyWith(
                  color: colors.onPrimary,
                ),
              ),
            ).animate().fadeIn(
                  delay: 220.ms,
                  duration: LumoMotion.normal,
                  curve: LumoMotion.enter,
                ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Reusable field — consistent with LDS input style
// ─────────────────────────────────────────────

class _LumoField extends StatelessWidget {
  const _LumoField({
    required this.controller,
    required this.hint,
    this.focusNode,
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction,
    this.onSubmitted,
    this.validator,
    this.animationDelay = 0,
  });

  final TextEditingController controller;
  final String hint;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final int animationDelay;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(hintText: hint),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: animationDelay),
          duration: LumoMotion.normal,
          curve: LumoMotion.enter,
        )
        .slideY(begin: 0.08, end: 0);
  }
}
