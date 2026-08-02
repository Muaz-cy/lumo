import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../shared/design_system/design_system.dart';
import '../domain/entities/payment_method_entity.dart';
import '../providers/checkout_providers.dart';

/// Lumo Checkout — Payment Step
/// Payment should feel calm. Secure. Trustworthy.
/// Never pressure. Never rush.
class CheckoutPaymentStep extends ConsumerStatefulWidget {
  const CheckoutPaymentStep({super.key});

  @override
  ConsumerState<CheckoutPaymentStep> createState() =>
      _CheckoutPaymentStepState();
}

class _CheckoutPaymentStepState extends ConsumerState<CheckoutPaymentStep> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardholderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  final _cardholderFocus = FocusNode();
  final _expiryFocus = FocusNode();
  final _cvvFocus = FocusNode();

  _PaymentMode _mode = _PaymentMode.card;

  @override
  void initState() {
    super.initState();
    // Pre-fill if card already set
    final existing = ref.read(checkoutNotifierProvider).paymentMethod;
    if (existing != null && existing.type == PaymentType.card) {
      _cardholderController.text = existing.brand ?? '';
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardholderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardholderFocus.dispose();
    _expiryFocus.dispose();
    _cvvFocus.dispose();
    super.dispose();
  }

  String get _detectedBrand {
    final number = _cardNumberController.text.replaceAll(' ', '');
    if (number.startsWith('4')) return 'Visa';
    if (number.startsWith('5') || number.startsWith('2')) return 'Mastercard';
    if (number.startsWith('3')) return 'Amex';
    return 'Card';
  }

  String? get _last4 {
    final number = _cardNumberController.text.replaceAll(' ', '');
    return number.length >= 4 ? number.substring(number.length - 4) : null;
  }

  int? get _expiryMonth {
    final parts = _expiryController.text.split('/');
    return parts.isNotEmpty ? int.tryParse(parts[0]) : null;
  }

  int? get _expiryYear {
    final parts = _expiryController.text.split('/');
    if (parts.length < 2) return null;
    final year = int.tryParse(parts[1]);
    return year != null ? 2000 + year : null;
  }

  void _onContinue() {
    if (_mode == _PaymentMode.googlePay) {
      ref.read(checkoutNotifierProvider.notifier).setPaymentMethod(
            PaymentMethodEntity(
              id: const Uuid().v4(),
              type: PaymentType.googlePay,
            ),
          );
      ref.read(checkoutNotifierProvider.notifier).nextStep();
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    ref.read(checkoutNotifierProvider.notifier).setPaymentMethod(
          PaymentMethodEntity(
            id: const Uuid().v4(),
            type: PaymentType.card,
            last4: _last4,
            brand: _detectedBrand,
            expiryMonth: _expiryMonth,
            expiryYear: _expiryYear,
          ),
        );
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment method',
            style: LumoTypography.headlineSmall.copyWith(
              color: colors.onSurface,
            ),
          ).animate().fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter),

          const SizedBox(height: LumoSpacing.space8),

          Text(
            'Your payment information is encrypted and secure.',
            style: LumoTypography.bodyMedium.copyWith(
              color: colors.onSurface.withValues(alpha: 0.5),
            ),
          ).animate().fadeIn(
                delay: 60.ms,
                duration: LumoMotion.normal,
                curve: LumoMotion.enter,
              ),

          const SizedBox(height: LumoSpacing.space32),

          // Payment mode selector
          _PaymentModeSelector(
            selected: _mode,
            onChanged: (mode) => setState(() => _mode = mode),
          ).animate().fadeIn(
                delay: 80.ms,
                duration: LumoMotion.normal,
                curve: LumoMotion.enter,
              ),

          const SizedBox(height: LumoSpacing.space32),

          // Card form or Google Pay
          AnimatedSwitcher(
            duration: LumoMotion.normal,
            switchInCurve: LumoMotion.enter,
            switchOutCurve: LumoMotion.exit,
            child: _mode == _PaymentMode.card
                ? _CardForm(
                    key: const ValueKey('card'),
                    formKey: _formKey,
                    cardNumberController: _cardNumberController,
                    cardholderController: _cardholderController,
                    expiryController: _expiryController,
                    cvvController: _cvvController,
                    cardholderFocus: _cardholderFocus,
                    expiryFocus: _expiryFocus,
                    cvvFocus: _cvvFocus,
                    detectedBrand: _detectedBrand,
                    onSubmitted: _onContinue,
                  )
                : _GooglePayOption(
                    key: const ValueKey('gpay'),
                    colors: colors,
                  ),
          ),

          const SizedBox(height: LumoSpacing.space40),

          // Security note
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 14,
                color: colors.onSurface.withValues(alpha: 0.35),
              ),
              const SizedBox(width: LumoSpacing.space8),
              Text(
                'Secured with 256-bit SSL encryption',
                style: LumoTypography.bodySmall.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.35),
                ),
              ),
            ],
          ).animate().fadeIn(
                delay: 200.ms,
                duration: LumoMotion.normal,
                curve: LumoMotion.enter,
              ),

          const SizedBox(height: LumoSpacing.space24),

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
              'Review order',
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
    );
  }
}

