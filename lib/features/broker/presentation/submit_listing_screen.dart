import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lumo/core/router/app_router.dart';
import 'package:lumo/features/broker/providers/broker_providers.dart';
import 'package:lumo/shared/design_system/design_system.dart';

class SubmitListingScreen extends ConsumerStatefulWidget {
  const SubmitListingScreen({super.key});

  @override
  ConsumerState<SubmitListingScreen> createState() =>
      _SubmitListingScreenState();
}

class _SubmitListingScreenState extends ConsumerState<SubmitListingScreen> {
  int _step = 0;
  final _pageController = PageController();

  static const _steps = [
    'Basics',
    'Location',
    'Details',
    'Images',
    'Review',
  ];

  void _next() {
    if (_step < _steps.length - 1) {
      setState(() => _step++);
      _pageController.animateToPage(
        _step,
        duration: LumoMotion.deliberate,
        curve: LumoMotion.silk,
      );
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
      _pageController.animateToPage(
        _step,
        duration: LumoMotion.deliberate,
        curve: LumoMotion.silk,
      );
    } else {
      context.pop();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: LumoColors.lightBackground,
      appBar: AppBar(
        backgroundColor: LumoColors.lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            _step == 0
                ? Icons.close_rounded
                : Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: colors.onSurface,
          ),
          onPressed: _back,
        ),
        title: Text(
          'Submit a listing',
          style: LumoTypography.titleMedium.copyWith(color: colors.onSurface),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _StepIndicator(currentStep: _step, steps: _steps),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _Step1Basics(onNext: _next),
                _Step2Location(onNext: _next),
                _Step3Details(onNext: _next),
                _Step4Images(onNext: _next),
                _Step5Review(onBack: _back),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Step indicator
// ─────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep, required this.steps});
  final int currentStep;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space24, LumoSpacing.space8,
        LumoSpacing.space24, LumoSpacing.space16,
      ),
      child: Row(
        children: steps.asMap().entries.map((e) {
          final isDone = e.key < currentStep;
          final isActive = e.key == currentStep;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: LumoMotion.fast,
                    height: 3,
                    decoration: BoxDecoration(
                      color: isDone || isActive
                          ? LumoColors.lightGold
                          : LumoColors.lightBorder,
                      borderRadius: LumoRadius.borderPill,
                    ),
                  ),
                ),
                if (e.key < steps.length - 1)
                  const SizedBox(width: LumoSpacing.space4),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Shared step wrapper
// ─────────────────────────────────────────────

class _StepWrapper extends StatelessWidget {
  const _StepWrapper({
    required this.title,
    required this.subtitle,
    required this.child,
    required this.onNext,
    required this.nextLabel,
    this.canProceed = true,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final VoidCallback onNext;
  final String nextLabel;
  final bool canProceed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space24, LumoSpacing.space8,
        LumoSpacing.space24, LumoSpacing.space24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: LumoTypography.headlineSmall
                  .copyWith(color: colors.onSurface))
              .animate()
              .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter),
          const SizedBox(height: LumoSpacing.space4),
          Text(subtitle,
              style: LumoTypography.bodyMedium.copyWith(
                color: colors.onSurface.withValues(alpha: 0.45),
              ))
              .animate()
              .fadeIn(
                  delay: 60.ms,
                  duration: LumoMotion.normal,
                  curve: LumoMotion.enter),
          const SizedBox(height: LumoSpacing.space32),
          child,
          const SizedBox(height: LumoSpacing.space32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: canProceed ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: LumoColors.lightGold,
                foregroundColor: LumoColors.white,
                disabledBackgroundColor:
                    LumoColors.lightGold.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                    borderRadius: LumoRadius.borderMedium),
              ),
              child: Text(nextLabel),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Step 1 — Basics
// ─────────────────────────────────────────────

class _Step1Basics extends ConsumerStatefulWidget {
  const _Step1Basics({required this.onNext});
  final VoidCallback onNext;

  @override
  ConsumerState<_Step1Basics> createState() => _Step1BasicsState();
}

class _Step1BasicsState extends ConsumerState<_Step1Basics> {
  final _titleEn = TextEditingController();
  final _titleAm = TextEditingController();
  final _price = TextEditingController();
  String _type = 'apartment';
  String _purpose = 'sale';

  static const _types = [
    ('apartment', 'Apartment'),
    ('villa', 'Villa'),
    ('house', 'House'),
    ('land', 'Land'),
    ('commercial', 'Commercial'),
    ('office', 'Office'),
  ];

  bool get _canProceed =>
      _titleEn.text.trim().isNotEmpty && _price.text.trim().isNotEmpty;

  @override
  void dispose() {
    _titleEn.dispose();
    _titleAm.dispose();
    _price.dispose();
    super.dispose();
  }

  void _proceed() {
    ref.read(listingSubmissionNotifierProvider.notifier).updateStep1(
          title: _titleEn.text.trim(),
          titleAm: _titleAm.text.trim(),
          priceEtb: double.tryParse(
                  _price.text.trim().replaceAll(',', '')) ??
              0,
          propertyType: _type,
          purpose: _purpose,
        );
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return _StepWrapper(
      title: 'Tell us about the property',
      subtitle: 'Start with the essentials.',
      onNext: _proceed,
      nextLabel: 'Continue',
      canProceed: _canProceed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleEn,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(hintText: 'Property title (English)'),
          ),
          const SizedBox(height: LumoSpacing.space12),
          TextField(
            controller: _titleAm,
            decoration: const InputDecoration(hintText: 'Property title (Amharic) — optional'),
          ),
          const SizedBox(height: LumoSpacing.space20),
          Text('Property type',
              style: LumoTypography.labelMedium
                  .copyWith(color: colors.onSurface.withValues(alpha: 0.6))),
          const SizedBox(height: LumoSpacing.space10),
          Wrap(
            spacing: LumoSpacing.space8,
            runSpacing: LumoSpacing.space8,
            children: _types.map((t) {
              final isActive = _type == t.$1;
              return GestureDetector(
                onTap: () => setState(() => _type = t.$1),
                child: AnimatedContainer(
                  duration: LumoMotion.fast,
                  padding: const EdgeInsets.symmetric(
                    horizontal: LumoSpacing.space16,
                    vertical: LumoSpacing.space10,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? LumoColors.lightGold
                        : LumoColors.lightSurfaceSecondary,
                    borderRadius: LumoRadius.borderPill,
                    border: Border.all(
                      color: isActive
                          ? LumoColors.lightGold
                          : LumoColors.lightBorder,
                    ),
                  ),
                  child: Text(t.$2,
                      style: LumoTypography.labelMedium.copyWith(
                        color: isActive
                            ? LumoColors.white
                            : colors.onSurface,
                      )),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: LumoSpacing.space20),
          Text('Listing purpose',
              style: LumoTypography.labelMedium
                  .copyWith(color: colors.onSurface.withValues(alpha: 0.6))),
          const SizedBox(height: LumoSpacing.space10),
          Row(
            children: [
              _PurposeChip(
                label: 'For Sale',
                isActive: _purpose == 'sale',
                onTap: () => setState(() => _purpose = 'sale'),
              ),
              const SizedBox(width: LumoSpacing.space8),
              _PurposeChip(
                label: 'For Rent',
                isActive: _purpose == 'rent',
                onTap: () => setState(() => _purpose = 'rent'),
              ),
            ],
          ),
          const SizedBox(height: LumoSpacing.space20),
          TextField(
            controller: _price,
            onChanged: (_) => setState(() {}),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: 'Price in ETB',
              prefixText: 'ETB ',
              prefixStyle: LumoTypography.labelMedium
                  .copyWith(color: LumoColors.lightGold),
            ),
          ),
        ],
      ),
    );
  }
}

class _PurposeChip extends StatelessWidget {
  const _PurposeChip(
      {required this.label,
      required this.isActive,
      required this.onTap});
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: LumoMotion.fast,
        padding: const EdgeInsets.symmetric(
          horizontal: LumoSpacing.space20,
          vertical: LumoSpacing.space10,
        ),
        decoration: BoxDecoration(
          color:
              isActive ? LumoColors.lightGold : LumoColors.lightSurfaceSecondary,
          borderRadius: LumoRadius.borderPill,
          border: Border.all(
            color: isActive ? LumoColors.lightGold : LumoColors.lightBorder,
          ),
        ),
        child: Text(label,
            style: LumoTypography.labelMedium.copyWith(
              color: isActive
                  ? LumoColors.white
                  : Theme.of(context).colorScheme.onSurface,
            )),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Step 2 — Location
// ─────────────────────────────────────────────

class _Step2Location extends ConsumerStatefulWidget {
  const _Step2Location({required this.onNext});
  final VoidCallback onNext;

  @override
  ConsumerState<_Step2Location> createState() => _Step2LocationState();
}

class _Step2LocationState extends ConsumerState<_Step2Location> {
  final _neighborhood = TextEditingController();
  final _city = TextEditingController(text: 'Addis Ababa');
  final _lat = TextEditingController();
  final _lng = TextEditingController();

  bool get _canProceed =>
      _neighborhood.text.trim().isNotEmpty &&
      _city.text.trim().isNotEmpty;

  @override
  void dispose() {
    _neighborhood.dispose();
    _city.dispose();
    _lat.dispose();
    _lng.dispose();
    super.dispose();
  }

  void _proceed() {
    ref.read(listingSubmissionNotifierProvider.notifier).updateStep2(
          neighborhood: _neighborhood.text.trim(),
          city: _city.text.trim(),
          latitude: double.tryParse(_lat.text.trim()),
          longitude: double.tryParse(_lng.text.trim()),
        );
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return _StepWrapper(
      title: 'Where is the property?',
      subtitle: 'Accurate location builds buyer confidence.',
      onNext: _proceed,
      nextLabel: 'Continue',
      canProceed: _canProceed,
      child: Column(
        children: [
          TextField(
            controller: _neighborhood,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(hintText: 'Neighbourhood (e.g. Bole)'),
          ),
          const SizedBox(height: LumoSpacing.space12),
          TextField(
            controller: _city,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(hintText: 'City'),
          ),
          const SizedBox(height: LumoSpacing.space12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _lat,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, signed: true),
                  decoration: const InputDecoration(hintText: 'Latitude (optional)'),
                ),
              ),
              const SizedBox(width: LumoSpacing.space12),
              Expanded(
                child: TextField(
                  controller: _lng,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, signed: true),
                  decoration: const InputDecoration(hintText: 'Longitude (optional)'),
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
// Step 3 — Details
// ─────────────────────────────────────────────

class _Step3Details extends ConsumerStatefulWidget {
  const _Step3Details({required this.onNext});
  final VoidCallback onNext;

  @override
  ConsumerState<_Step3Details> createState() => _Step3DetailsState();
}

class _Step3DetailsState extends ConsumerState<_Step3Details> {
  int _bedrooms = 1;
  int _bathrooms = 1;
  final _area = TextEditingController();
  final _descEn = TextEditingController();
  final _amenityController = TextEditingController();
  final List<String> _amenities = [];

  static const _commonAmenities = [
    'Parking', 'Generator', 'Security', 'Elevator',
    'Garden', 'Pool', 'Furnished', 'WiFi',
  ];

  bool get _canProceed => _area.text.trim().isNotEmpty;

  @override
  void dispose() {
    _area.dispose();
    _descEn.dispose();
    _amenityController.dispose();
    super.dispose();
  }

  void _proceed() {
    ref.read(listingSubmissionNotifierProvider.notifier).updateStep3(
          bedrooms: _bedrooms,
          bathrooms: _bathrooms,
          areaSqm: double.tryParse(_area.text.trim()) ?? 0,
          amenities: _amenities,
          descriptionEn: _descEn.text.trim().isEmpty
              ? null
              : _descEn.text.trim(),
        );
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return _StepWrapper(
      title: 'Property details',
      subtitle: 'The more detail, the more trust.',
      onNext: _proceed,
      nextLabel: 'Continue',
      canProceed: _canProceed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _Counter(
                  label: 'Bedrooms',
                  value: _bedrooms,
                  min: 0,
                  max: 20,
                  onChanged: (v) => setState(() => _bedrooms = v),
                ),
              ),
              const SizedBox(width: LumoSpacing.space16),
              Expanded(
                child: _Counter(
                  label: 'Bathrooms',
                  value: _bathrooms,
                  min: 1,
                  max: 20,
                  onChanged: (v) => setState(() => _bathrooms = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: LumoSpacing.space20),
          TextField(
            controller: _area,
            onChanged: (_) => setState(() {}),
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              hintText: 'Area in m²',
              suffixText: 'm²',
            ),
          ),
          const SizedBox(height: LumoSpacing.space20),
          Text('Amenities',
              style: LumoTypography.labelMedium
                  .copyWith(color: colors.onSurface.withValues(alpha: 0.6))),
          const SizedBox(height: LumoSpacing.space10),
          Wrap(
            spacing: LumoSpacing.space8,
            runSpacing: LumoSpacing.space8,
            children: _commonAmenities.map((a) {
              final isSelected = _amenities.contains(a);
              return GestureDetector(
                onTap: () => setState(() => isSelected
                    ? _amenities.remove(a)
                    : _amenities.add(a)),
                child: AnimatedContainer(
                  duration: LumoMotion.fast,
                  padding: const EdgeInsets.symmetric(
                    horizontal: LumoSpacing.space12,
                    vertical: LumoSpacing.space8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? LumoColors.lightGoldContainer
                        : LumoColors.lightSurfaceSecondary,
                    borderRadius: LumoRadius.borderPill,
                    border: Border.all(
                      color: isSelected
                          ? LumoColors.lightGold
                          : LumoColors.lightBorder,
                    ),
                  ),
                  child: Text(a,
                      style: LumoTypography.labelSmall.copyWith(
                        color: isSelected
                            ? LumoColors.lightGold
                            : colors.onSurface,
                      )),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: LumoSpacing.space20),
          TextField(
            controller: _descEn,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Description (optional) — tell buyers what makes this property special',
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(LumoSpacing.space14),
      decoration: BoxDecoration(
        color: LumoColors.lightSurfaceSecondary,
        borderRadius: LumoRadius.borderLarge,
        border: Border.all(color: LumoColors.lightBorder),
      ),
      child: Column(
        children: [
          Text(label,
              style: LumoTypography.labelSmall.copyWith(
                color: colors.onSurface.withValues(alpha: 0.5),
              )),
          const SizedBox(height: LumoSpacing.space10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: value > min ? () => onChanged(value - 1) : null,
                child: Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: value > min
                        ? LumoColors.lightGold
                        : LumoColors.lightBorder,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.remove_rounded,
                      size: 16, color: LumoColors.white),
                ),
              ),
              Text(
                value == 0 ? 'Studio' : '$value',
                style: LumoTypography.titleMedium
                    .copyWith(color: colors.onSurface),
              ),
              GestureDetector(
                onTap: value < max ? () => onChanged(value + 1) : null,
                child: Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: value < max
                        ? LumoColors.lightGold
                        : LumoColors.lightBorder,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_rounded,
                      size: 16, color: LumoColors.white),
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
// Step 4 — Images
// ─────────────────────────────────────────────

class _Step4Images extends ConsumerStatefulWidget {
  const _Step4Images({required this.onNext});
  final VoidCallback onNext;

  @override
  ConsumerState<_Step4Images> createState() => _Step4ImagesState();
}

class _Step4ImagesState extends ConsumerState<_Step4Images> {
  final List<TextEditingController> _controllers = [
    TextEditingController(),
  ];

  List<String> get _urls => _controllers
      .map((c) => c.text.trim())
      .where((u) => u.isNotEmpty)
      .toList();

  void _addField() {
    setState(() => _controllers.add(TextEditingController()));
  }

  void _removeField(int i) {
    setState(() {
      _controllers[i].dispose();
      _controllers.removeAt(i);
    });
  }

  void _proceed() {
    ref
        .read(listingSubmissionNotifierProvider.notifier)
        .updateStep4(imageUrls: _urls);
    widget.onNext();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return _StepWrapper(
      title: 'Add photos',
      subtitle: 'Paste image URLs for now — direct upload coming in Phase 6.',
      onNext: _proceed,
      nextLabel: 'Continue to Review',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(_controllers.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: LumoSpacing.space12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controllers[i],
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Image URL ${i + 1}',
                        prefixIcon: const Icon(Icons.image_outlined, size: 18),
                      ),
                    ),
                  ),
                  if (_controllers.length > 1) ...[
                    const SizedBox(width: LumoSpacing.space8),
                    GestureDetector(
                      onTap: () => _removeField(i),
                      child: Icon(
                        Icons.remove_circle_outline_rounded,
                        size: 20,
                        color: colors.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
          const SizedBox(height: LumoSpacing.space4),
          TextButton.icon(
            onPressed: _addField,
            icon: const Icon(Icons.add_rounded, size: 16),
            label: const Text('Add another URL'),
            style: TextButton.styleFrom(
              foregroundColor: LumoColors.lightGold,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(height: LumoSpacing.space16),
          Container(
            padding: const EdgeInsets.all(LumoSpacing.space12),
            decoration: BoxDecoration(
              color: LumoColors.lightGoldContainer,
              borderRadius: LumoRadius.borderMedium,
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 16, color: LumoColors.lightGold),
                const SizedBox(width: LumoSpacing.space8),
                Expanded(
                  child: Text(
                    'At least one photo significantly increases inquiry rates.',
                    style: LumoTypography.labelSmall
                        .copyWith(color: LumoColors.lightGold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Step 5 — Review & Submit
// ─────────────────────────────────────────────

class _Step5Review extends ConsumerStatefulWidget {
  const _Step5Review({required this.onBack});
  final VoidCallback onBack;

  @override
  ConsumerState<_Step5Review> createState() => _Step5ReviewState();
}

class _Step5ReviewState extends ConsumerState<_Step5Review> {
  bool _submitted = false;

  Future<void> _submit() async {
    final success = await ref
        .read(listingSubmissionNotifierProvider.notifier)
        .submit();
    if (success && mounted) {
      setState(() => _submitted = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(listingSubmissionNotifierProvider);
    final colors = Theme.of(context).colorScheme;
    final fmt = NumberFormat('#,###');

    if (_submitted) {
      return _SuccessView(
        onDone: () {
          ref.read(listingSubmissionNotifierProvider.notifier).reset();
          context.go(LumoRoutes.brokerListings);
        },
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        LumoSpacing.space24, LumoSpacing.space8,
        LumoSpacing.space24, LumoSpacing.space24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review your listing',
              style: LumoTypography.headlineSmall
                  .copyWith(color: colors.onSurface))
              .animate()
              .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter),
          const SizedBox(height: LumoSpacing.space4),
          Text('Everything look right?',
              style: LumoTypography.bodyMedium.copyWith(
                color: colors.onSurface.withValues(alpha: 0.45),
              ))
              .animate()
              .fadeIn(
                  delay: 60.ms,
                  duration: LumoMotion.normal,
                  curve: LumoMotion.enter),
          const SizedBox(height: LumoSpacing.space24),

          _ReviewSection(title: 'Basics', rows: [
            ('Title', state.title),
            if (state.titleAm.isNotEmpty) ('Title (Amharic)', state.titleAm),
            ('Type', state.propertyType),
            ('Purpose', state.purpose == 'sale' ? 'For Sale' : 'For Rent'),
            ('Price', 'ETB ${fmt.format(state.priceEtb.toInt())}'),
          ]),
          const SizedBox(height: LumoSpacing.space16),

          _ReviewSection(title: 'Location', rows: [
            ('Neighbourhood', state.neighborhood),
            ('City', state.city),
            if (state.latitude != null)
              ('Coordinates',
                  '${state.latitude!.toStringAsFixed(4)}, ${state.longitude!.toStringAsFixed(4)}'),
          ]),
          const SizedBox(height: LumoSpacing.space16),

          _ReviewSection(title: 'Details', rows: [
            ('Bedrooms',
                state.bedrooms == 0 ? 'Studio' : '${state.bedrooms}'),
            ('Bathrooms', '${state.bathrooms}'),
            ('Area', '${state.areaSqm.toStringAsFixed(0)} m²'),
            if (state.amenities.isNotEmpty)
              ('Amenities', state.amenities.join(', ')),
            if (state.descriptionEn != null)
              ('Description', state.descriptionEn!),
          ]),
          const SizedBox(height: LumoSpacing.space16),

          _ReviewSection(title: 'Images', rows: [
            ('Photos',
                state.imageUrls.isEmpty
                    ? 'None added'
                    : '${state.imageUrls.length} URL(s)'),
          ]),
          const SizedBox(height: LumoSpacing.space32),

          if (state.error != null) ...[
            Container(
              padding: const EdgeInsets.all(LumoSpacing.space12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: LumoRadius.borderMedium,
              ),
              child: Text(
                state.error!,
                style: LumoTypography.bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
            const SizedBox(height: LumoSpacing.space16),
          ],

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: state.isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: LumoColors.lightGold,
                foregroundColor: LumoColors.white,
                disabledBackgroundColor:
                    LumoColors.lightGold.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: LumoRadius.borderMedium),
              ),
              child: state.isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: LumoColors.white,
                      ),
                    )
                  : const Text('Submit for Review'),
            ),
          ),
          const SizedBox(height: LumoSpacing.space12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: TextButton(
              onPressed: state.isSubmitting ? null : widget.onBack,
              style: TextButton.styleFrom(
                foregroundColor: colors.onSurface.withValues(alpha: 0.6),
              ),
              child: const Text('Go back and edit'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({required this.title, required this.rows});
  final String title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: LumoColors.lightSurfaceSecondary,
        borderRadius: LumoRadius.borderLarge,
        border: Border.all(color: LumoColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LumoSpacing.space16, LumoSpacing.space12,
              LumoSpacing.space16, LumoSpacing.space8,
            ),
            child: Text(title,
                style: LumoTypography.labelMedium.copyWith(
                  color: LumoColors.lightGold,
                  fontWeight: FontWeight.w600,
                )),
          ),
          const Divider(height: 1, color: LumoColors.lightBorder),
          ...rows.map((row) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: LumoSpacing.space16,
                  vertical: LumoSpacing.space10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(row.$1,
                          style: LumoTypography.labelSmall.copyWith(
                            color: colors.onSurface.withValues(alpha: 0.5),
                          )),
                    ),
                    Expanded(
                      child: Text(row.$2,
                          style: LumoTypography.bodySmall
                              .copyWith(color: colors.onSurface)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.onDone});
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(LumoSpacing.space32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: LumoColors.lightGoldContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 40,
                color: LumoColors.lightGold,
              ),
            )
                .animate()
                .scale(
                    begin: const Offset(0.5, 0.5),
                    duration: LumoMotion.deliberate,
                    curve: LumoMotion.spring)
                .fadeIn(duration: LumoMotion.normal),
            const SizedBox(height: LumoSpacing.space24),
            Text(
              'Listing submitted!',
              style: LumoTypography.headlineSmall
                  .copyWith(color: colors.onSurface),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(
                    delay: 200.ms,
                    duration: LumoMotion.normal,
                    curve: LumoMotion.enter),
            const SizedBox(height: LumoSpacing.space8),
            Text(
              'Our team will review your listing and notify you once it\'s approved.',
              style: LumoTypography.bodyMedium.copyWith(
                color: colors.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(
                    delay: 300.ms,
                    duration: LumoMotion.normal,
                    curve: LumoMotion.enter),
            const SizedBox(height: LumoSpacing.space40),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: LumoColors.lightGold,
                  foregroundColor: LumoColors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: LumoRadius.borderMedium),
                ),
                child: const Text('View My Listings'),
              ),
            )
                .animate()
                .fadeIn(
                    delay: 400.ms,
                    duration: LumoMotion.normal,
                    curve: LumoMotion.enter),
          ],
        ),
      ),
    );
  }
}
