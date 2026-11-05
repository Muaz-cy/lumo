import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lumo/features/inquiry/domain/entities/inquiry_entity.dart';
import 'package:lumo/features/inquiry/providers/inquiry_providers.dart';
import 'package:lumo/shared/design_system/design_system.dart';

class InquiriesScreen extends ConsumerWidget {
  const InquiriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inquiries = ref.watch(inquiryNotifierProvider);

    return Scaffold(
      backgroundColor: LumoColors.lightBackground,
      body: inquiries.isEmpty
          ? const _Empty()
          : _Content(inquiries: inquiries),
    );
  }
}

// ─────────────────────────────────────────────
// Content
// ─────────────────────────────────────────────

class _Content extends StatelessWidget {
  const _Content({required this.inquiries});
  final List<InquiryEntity> inquiries;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: LumoColors.lightBackground,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            onPressed: () => context.pop(),
            color: colors.onSurface,
          ),
          title: Column(
            children: [
              Text('My Inquiries',
                  style: LumoTypography.titleLarge.copyWith(color: colors.onSurface)),
              Text(
                '${inquiries.length} submitted',
                style: LumoTypography.bodySmall.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            LumoSpacing.space24, LumoSpacing.space8,
            LumoSpacing.space24, LumoSpacing.space80,
          ),
          sliver: SliverList.separated(
            itemCount: inquiries.length,
            separatorBuilder: (_, __) => const SizedBox(height: LumoSpacing.space12),
            itemBuilder: (_, i) => _InquiryCard(inquiry: inquiries[i], index: i),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Inquiry card
// ─────────────────────────────────────────────

class _InquiryCard extends StatelessWidget {
  const _InquiryCard({required this.inquiry, required this.index});
  final InquiryEntity inquiry;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dateFmt = DateFormat('MMM d, yyyy');

    return GestureDetector(
      onTap: () => context.push('/property/${inquiry.propertyId}'),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: LumoRadius.borderLarge,
          border: Border.all(color: LumoColors.lightBorder),
          boxShadow: LumoShadows.soft,
        ),
        child: Row(
          children: [
            // Property thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(LumoRadius.large),
              ),
              child: SizedBox(
                width: 90,
                height: 90,
                child: Image.network(
                  inquiry.propertyImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: LumoColors.lightSurfaceSecondary),
                ),
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(LumoSpacing.space14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            inquiry.propertyTitle,
                            style: LumoTypography.labelLarge.copyWith(
                              color: colors.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: LumoSpacing.space8),
                        _StatusBadge(status: inquiry.status),
                      ],
                    ),
                    const SizedBox(height: LumoSpacing.space6),
                    Text(
                      inquiry.message,
                      style: LumoTypography.bodySmall.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.5),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: LumoSpacing.space8),
                    Text(
                      dateFmt.format(inquiry.submittedAt),
                      style: LumoTypography.labelSmall.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: (index * 50).ms)
        .fadeIn(duration: LumoMotion.normal, curve: LumoMotion.enter)
        .slideY(begin: 0.05, end: 0);
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final InquiryStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      InquiryStatus.pending => ('Pending', LumoColors.lightGold),
      InquiryStatus.responded => ('Responded', LumoColors.lightVerified),
      InquiryStatus.closed => ('Closed', LumoColors.lightTextSecondary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: LumoSpacing.space8,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: LumoRadius.borderPill,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: LumoTypography.labelSmall.copyWith(
          color: color,
          fontSize: 10,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  size: 18, color: colors.onSurface),
              onPressed: () => context.pop(),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(LumoSpacing.space48),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 64,
                      color: LumoColors.lightGold.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: LumoSpacing.space24),
                    Text(
                      'No inquiries yet',
                      style: LumoTypography.headlineSmall.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: LumoSpacing.space12),
                    Text(
                      'When you inquire about a property,\nit will appear here.',
                      style: LumoTypography.bodyMedium.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: LumoSpacing.space40),
                    SizedBox(
                      width: 200,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => context.go('/home'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: LumoColors.lightGold,
                          foregroundColor: LumoColors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: LumoRadius.borderMedium),
                        ),
                        child: const Text('Browse properties'),
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(duration: LumoMotion.deliberate, curve: LumoMotion.enter)
                    .scale(
                      begin: const Offset(0.95, 0.95),
                      end: const Offset(1, 1),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
