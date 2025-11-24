import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/booking_request.dart';
import '../../data/models/cleaning_service_type.dart';
import '../../data/models/job_models.dart';
import '../../data/models/rating.dart';
import '../../design_system/colors.dart';
import '../../design_system/components/yuva_card.dart';
import '../../design_system/components/yuva_scaffold.dart';
import '../../design_system/typography.dart';
import '../../l10n/app_localizations.dart';
import '../bookings/booking_providers.dart';
import '../bookings/rate_booking_screen.dart';
import '../jobs/job_providers.dart';
import 'rate_job_screen.dart';
import 'ratings_providers.dart';

class MyReviewsScreen extends ConsumerWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final ratingsAsync = ref.watch(userRatingsProvider);
    final bookingsAsync = ref.watch(bookingsProvider);
    final serviceTypesAsync = ref.watch(serviceTypesProvider);
    final jobsAsync = ref.watch(jobPostsProvider);
    final prosAsync = ref.watch(proSummariesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return YuvaScaffold(
      useGradientBackground: true,
      appBar: AppBar(
        title: Text(l10n.myReviews, style: YuvaTypography.subtitle()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ratingsAsync.when(
            data: (ratings) => bookingsAsync.when(
              data: (bookings) => serviceTypesAsync.when(
                data: (types) => jobsAsync.when(
                  data: (jobs) => prosAsync.when(
                    data: (pros) =>
                        _buildContent(context, l10n, ratings, bookings, types, jobs, pros, isDark),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(child: Text(error.toString())),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(child: Text(error.toString())),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text(error.toString())),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text(error.toString())),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text(error.toString())),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations l10n,
    List<Rating> ratings,
    List<BookingRequest> bookings,
    List<CleaningServiceType> serviceTypes,
    List<JobPost> jobs,
    List<ProSummary> pros,
    bool isDark,
  ) {
    if (ratings.isEmpty) {
      return _emptyState(context, l10n, isDark);
    }

    final bookingMap = {for (final booking in bookings) booking.id: booking};
    final jobMap = {for (final job in jobs) job.id: job};
    final proMap = {for (final pro in pros) pro.id: pro};

    return ListView.builder(
      itemCount: ratings.length,
      itemBuilder: (context, index) {
        final rating = ratings[index];
        final job = rating.jobPostId != null ? jobMap[rating.jobPostId] : null;
        if (job != null) {
          final pro = rating.proId != null ? proMap[rating.proId] : null;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _jobReviewCard(context, l10n, rating, job, pro, isDark),
          );
        }

        final booking = rating.bookingId != null ? bookingMap[rating.bookingId] : null;
        final serviceType = booking != null
            ? serviceTypes.firstWhere(
                (element) => element.id == booking.serviceTypeId,
                orElse: () => CleaningServiceType(
                  id: 'unknown',
                  titleKey: 'serviceTypeLabel',
                  descriptionKey: '',
                  iconName: 'cleaning_services',
                  baseRate: 0,
                ),
              )
            : null;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _reviewCard(context, l10n, rating, booking, serviceType, isDark),
        );
      },
    );
  }

  Widget _reviewCard(
    BuildContext context,
    AppLocalizations l10n,
    Rating rating,
    BookingRequest? booking,
    CleaningServiceType? serviceType,
    bool isDark,
  ) {
    final dateText = DateFormat.yMMMd(Localizations.localeOf(context).toString())
        .format(rating.createdAt);

    return YuvaCard(
      onTap: booking != null
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RateBookingScreen(
                    booking: booking,
                    serviceType: serviceType,
                    existingRating: rating,
                  ),
                ),
              );
            }
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (isDark ? YuvaColors.darkSurface : YuvaColors.surfaceCream),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _mapIcon(serviceType?.iconName ?? 'cleaning_services'),
                  color: YuvaColors.primaryTeal,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceType != null
                          ? _localizeService(l10n, serviceType.titleKey)
                          : l10n.serviceTypeLabel,
                      style: YuvaTypography.subtitle(),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateText,
                      style: YuvaTypography.caption(color: YuvaColors.textSecondary),
                    ),
                  ],
                ),
              ),
              _buildStars(rating.ratingValue),
            ],
          ),
          if (rating.comment != null && rating.comment!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isDark ? YuvaColors.darkSurface : YuvaColors.surfaceCream)
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                rating.comment!,
                style: YuvaTypography.body(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _jobReviewCard(
    BuildContext context,
    AppLocalizations l10n,
    Rating rating,
    JobPost job,
    ProSummary? pro,
    bool isDark,
  ) {
    final dateText = DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(rating.createdAt);

    return YuvaCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RateJobScreen(
              job: job,
              pro: pro,
              existingRating: rating,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (isDark ? YuvaColors.darkSurface : YuvaColors.surfaceCream),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.work_outline_rounded,
                  color: YuvaColors.primaryTeal,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _resolveJobTitle(l10n, job),
                      style: YuvaTypography.subtitle(),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pro?.displayName ?? l10n.proDeleted} · $dateText',
                      style: YuvaTypography.caption(color: YuvaColors.textSecondary),
                    ),
                  ],
                ),
              ),
              _buildStars(rating.ratingValue),
            ],
          ),
          if (rating.comment != null && rating.comment!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isDark ? YuvaColors.darkSurface : YuvaColors.surfaceCream).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                rating.comment!,
                style: YuvaTypography.body(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStars(int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        count,
        (index) => Icon(
          Icons.star_rounded,
          color: Colors.amber.shade700,
          size: 18,
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context, AppLocalizations l10n, bool isDark) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? YuvaColors.darkSurface.withValues(alpha: 0.5) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : YuvaColors.shadowLight,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: (isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTealLight)
                    .withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.star_border_rounded,
                size: 40,
                color: isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noReviewsYet,
              style: YuvaTypography.subtitle(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.noReviewsDescription,
              style: YuvaTypography.body(color: YuvaColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _mapIcon(String iconName) {
    switch (iconName) {
      case 'cleaning_services':
        return Icons.cleaning_services_rounded;
      case 'auto_awesome':
        return Icons.auto_awesome_rounded;
      case 'moving':
        return Icons.moving_rounded;
      case 'domain':
        return Icons.domain_rounded;
      default:
        return Icons.home_rounded;
    }
  }

  String _localizeService(AppLocalizations l10n, String key) {
    switch (key) {
      case 'serviceStandard':
        return l10n.serviceStandard;
      case 'serviceDeepClean':
        return l10n.serviceDeepClean;
      case 'serviceMoveOut':
        return l10n.serviceMoveOut;
      case 'serviceOffice':
        return l10n.serviceOffice;
      default:
        return key;
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
