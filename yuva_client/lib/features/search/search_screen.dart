import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/job_models.dart';
import '../../design_system/colors.dart';
import '../../design_system/components/avatar_picker.dart';
import '../../design_system/components/yuva_button.dart';
import '../../design_system/components/yuva_card.dart';
import '../../design_system/components/yuva_chip.dart';
import '../../design_system/components/yuva_scaffold.dart';
import '../../design_system/typography.dart';
import '../../l10n/app_localizations.dart';
import '../jobs/job_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prosAsync = ref.watch(proSummariesProvider);
    final jobsAsync = ref.watch(jobPostsProvider);

    return YuvaScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.searchProsTitle,
                style: YuvaTypography.title(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: l10n.searchPlaceholder,
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark ? Colors.white54 : YuvaColors.textSecondary,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: isDark ? YuvaColors.darkSurface : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white12 : YuvaColors.textTertiary.withValues(alpha: 0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white12 : YuvaColors.textTertiary.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? YuvaColors.darkPrimaryTeal : YuvaColors.primaryTeal,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) => setState(() {}),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.searchInviteHint,
                style: YuvaTypography.body(color: YuvaColors.textSecondary),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: prosAsync.when(
                  data: (pros) {
                    final blockedIdsAsync = ref.watch(blockedUserIdsProvider);
                    final blockedIds = blockedIdsAsync.valueOrNull ?? [];
                    
                    final filtered = pros
                        .where((pro) =>
                            !blockedIds.contains(pro.id) && // Filter out blocked workers
                            (pro.displayName.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                            pro.areaLabel.toLowerCase().contains(_searchController.text.toLowerCase())))
                        .toList();
                    if (filtered.isEmpty) {
                      return Center(
                        child: Text(l10n.noProsFound, style: YuvaTypography.body()),
                      );
                    }
                    return ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final pro = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _proCard(context, pro, l10n, jobsAsync),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text(e.toString())),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _proCard(
    BuildContext context,
    ProSummary pro,
    AppLocalizations l10n,
    AsyncValue<List<JobPost>> jobsAsync,
  ) {
    final specialtyLabels = pro.offeredServiceTypeIds.map((id) => _localizeServiceType(l10n, id)).join(' · ');

    return YuvaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarDisplay(
                avatarId: pro.avatarId,
                fallbackInitial: pro.avatarInitials ?? pro.displayName,
                size: 56,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pro.displayName, style: YuvaTypography.subtitle()),
                    const SizedBox(height: 4),
                    Text(
                      '${pro.ratingAverage.toStringAsFixed(1)} (${pro.ratingCount}) · ${pro.areaLabel}',
                      style: YuvaTypography.caption(color: YuvaColors.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialtyLabels,
                      style: YuvaTypography.bodySmall(color: YuvaColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              YuvaButton(
                text: l10n.inviteToJob,
                onPressed: () => _showInviteModal(context, pro, l10n, jobsAsync),
                buttonStyle: YuvaButtonStyle.secondary,
              ),
              TextButton(
                onPressed: () => _showInviteModal(context, pro, l10n, jobsAsync),
                child: Text(
                  l10n.viewOpenJobs,
                  style: YuvaTypography.body(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showInviteModal(
    BuildContext context,
    ProSummary pro,
    AppLocalizations l10n,
    AsyncValue<List<JobPost>> jobsAsync,
  ) async {
    final jobs = jobsAsync.maybeWhen(data: (jobs) => jobs, orElse: () => const <JobPost>[]);
    final openJobs = jobs
        .where((job) => job.status == JobPostStatus.open || job.status == JobPostStatus.underReview)
        .toList();

    if (openJobs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noOpenJobsToInvite)),
      );
      return;
    }

    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.selectJobToInvite, style: YuvaTypography.subtitle()),
              const SizedBox(height: 12),
              ...openJobs.map(
                (job) => ListTile(
                  title: Text(_resolveJobTitle(l10n, job)),
                  subtitle: Text(job.areaLabel),
                  trailing: YuvaChip(
                    label: l10n.proposalsCount(job.proposalIds.length),
                    isSelected: true,
                  ),
                  onTap: () async {
                    await ref.read(jobPostRepositoryProvider).invitePro(jobPostId: job.id, proId: pro.id);
                    if (!context.mounted) return;
                    ref.invalidate(jobPostsProvider);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.inviteSent(pro.displayName))),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _localizeServiceType(AppLocalizations l10n, String id) {
    switch (id) {
      case 'deep':
        return l10n.serviceDeepClean;
      case 'moveout':
        return l10n.serviceMoveOut;
      case 'office':
        return l10n.serviceOffice;
      default:
        return l10n.serviceStandard;
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
