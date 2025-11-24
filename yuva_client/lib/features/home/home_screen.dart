import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/components/yuva_button.dart';
import '../../design_system/components/yuva_card.dart';
import '../../design_system/components/yuva_chip.dart';
import '../../design_system/components/yuva_scaffold.dart';
import '../../core/providers.dart';
import '../../core/responsive.dart';
import '../../data/models/cleaner.dart';
import '../../data/models/job_models.dart';
import '../../data/models/service_category.dart';
import 'package:yuva/l10n/app_localizations.dart';
import '../jobs/job_detail_screen.dart';
import '../jobs/job_providers.dart';
import '../jobs/post_job_flow/post_job_flow_screen.dart';
import '../messaging/conversations_list_screen.dart';
import '../notifications/notifications_screen.dart';
import 'package:intl/intl.dart';
import '../cleaners/cleaner_detail_screen.dart';
import 'package:yuva/utils/money_formatter.dart';
import 'dart:math';

final categoriesProvider = FutureProvider<List<ServiceCategory>>((ref) async {
  final categoryRepo = ref.read(categoryRepositoryProvider);
  return await categoryRepo.getCategories();
});

final featuredCleanersProvider = FutureProvider<List<Cleaner>>((ref) async {
  final cleanerRepo = ref.read(cleanerRepositoryProvider);
  return await cleanerRepo.getFeaturedCleaners();
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _unreadMessagesCount = 0;
  int _unreadNotificationsCount = 0;
  List<Cleaner>? _featuredStable;

  @override
  void initState() {
    super.initState();
    _loadUnreadCounts();
  }

  Future<void> _loadUnreadCounts() async {
    final conversationsRepo = ref.read(clientConversationsRepositoryProvider);
    final notificationsRepo = ref.read(clientNotificationsRepositoryProvider);

    final conversations = await conversationsRepo.getConversations();
    final notifications = await notificationsRepo.getNotifications();

    if (mounted) {
      setState(() {
        _unreadMessagesCount = conversations.fold<int>(
          0,
          (sum, conv) => sum + conv.unreadCount,
        );
        _unreadNotificationsCount = notifications.where((n) => !n.isRead).length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(currentUserProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final cleanersAsync = ref.watch(featuredCleanersProvider);
    final jobsAsync = ref.watch(jobPostsProvider);

    return YuvaScaffold(
      useGradientBackground: true,
      appBar: AppBar(
        backgroundColor: YuvaColors.primaryTeal,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.hello(user?.firstName ?? 'Cliente'),
          style: YuvaTypography.title(color: Colors.white),
        ),
        actions: [
          // Notifications icon with badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  ).then((_) => _loadUnreadCounts());
                },
              ),
              if (_unreadNotificationsCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _unreadNotificationsCount > 9 ? '9+' : _unreadNotificationsCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          // Messages icon with badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.message_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConversationsListScreen(),
                    ),
                  ).then((_) => _loadUnreadCounts());
                },
              ),
              if (_unreadMessagesCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _unreadMessagesCount > 9 ? '9+' : _unreadMessagesCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = ResponsiveUtils.isTablet(context) || ResponsiveUtils.isLargeTablet(context);
            final isLandscape = ResponsiveUtils.isLandscape(context);
            final padding = ResponsiveUtils.horizontalPadding(context);
            final maxWidth = ResponsiveUtils.maxContentWidth(context);

            if (isTablet) {
              return _buildTabletLayout(
                context,
                l10n,
                user,
                categoriesAsync,
                cleanersAsync,
                jobsAsync,
                padding,
                maxWidth,
                isLandscape,
              );
            }

            return _buildPhoneLayout(
              context,
              l10n,
              user,
              categoriesAsync,
              cleanersAsync,
              jobsAsync,
            );
          },
        ),
      ),
    );
  }

  String _getCategoryName(AppLocalizations l10n, String nameKey) {
    switch (nameKey) {
      case 'categoryOnetime':
        return l10n.categoryOnetime;
      case 'categoryWeekly':
        return l10n.categoryWeekly;
      case 'categoryDeep':
        return l10n.categoryDeep;
      case 'categoryMoving':
        return l10n.categoryMoving;
      default:
        return nameKey;
    }
  }

  IconData _getCategoryIcon(String icon) {
    switch (icon) {
      case 'cleaning_services':
        return Icons.cleaning_services_rounded;
      case 'event_repeat':
        return Icons.event_repeat_rounded;
      case 'auto_awesome':
        return Icons.auto_awesome_rounded;
      case 'moving':
        return Icons.moving_rounded;
      default:
        return Icons.home_rounded;
    }
  }

  Widget _buildCleanerCard(BuildContext context, Cleaner cleaner, AppLocalizations l10n) {
    return YuvaCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => CleanerDetailScreen(cleaner: cleaner)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(cleaner.photoUrl),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            cleaner.name,
                            style: YuvaTypography.subtitle(),
                          ),
                        ),
                        if (cleaner.isVerified)
                          const Icon(
                            Icons.verified_rounded,
                            color: YuvaColors.primaryTeal,
                            size: 20,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: YuvaColors.accentGold,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.rating(cleaner.rating.toString(), cleaner.reviewCount),
                          style: YuvaTypography.caption(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            cleaner.bio,
            style: YuvaTypography.bodySmall(color: YuvaColors.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.perHour('\$${formatAmount(cleaner.pricePerHour, context)}'),
                style: YuvaTypography.subtitle(color: YuvaColors.primaryTeal),
              ),
              Text(
                l10n.yearsExperience(cleaner.yearsExperience),
                style: YuvaTypography.caption(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _jobSnippet(BuildContext context, JobPost job, AppLocalizations l10n) {
    final locale = Localizations.localeOf(context).toString();
    final schedule = job.preferredStartDate != null
        ? DateFormat.MMMd(locale).add_Hm().format(job.preferredStartDate!)
        : l10n.jobToBeScheduled;
    final statusLabel = _localizeStatus(l10n, job.status);

    return YuvaCard(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => JobDetailScreen(jobId: job.id)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_resolveJobTitle(l10n, job), style: YuvaTypography.subtitle()),
              YuvaChip(label: statusLabel, isSelected: true),
            ],
          ),
          const SizedBox(height: 6),
          Text(job.areaLabel, style: YuvaTypography.body(color: YuvaColors.textSecondary)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: YuvaColors.primaryTeal),
              const SizedBox(width: 6),
              Text(schedule, style: YuvaTypography.caption()),
              const SizedBox(width: 12),
              Icon(Icons.mail_outline, size: 16, color: YuvaColors.primaryTeal),
              const SizedBox(width: 6),
              Text(l10n.proposalsCount(job.proposalIds.length), style: YuvaTypography.caption()),
            ],
          ),
        ],
      ),
    );
  }

  void _onCategoryTap(BuildContext context, String categoryId) {
    String? preselect;
    switch (categoryId) {
      case 'deep':
        preselect = 'deep';
        break;
      case 'moving':
        preselect = 'moveout';
        break;
      case 'weekly':
        preselect = 'standard';
        break;
      default:
        preselect = 'standard';
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PostJobFlowScreen(preselectedServiceTypeId: preselect)),
    );
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

  String _localizeStatus(AppLocalizations l10n, JobPostStatus status) {
    switch (status) {
      case JobPostStatus.draft:
        return l10n.jobStatusDraft;
      case JobPostStatus.open:
        return l10n.jobStatusOpen;
      case JobPostStatus.underReview:
        return l10n.jobStatusUnderReview;
      case JobPostStatus.hired:
        return l10n.jobStatusHired;
      case JobPostStatus.inProgress:
        return l10n.jobStatusInProgress;
      case JobPostStatus.completed:
        return l10n.jobStatusCompleted;
      case JobPostStatus.cancelled:
        return l10n.jobStatusCancelled;
    }
  }

  Widget _buildPhoneLayout(
    BuildContext context,
    AppLocalizations l10n,
    dynamic user,
    AsyncValue<List<ServiceCategory>> categoriesAsync,
    AsyncValue<List<Cleaner>> cleanersAsync,
    AsyncValue<List<JobPost>> jobsAsync,
  ) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: l10n.searchPlaceholder,
                    prefixIcon: const Icon(Icons.search_rounded),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        title: l10n.unreadMessages,
                        count: _unreadMessagesCount,
                        icon: Icons.message,
                        color: YuvaColors.primaryTeal,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ConversationsListScreen(),
                            ),
                          ).then((_) => _loadUnreadCounts());
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryCard(
                        title: l10n.newNotifications,
                        count: _unreadNotificationsCount,
                        icon: Icons.notifications,
                        color: YuvaColors.accentGold,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationsScreen(),
                            ),
                          ).then((_) => _loadUnreadCounts());
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverToBoxAdapter(
            child: YuvaCard(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.postJobHeroTitle, style: YuvaTypography.subtitle()),
                        const SizedBox(height: 6),
                        Text(
                          l10n.postJobHeroSubtitle,
                          style: YuvaTypography.body(color: YuvaColors.textSecondary),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            YuvaButton(
                              text: l10n.postJobCta,
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const PostJobFlowScreen()),
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.marketplaceHint,
                                style: YuvaTypography.caption(color: YuvaColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.work_outline_rounded, size: 48, color: YuvaColors.primaryTeal),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          sliver: SliverToBoxAdapter(
            child: Text(
              l10n.openJobsShort,
              style: YuvaTypography.sectionTitle(),
            ),
          ),
        ),
        jobsAsync.when(
          data: (jobs) {
            final openJobs = jobs
                .where((job) =>
                    job.status == JobPostStatus.open || job.status == JobPostStatus.underReview)
                .toList()
              ..sort((a, b) => (a.createdAt).compareTo(b.createdAt));
            if (openJobs.isEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    l10n.noJobsYet,
                    style: YuvaTypography.body(color: YuvaColors.textSecondary),
                  ),
                ),
              );
            }
            final displayJobs = openJobs.take(3).toList();
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final job = displayJobs[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _jobSnippet(context, job, l10n),
                    );
                  },
                  childCount: displayJobs.length,
                ),
              ),
            );
          },
          loading: () => const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, st) => SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text('Error: $e'),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          sliver: SliverToBoxAdapter(
            child: Text(
              l10n.categories,
              style: YuvaTypography.sectionTitle(),
            ),
          ),
        ),
        categoriesAsync.when(
          data: (categories) => SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((category) {
                  return YuvaChip(
                    label: _getCategoryName(l10n, category.nameKey),
                    icon: _getCategoryIcon(category.icon),
                    onTap: () => _onCategoryTap(context, category.id),
                  );
                }).toList(),
              ),
            ),
          ),
          loading: () => const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, st) => SliverToBoxAdapter(
            child: Text('Error: $e'),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          sliver: SliverToBoxAdapter(
            child: Text(
              l10n.featuredCleaners,
              style: YuvaTypography.sectionTitle(),
            ),
          ),
        ),
        cleanersAsync.when(
          data: (cleaners) {
            if (_featuredStable == null) {
              final rng = Random();
              final pool = List<Cleaner>.from(cleaners);
              pool.shuffle(rng);
              _featuredStable = pool.take(3).toList();
            }
            final display = _featuredStable!;
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final cleaner = display[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildCleanerCard(context, cleaner, l10n),
                    );
                  },
                  childCount: display.length,
                ),
              ),
            );
          },
          loading: () => const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, st) => SliverToBoxAdapter(
            child: Text('Error: $e'),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
      ],
    );
  }

  Widget _buildTabletLayout(
    BuildContext context,
    AppLocalizations l10n,
    dynamic user,
    AsyncValue<List<ServiceCategory>> categoriesAsync,
    AsyncValue<List<Cleaner>> cleanersAsync,
    AsyncValue<List<JobPost>> jobsAsync,
    EdgeInsets padding,
    double maxWidth,
    bool isLandscape,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(padding.left, 24, padding.right, 16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: l10n.searchPlaceholder,
                        prefixIcon: const Icon(Icons.search_rounded),
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            title: l10n.unreadMessages,
                            count: _unreadMessagesCount,
                            icon: Icons.message,
                            color: YuvaColors.primaryTeal,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ConversationsListScreen(),
                                ),
                              ).then((_) => _loadUnreadCounts());
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SummaryCard(
                            title: l10n.newNotifications,
                            count: _unreadNotificationsCount,
                            icon: Icons.notifications,
                            color: YuvaColors.accentGold,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NotificationsScreen(),
                                ),
                              ).then((_) => _loadUnreadCounts());
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: padding.left),
              sliver: SliverToBoxAdapter(
                child: YuvaCard(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.postJobHeroTitle, style: YuvaTypography.subtitle()),
                            const SizedBox(height: 6),
                            Text(
                              l10n.postJobHeroSubtitle,
                              style: YuvaTypography.body(color: YuvaColors.textSecondary),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                YuvaButton(
                                  text: l10n.postJobCta,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => const PostJobFlowScreen()),
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    l10n.marketplaceHint,
                                    style: YuvaTypography.caption(color: YuvaColors.textSecondary),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.work_outline_rounded, size: 48, color: YuvaColors.primaryTeal),
                    ],
                  ),
                ),
              ),
            ),
            if (isLandscape) ...[
              // Landscape: 2-3 column layout
              SliverPadding(
                padding: EdgeInsets.fromLTRB(padding.left, 24, padding.left, 16),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left column: Jobs
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.openJobsShort,
                              style: YuvaTypography.sectionTitle(),
                            ),
                            const SizedBox(height: 12),
                            jobsAsync.when(
                              data: (jobs) {
                                final openJobs = jobs
                                    .where((job) =>
                                        job.status == JobPostStatus.open ||
                                        job.status == JobPostStatus.underReview)
                                    .toList()
                                  ..sort((a, b) => (a.createdAt).compareTo(b.createdAt));
                                if (openJobs.isEmpty) {
                                  return Text(
                                    l10n.noJobsYet,
                                    style: YuvaTypography.body(color: YuvaColors.textSecondary),
                                  );
                                }
                                final displayJobs = openJobs.take(3).toList();
                                return Column(
                                  children: displayJobs
                                      .map((job) => Padding(
                                            padding: const EdgeInsets.only(bottom: 12),
                                            child: _jobSnippet(context, job, l10n),
                                          ))
                                      .toList(),
                                );
                              },
                              loading: () => const Center(child: CircularProgressIndicator()),
                              error: (e, st) => Text('Error: $e'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Right column: Categories and Cleaners
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.categories,
                              style: YuvaTypography.sectionTitle(),
                            ),
                            const SizedBox(height: 12),
                            categoriesAsync.when(
                              data: (categories) => Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: categories.map((category) {
                                  return YuvaChip(
                                    label: _getCategoryName(l10n, category.nameKey),
                                    icon: _getCategoryIcon(category.icon),
                                    onTap: () => _onCategoryTap(context, category.id),
                                  );
                                }).toList(),
                              ),
                              loading: () => const Center(child: CircularProgressIndicator()),
                              error: (e, st) => Text('Error: $e'),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              l10n.featuredCleaners,
                              style: YuvaTypography.sectionTitle(),
                            ),
                            const SizedBox(height: 12),
                            cleanersAsync.when(
                              data: (cleaners) {
                                if (_featuredStable == null) {
                                  final rng = Random();
                                  final pool = List<Cleaner>.from(cleaners);
                                  pool.shuffle(rng);
                                  _featuredStable = pool.take(3).toList();
                                }
                                final display = _featuredStable!;
                                return Column(
                                  children: display
                                      .map((cleaner) => Padding(
                                            padding: const EdgeInsets.only(bottom: 16),
                                            child: _buildCleanerCard(context, cleaner, l10n),
                                          ))
                                      .toList(),
                                );
                              },
                              loading: () => const Center(child: CircularProgressIndicator()),
                              error: (e, st) => Text('Error: $e'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Portrait: Single column but wider
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: padding.left, vertical: 16),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    l10n.openJobsShort,
                    style: YuvaTypography.sectionTitle(),
                  ),
                ),
              ),
              jobsAsync.when(
                data: (jobs) {
                  final openJobs = jobs
                      .where((job) =>
                          job.status == JobPostStatus.open ||
                          job.status == JobPostStatus.underReview)
                      .toList()
                    ..sort((a, b) => (a.createdAt).compareTo(b.createdAt));
                  if (openJobs.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding.left),
                        child: Text(
                          l10n.noJobsYet,
                          style: YuvaTypography.body(color: YuvaColors.textSecondary),
                        ),
                      ),
                    );
                  }
                  final displayJobs = openJobs.take(3).toList();
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: padding.left),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final job = displayJobs[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _jobSnippet(context, job, l10n),
                          );
                        },
                        childCount: displayJobs.length,
                      ),
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, st) => SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding.left),
                    child: Text('Error: $e'),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: padding.left, vertical: 16),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    l10n.categories,
                    style: YuvaTypography.sectionTitle(),
                  ),
                ),
              ),
              categoriesAsync.when(
                data: (categories) => SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: padding.left),
                  sliver: SliverToBoxAdapter(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: categories.map((category) {
                        return YuvaChip(
                          label: _getCategoryName(l10n, category.nameKey),
                          icon: _getCategoryIcon(category.icon),
                          onTap: () => _onCategoryTap(context, category.id),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, st) => SliverToBoxAdapter(
                  child: Text('Error: $e'),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: padding.left, vertical: 24),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    l10n.featuredCleaners,
                    style: YuvaTypography.sectionTitle(),
                  ),
                ),
              ),
              cleanersAsync.when(
                data: (cleaners) {
                  if (_featuredStable == null) {
                    final rng = Random();
                    final pool = List<Cleaner>.from(cleaners);
                    pool.shuffle(rng);
                    _featuredStable = pool.take(3).toList();
                  }
                  final display = _featuredStable!;
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: padding.left),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final cleaner = display[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildCleanerCard(context, cleaner, l10n),
                          );
                        },
                        childCount: display.length,
                      ),
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, st) => SliverToBoxAdapter(
                  child: Text('Error: $e'),
                ),
              ),
            ],
            SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SummaryCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return YuvaCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              if (count > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: YuvaTypography.body().copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            count == 0
                ? 'Todo al día'
                : count == 1
                    ? '1 nuevo'
                    : '$count nuevos',
            style: YuvaTypography.caption(color: YuvaColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