// ─────────────────────────────────────────────
// Payment mode selector tabs
// ─────────────────────────────────────────────

enum _PaymentMode { card, googlePay }

class _PaymentModeSelector extends StatelessWidget {
  const _PaymentModeSelector({
    required this.selected,
    required this.onChanged,
  });

  final _PaymentMode selected;
  final ValueChanged<_PaymentMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: LumoRadius.borderMedium,
      ),
      padding: const EdgeInsets.all(LumoSpacing.space4),
      child: Row(
        children: [
          _ModeTab(
            label: 'Credit / Debit',
            icon: Icons.credit_card_rounded,
            isSelected: selected == _PaymentMode.card,
            onTap: () => onChanged(_PaymentMode.card),
          ),
          _ModeTab(
            label: 'Google Pay',
            icon: Icons.g_mobiledata_rounded,
            isSelected: selected == _PaymentMode.googlePay,
            onTap: () => onChanged(_PaymentMode.googlePay),
          ),
        ],
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  const _ModeTab({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: LumoMotion.fast,
          curve: LumoMotion.snap,
          padding: const EdgeInsets.symmetric(vertical: LumoSpacing.space12),
          decoration: BoxDecoration(
            color: isSelected ? colors.surface : Colors.transparent,
            borderRadius: LumoRadius.borderSmall,
            boxShadow: isSelected ? LumoShadows.soft : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? colors.onSurface
                    : colors.onSurface.withValues(alpha: 0.4),
              ),
              const SizedBox(width: LumoSpacing.space8),
              Text(
                label,
                style: LumoTypography.labelMedium.copyWith(
                  color: isSelected
                      ? colors.onSurface
                      : colors.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Card entry form
// ─────────────────────────────────────────────

class _CardForm extends StatelessWidget {
  const _CardForm({
    super.key,
    required this.formKey,
    required this.cardNumberController,
    required this.cardholderController,
    required this.expiryController,
    required this.cvvController,
    required this.cardholderFocus,
    required this.expiryFocus,
    required this.cvvFocus,
    required this.detectedBrand,
    required this.onSubmitted,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController cardNumberController;
  final TextEditingController cardholderController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;
  final FocusNode cardholderFocus;
  final FocusNode expiryFocus;
  final FocusNode cvvFocus;
  final String detectedBrand;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Form(
      key: formKey,
      child: Column(
        children: [
          // Card number
          TextFormField(
            controller: cardNumberController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _CardNumberFormatter(),
            ],
            onFieldSubmitted: (_) => cardholderFocus.requestFocus(),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText: 'Card number',
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: LumoSpacing.space16),
                child: Text(
                  detectedBrand,
                  style: LumoTypography.labelMedium.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ),
              suffixIconConstraints: const BoxConstraints(minHeight: 0),
            ),
            validator: (v) {
              final digits = v?.replaceAll(' ', '') ?? '';
              if (digits.length < 13) return 'Enter a valid card number.';
              return null;
            },
          ),

          const SizedBox(height: LumoSpacing.space12),

          // Cardholder name
          TextFormField(
            controller: cardholderController,
            focusNode: cardholderFocus,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            onFieldSubmitted: (_) => expiryFocus.requestFocus(),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(hintText: 'Cardholder name'),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Enter the cardholder name.' : null,
          ),

          const SizedBox(height: LumoSpacing.space12),

          // Expiry + CVV row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: expiryController,
                  focusNode: expiryFocus,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [_ExpiryFormatter()],
                  onFieldSubmitted: (_) => cvvFocus.requestFocus(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(hintText: 'MM / YY'),
                  validator: (v) {
                    if (v == null || v.length < 5) return 'Invalid expiry.';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: LumoSpacing.space12),
              Expanded(
                child: TextFormField(
                  controller: cvvController,
                  focusNode: cvvFocus,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  onFieldSubmitted: (_) => onSubmitted(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(hintText: 'CVV'),
                  validator: (v) {
                    if (v == null || v.length < 3) return 'Invalid CVV.';
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Google Pay option
// ─────────────────────────────────────────────

class _GooglePayOption extends StatelessWidget {
  const _GooglePayOption({super.key, required this.colors});
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(LumoSpacing.space24),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: LumoRadius.borderLarge,
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        children: [
          Icon(
            Icons.g_mobiledata_rounded,
            size: 40,
            color: colors.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(height: LumoSpacing.space12),
          Text(
            'Pay with Google Pay',
            style: LumoTypography.titleMedium.copyWith(
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: LumoSpacing.space8),
          Text(
            'Fast, secure checkout using your\nGoogle Pay account.',
            style: LumoTypography.bodySmall.copyWith(
              color: colors.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Input formatters
// ─────────────────────────────────────────────

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(' ', '');
    if (digits.length > 16) return oldValue;

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll('/', '').replaceAll(' ', '');
    if (digits.length > 4) return oldValue;

    String formatted = digits;
    if (digits.length >= 3) {
      formatted = '${digits.substring(0, 2)} / ${digits.substring(2)}';
    } else if (digits.length == 2 && oldValue.text.length == 1) {
      formatted = '$digits / ';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
