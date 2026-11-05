import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lumo/shared/design_system/design_system.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  int? _selectedSlot;
  bool _booked = false;

  static const _experts = [
    _Expert(
      name: 'Selam Tadesse',
      title: 'Senior Property Advisor',
      languages: 'Amharic · English',
      avatar: 'ST',
      rating: '4.9',
      consultations: '340+',
    ),
    _Expert(
      name: 'Yonas Bekele',
      title: 'Diaspora Specialist',
      languages: 'Amharic · English · Italian',
      avatar: 'YB',
      rating: '4.8',
      consultations: '210+',
    ),
  ];

  static List<String> get _slots {
    final now = DateTime.now();
    final slots = <String>[];
    final times = ['9:00 AM', '11:00 AM', '2:00 PM', '4:00 PM'];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
    final months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    var day = now.add(const Duration(days: 1));
    while (slots.length < 6) {
      if (day.weekday <= 5) {
        final label = '${days[day.weekday - 1]} ${day.day} ${months[day.month - 1]}';
        for (final t in times) {
          slots.add('$label · $t');
          if (slots.length == 6) break;
        }
      }
      day = day.add(const Duration(days: 1));
    }
    return slots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LumoColors.lightBackground,
      body: _booked ? _BookedState(onDone: () => context.pop()) : _BookingFlow(
        selectedSlot: _selectedSlot,
        onSlotSelected: (i) => setState(() => _selectedSlot = i),
        onConfirm: () {
          HapticFeedback.mediumImpact();
          setState(() => _booked = true);
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Booking flow
// ─────────────────────────────────────────────

class _BookingFlow extends StatelessWidget {
  const _BookingFlow({
    required this.selectedSlot,
    required this.onSlotSelected,
    required this.onConfirm,
  });

  final int? selectedSlot;
  final ValueChanged<int> onSlotSelected;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _Header(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              LumoSpacing.space24, LumoSpacing.space32,
              LumoSpacing.space24, 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionLabel(label: 'Your expert'),
                const SizedBox(height: LumoSpacing.space16),
                ..._ConsultationScreenState._experts.asMap().entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: LumoSpacing.space12),
                    child: _ExpertCard(expert: e.value)
                        .animate(delay: (e.key * 80).ms)
                        .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
                        .slideY(begin: 0.05, end: 0),
                  ),
                ),
                const SizedBox(height: LumoSpacing.space32),
                _SectionLabel(label: 'Pick a time'),
                const SizedBox(height: LumoSpacing.space16),
                _SlotGrid(
                  slots: _ConsultationScreenState._slots,
                  selected: selectedSlot,
                  onSelect: onSlotSelected,
                ),
                const SizedBox(height: LumoSpacing.space32),
                _SectionLabel(label: 'How it works'),
                const SizedBox(height: LumoSpacing.space16),
                const _HowItWorks(),
                const SizedBox(height: LumoSpacing.space40),
                _ConfirmButton(
                  enabled: selectedSlot != null,
                  onTap: onConfirm,
                ),
                const SizedBox(height: LumoSpacing.space80),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1C1A17),
                  Color(0xFF2E2A22),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Subtle pattern
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.04,
                    child: Image.network(
                      'https://res.cloudinary.com/vf4zqyla/image/upload/v1793848696/lumo/properties/villa_01.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    LumoSpacing.space24, LumoSpacing.space52,
                    LumoSpacing.space24, LumoSpacing.space24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: LumoColors.lightGold,
                          borderRadius: LumoRadius.borderMedium,
                        ),
                        child: const Icon(
                          Icons.phone_outlined,
                          color: LumoColors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: LumoSpacing.space12),
                      Text(
                        'Book a Consultation',
                        style: LumoTypography.headlineLarge.copyWith(
                          color: LumoColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: LumoSpacing.space4),
                      Text(
                        'Free · 30 minutes · Video or phone call',
                        style: LumoTypography.bodySmall.copyWith(
                          color: LumoColors.white.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(LumoSpacing.space8),
              child: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: LumoColors.white,
                ),
              ),
            ),
          ),
        ],
      ).animate().fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter),
    );
  }
}

// ─────────────────────────────────────────────
// Expert card
// ─────────────────────────────────────────────

