import 'package:flutter/material.dart';
import 'package:yuva/design_system/colors.dart';
import 'package:yuva/design_system/components/yuva_button.dart';
import 'package:yuva/design_system/components/yuva_card.dart';
import 'package:yuva/design_system/typography.dart';
import 'package:yuva/data/models/cleaner.dart';
import 'package:yuva/l10n/app_localizations.dart';
import '../jobs/post_job_flow/post_job_flow_screen.dart';
import 'package:yuva/utils/money_formatter.dart';

class CleanerDetailScreen extends StatelessWidget {
  final Cleaner cleaner;
  const CleanerDetailScreen({super.key, required this.cleaner});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(cleaner.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 36, backgroundImage: NetworkImage(cleaner.photoUrl)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cleaner.name, style: YuvaTypography.subtitle()),
                      const SizedBox(height: 4),
                      Text(
                        l10n.rating(cleaner.rating.toString(), cleaner.reviewCount),
                        style: YuvaTypography.caption(color: YuvaColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            YuvaCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cleaner.bio, style: YuvaTypography.body()),
                  const SizedBox(height: 10),
                  Text(
                    l10n.perHour('\$${formatAmount(cleaner.pricePerHour, context)}'),
                    style: YuvaTypography.subtitle(color: YuvaColors.primaryTeal),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: YuvaButton(
                text: l10n.postJobCta,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PostJobFlowScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
