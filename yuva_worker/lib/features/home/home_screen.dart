import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuva_worker/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../utils/money_formatter.dart';
import '../../core/providers.dart';
import '../../core/responsive.dart';
import '../../data/models/shared_types.dart';
import '../../data/models/worker_job.dart';
import '../../data/models/worker_profile.dart';
import '../../design_system/colors.dart';
import '../../design_system/components/yuva_card.dart';
import '../../design_system/components/yuva_chip.dart';
import '../jobs/job_detail_screen.dart';
import '../messaging/conversations_list_screen.dart';
import '../notifications/notifications_screen.dart';

/// Home screen for workers - shows recommended jobs and invitations
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<WorkerJobSummary>? _recommendedJobs;
  List<WorkerJobSummary>? _invitedJobs;
  bool _isLoading = true;
  int _unreadMessagesCount = 0;
  int _unreadNotificationsCount = 0;
  WorkerProfile? _worker;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadJobs(),
      _loadUnreadCounts(),
      _loadWorkerProfile(),
    ]);
  }

  Future<void> _loadJobs() async {
    final repo = ref.read(workerJobFeedRepositoryProvider);
    final recommended = await repo.getRecommendedJobs();
    final invited = await repo.getInvitedJobs();

    if (mounted) {
      setState(() {
        _recommendedJobs = recommended.take(3).toList();
        _invitedJobs = invited;
      });
    }
  }

  Future<void> _loadUnreadCounts() async {
    final conversationsRepo = ref.read(workerConversationsRepositoryProvider);
    final notificationsRepo = ref.read(workerNotificationsRepositoryProvider);

    final conversations = await conversationsRepo.getConversations();
    final notifications = await notificationsRepo.getNotifications();

    if (mounted) {
      setState(() {
        _unreadMessagesCount = conversations.fold<int>(
          0,
          (sum, conv) => sum + conv.unreadCount,
        );
        _unreadNotificationsCount = notifications.where((n) => !n.isRead).length;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadWorkerProfile() async {
    final repo = ref.read(workerProfileRepositoryProvider);
    final profile = await repo.getCurrentWorker();
    if (mounted) {
      setState(() {
        _worker = profile;
      });
      ref.read(currentWorkerProvider.notifier).state = profile;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final workerProfile = ref.watch(currentWorkerProvider) ?? _worker;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? YuvaColors.darkBackground : YuvaColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? YuvaColors.darkSurface : YuvaColors.primaryTeal,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.hello((workerProfile?.displayName.split(' ').first) ?? 'Profesional'),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                builder: (context, constraints) {
                  final isTablet = ResponsiveUtils.isTablet(context) || ResponsiveUtils.isLargeTablet(context);
                  final isLandscape = ResponsiveUtils.isLandscape(context);
                  final padding = ResponsiveUtils.padding(context);
                  final maxWidth = ResponsiveUtils.maxContentWidth(context);

                  if (isTablet) {
                    return _buildTabletLayout(
                      context,
                      l10n,
                      padding,
                      maxWidth,
                      isLandscape,
                    );
                  }

                  return _buildPhoneLayout(context, l10n);
                },
              ),
      ),
    );
  }

  Widget _buildPhoneLayout(BuildContext context, AppLocalizations l10n) {
    return RefreshIndicator(
      onRefresh: _loadJobs,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
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
            if (_invitedJobs != null && _invitedJobs!.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                l10n.invitations,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 12),
              ..._invitedJobs!.map((job) => _JobSummaryCard(job: job)),
            ],
            const SizedBox(height: 24),
            Text(
              l10n.recommendedJobs,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 12),
            if (_recommendedJobs != null && _recommendedJobs!.isNotEmpty)
              ..._recommendedJobs!.map((job) => _JobSummaryCard(job: job))
            else
              Text(
                l10n.noJobsAvailable,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout(
    BuildContext context,
    AppLocalizations l10n,
    EdgeInsets padding,
    double maxWidth,
    bool isLandscape,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: RefreshIndicator(
          onRefresh: _loadJobs,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: padding,
            child: isLandscape
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            if (_invitedJobs != null && _invitedJobs!.isNotEmpty) ...[
                              const SizedBox(height: 24),
                              Text(
                                l10n.invitations,
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              const SizedBox(height: 12),
                              ..._invitedJobs!.map((job) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _JobSummaryCard(job: job),
                                  )),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.recommendedJobs,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(height: 12),
                            if (_recommendedJobs != null && _recommendedJobs!.isNotEmpty)
                              ..._recommendedJobs!.map((job) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _JobSummaryCard(job: job),
                                  ))
                            else
                              Text(
                                l10n.noJobsAvailable,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
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
                      if (_invitedJobs != null && _invitedJobs!.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(
                          l10n.invitations,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: 12),
                        ..._invitedJobs!.map((job) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _JobSummaryCard(job: job),
                            )),
                      ],
                      const SizedBox(height: 24),
                      Text(
                        l10n.recommendedJobs,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 12),
                      if (_recommendedJobs != null && _recommendedJobs!.isNotEmpty)
                        ..._recommendedJobs!.map((job) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _JobSummaryCard(job: job),
                            ))
                      else
                        Text(
                          l10n.noJobsAvailable,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _JobSummaryCard extends ConsumerWidget {
  final WorkerJobSummary job;

  const _JobSummaryCard({required this.job});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    String getBudgetText() {
      if (job.budgetType == JobBudgetType.fixed) {
        return l10n.fixedBudget('\u0024' + formatAmount(job.fixedBudget ?? 0, context));
      } else {
        return l10n.hourlyRange(
          '\u0024' + formatAmount(job.hourlyRateFrom ?? 0, context),
          '\u0024' + formatAmount(job.hourlyRateTo ?? 0, context),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: YuvaCard(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => JobDetailScreen(jobId: job.id),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    job.customTitle ?? l10n.getString(job.titleKey),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                if (job.isInvited)
                  YuvaChip(
                    label: l10n.invitation,
                    chipStyle: YuvaChipStyle.accent,
                    icon: Icons.mail,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.location_on, 
                  size: 16, 
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : YuvaColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  job.areaLabel,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.repeat, 
                  size: 16, 
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : YuvaColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  l10n.getString(job.frequency.labelKey),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              getBudgetText(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// money formatting moved to utils/money_formatter.dart

// Extension to get string from l10n by key
extension AppLocalizationsX on AppLocalizations {
  String getString(String key) {
    // Simple key mapping - in real app this would be more robust
    switch (key) {
      case 'serviceStandard':
        return serviceStandard;
      case 'serviceDeepClean':
        return serviceDeepClean;
      case 'serviceMoveOut':
        return serviceMoveOut;
      case 'serviceOffice':
        return serviceOffice;
      case 'frequencyOnce':
        return frequencyOnce;
      case 'frequencyWeekly':
        return frequencyWeekly;
      case 'frequencyBiweekly':
        return frequencyBiweekly;
      case 'frequencyMonthly':
        return frequencyMonthly;
      case 'jobTitleDeepCleanApt':
        return jobTitleDeepCleanApt;
      case 'jobTitleWeeklyHouse':
        return jobTitleWeeklyHouse;
      case 'jobTitleOfficeReset':
        return jobTitleOfficeReset;
      case 'jobTitlePostMoveCondo':
        return jobTitlePostMoveCondo;
      case 'jobTitleBiweeklyStudio':
        return jobTitleBiweeklyStudio;
      default:
        return key;
    }
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }
}