class _ExpertCard extends StatelessWidget {
  const _ExpertCard({required this.expert});
  final _Expert expert;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(LumoSpacing.space16),
      decoration: BoxDecoration(
        color: LumoColors.lightSurface,
        borderRadius: LumoRadius.borderLarge,
        border: Border.all(color: LumoColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: LumoColors.lightSurfaceSecondary,
              borderRadius: LumoRadius.borderMedium,
            ),
            child: Center(
              child: Text(
                expert.avatar,
                style: LumoTypography.titleMedium.copyWith(
                  color: LumoColors.lightTextSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: LumoSpacing.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expert.name,
                  style: LumoTypography.labelLarge.copyWith(
                    color: LumoColors.lightPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  expert.title,
                  style: LumoTypography.bodySmall.copyWith(
                    color: LumoColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: LumoSpacing.space4),
                Text(
                  expert.languages,
                  style: LumoTypography.labelSmall.copyWith(
                    color: LumoColors.lightTextTertiary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.star_rounded, size: 14, color: LumoColors.lightGold),
                  const SizedBox(width: 3),
                  Text(
                    expert.rating,
                    style: LumoTypography.labelMedium.copyWith(
                      color: LumoColors.lightPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                expert.consultations,
                style: LumoTypography.labelSmall.copyWith(
                  color: LumoColors.lightTextTertiary,
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
// Slot grid
// ─────────────────────────────────────────────

class _SlotGrid extends StatelessWidget {
  const _SlotGrid({required this.slots, required this.selected, required this.onSelect});
  final List<String> slots;
  final int? selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: LumoSpacing.space8,
      runSpacing: LumoSpacing.space8,
      children: slots.asMap().entries.map((e) {
        final active = selected == e.key;
        return GestureDetector(
          onTap: () => onSelect(e.key),
          child: AnimatedContainer(
            duration: LumoMotion.fast,
            padding: const EdgeInsets.symmetric(
              horizontal: LumoSpacing.space16,
              vertical: LumoSpacing.space12,
            ),
            decoration: BoxDecoration(
              color: active ? LumoColors.lightPrimary : LumoColors.lightSurface,
              borderRadius: LumoRadius.borderMedium,
              border: Border.all(
                color: active ? LumoColors.lightPrimary : LumoColors.lightBorder,
              ),
            ),
            child: Text(
              e.value,
              style: LumoTypography.labelMedium.copyWith(
                color: active ? LumoColors.white : LumoColors.lightTextSecondary,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────
// How it works
// ─────────────────────────────────────────────

class _HowItWorks extends StatelessWidget {
  const _HowItWorks();

  static const _steps = [
    (icon: Icons.calendar_today_outlined, text: 'Pick a time slot that works for you'),
    (icon: Icons.phone_outlined, text: 'A Lumo expert calls you — no app needed'),
    (icon: Icons.home_outlined, text: 'Get honest advice on any property in Addis'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _steps.asMap().entries.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: LumoSpacing.space16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: LumoColors.lightSurfaceSecondary,
                  borderRadius: LumoRadius.borderMedium,
                ),
                child: Icon(e.value.icon, size: 18, color: LumoColors.lightTextSecondary),
              ),
              const SizedBox(width: LumoSpacing.space16),
              Expanded(
                child: Text(
                  e.value.text,
                  style: LumoTypography.bodyMedium.copyWith(
                    color: LumoColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────
// Confirm button
// ─────────────────────────────────────────────

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.enabled, required this.onTap});
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: LumoMotion.fast,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: LumoSpacing.space16),
        decoration: BoxDecoration(
          color: enabled ? LumoColors.lightPrimary : LumoColors.lightSurfaceSecondary,
          borderRadius: LumoRadius.borderMedium,
        ),
        child: Center(
          child: Text(
            'Confirm booking',
            style: LumoTypography.labelLarge.copyWith(
              color: enabled ? LumoColors.white : LumoColors.lightTextTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Booked confirmation state
// ─────────────────────────────────────────────

class _BookedState extends StatelessWidget {
  const _BookedState({required this.onDone});
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(LumoSpacing.space48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: LumoColors.lightGoldContainer,
                borderRadius: LumoRadius.borderLarge,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 40,
                color: LumoColors.lightGold,
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.6, 0.6),
                  end: const Offset(1, 1),
                  duration: LumoMotion.deliberate,
                  curve: LumoMotion.enter,
                )
                .fadeIn(),
            const SizedBox(height: LumoSpacing.space32),
            Text(
              'You\'re booked.',
              style: LumoTypography.headlineLarge.copyWith(
                color: LumoColors.lightPrimary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            )
                .animate(delay: 200.ms)
                .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: LumoSpacing.space12),
            Text(
              'A Lumo expert will call you at your selected time. No preparation needed — just show up.',
              style: LumoTypography.bodyMedium.copyWith(
                color: LumoColors.lightTextSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            )
                .animate(delay: 300.ms)
                .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter),
            const SizedBox(height: LumoSpacing.space48),
            GestureDetector(
              onTap: onDone,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: LumoSpacing.space16),
                decoration: BoxDecoration(
                  color: LumoColors.lightPrimary,
                  borderRadius: LumoRadius.borderMedium,
                ),
                child: Center(
                  child: Text(
                    'Back to home',
                    style: LumoTypography.labelLarge.copyWith(
                      color: LumoColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
                .animate(delay: 400.ms)
                .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
                .slideY(begin: 0.1, end: 0),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Data
// ─────────────────────────────────────────────

class _Expert {
  const _Expert({
    required this.name,
    required this.title,
    required this.languages,
    required this.avatar,
    required this.rating,
    required this.consultations,
  });

  final String name;
  final String title;
  final String languages;
  final String avatar;
  final String rating;
  final String consultations;
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: LumoTypography.labelSmall.copyWith(
        color: LumoColors.lightTextTertiary,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
