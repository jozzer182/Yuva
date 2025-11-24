import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers.dart';
import '../../data/models/job_models.dart';
import '../../data/models/rating.dart';
import '../../design_system/colors.dart';
import '../../design_system/components/yuva_button.dart';
import '../../design_system/components/yuva_card.dart';
import '../../design_system/components/yuva_scaffold.dart';
import '../../design_system/typography.dart';
import '../../l10n/app_localizations.dart';
import '../jobs/job_providers.dart';
import 'ratings_providers.dart';

class RateJobScreen extends ConsumerStatefulWidget {
  final JobPost job;
  final ProSummary? pro;
  final Rating? existingRating;

  const RateJobScreen({
    super.key,
    required this.job,
    this.pro,
    this.existingRating,
  });

  @override
  ConsumerState<RateJobScreen> createState() => _RateJobScreenState();
}

class _RateJobScreenState extends ConsumerState<RateJobScreen> {
  late int _selectedStars;
  late TextEditingController _commentController;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _selectedStars = widget.existingRating?.ratingValue ?? 5;
    _commentController = TextEditingController(text: widget.existingRating?.comment ?? '');
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateText = widget.job.preferredStartDate != null
        ? DateFormat.yMMMEd(Localizations.localeOf(context).toString())
            .add_Hm()
            .format(widget.job.preferredStartDate!)
        : l10n.jobToBeScheduled;

    return YuvaScaffold(
      useGradientBackground: true,
      appBar: AppBar(
        title: Text(l10n.rateJobTitle, style: YuvaTypography.subtitle()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              YuvaCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          (isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal).withValues(alpha: 0.16),
                      child: const Icon(
                        Icons.work_outline_rounded,
                        color: YuvaColors.primaryTealDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_resolveJobTitle(l10n, widget.job), style: YuvaTypography.subtitle()),
                          const SizedBox(height: 4),
                          Text(
                            widget.pro?.displayName ?? l10n.proDeleted,
                            style: YuvaTypography.caption(color: YuvaColors.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            dateText,
                            style: YuvaTypography.caption(color: YuvaColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(l10n.ratingPromptTitle, style: YuvaTypography.title()),
              const SizedBox(height: 6),
              Text(
                l10n.ratingPromptSubtitle,
                style: YuvaTypography.body(color: YuvaColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Center(
                child: Wrap(
                  spacing: 12,
                  children: List.generate(
                    5,
                    (index) {
                      final starValue = index + 1;
                      final isSelected = starValue <= _selectedStars;
                      return _ClayStar(
                        value: starValue,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedStars = starValue;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: l10n.ratingOptionalComment,
                  hintText: l10n.ratingCommentHint,
                ),
              ),
              const SizedBox(height: 20),
              YuvaButton(
                text: widget.existingRating == null ? l10n.submitRating : l10n.updateRating,
                isLoading: _submitting,
                onPressed: _submitting ? null : () => _submit(context, l10n),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context, AppLocalizations l10n) async {
    if (_selectedStars == 0) return;
    setState(() {
      _submitting = true;
    });

    final userId = ref.read(currentUserProvider)?.id ?? widget.job.userId;
    final rating = Rating(
      id: widget.existingRating?.id ?? '',
      jobPostId: widget.job.id,
      proId: widget.pro?.id,
      userId: userId,
      ratingValue: _selectedStars,
      comment: _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
      createdAt: DateTime.now(),
    );

    try {
      await ref.read(ratingsRepositoryProvider).submitRating(rating);
      await ref.read(jobPostRepositoryProvider).updateStatus(
            jobPostId: widget.job.id,
            status: JobPostStatus.completed,
          );
      ref.invalidate(jobPostsProvider);
      ref.invalidate(userRatingsProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.ratingSuccess),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  String _resolveJobTitle(AppLocalizations l10n, JobPost job) {
    if (job.customTitle != null && job.customTitle!.isNotEmpty) return job.customTitle!;
    switch (job.titleKey) {
      case 'jobTitleDeepCleanApt':
        return l10n.jobTitleDeepCleanApt;
      case 'jobTitleWeeklyHouse':
        return l10n.jobTitleWeeklyHouse;
      case 'jobTitleOfficeReset':
        return l10n.jobTitleOfficeReset;
      default:
        return l10n.jobCustomTitle;
    }
  }
}

class _ClayStar extends StatefulWidget {
  final int value;
  final bool isSelected;
  final VoidCallback onTap;

  const _ClayStar({
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ClayStar> createState() => _ClayStarState();
}

class _ClayStarState extends State<_ClayStar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _scale = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.value = 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0).whenComplete(() => _controller.value = 1);
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? (isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal).withValues(alpha: 0.15)
                : (isDark ? YuvaColors.darkSurface : YuvaColors.surfaceCream),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: isDark ? 0.04 : 0.5),
                blurRadius: 6,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Icon(
            widget.isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
            size: 32,
            color: widget.isSelected ? Colors.amber.shade700 : YuvaColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
