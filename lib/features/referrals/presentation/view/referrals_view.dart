import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/referrals_provider.dart';
import '../../../../core/theme/animations.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/app_cta_button.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class ReferralsView extends ConsumerWidget {
  const ReferralsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(referralsProvider);
    final isRtl = localization.isRtl;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(localization.translate('referrals_title')),
          flexibleSpace: Opacity(
            opacity: 0.9,
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.aurora),
            ),
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
            children: [
              GlassContainer(
                borderRadius: AppRadiusTokens.xl,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localization.translate('referrals_subtitle'),
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _StatTile(
                            icon: IconlyBold.star,
                            label: localization.translate('referrals_points_label'),
                            value: state.totalPoints.toString(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatTile(
                            icon: IconlyBold.user,
                            label: localization.translate('referrals_friends_label'),
                            value: state.friendsJoined.toString(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatTile(
                            icon: IconlyBold.activity,
                            label: localization.translate('referrals_monthly_label'),
                            value: state.monthlyOpens.toString(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SelectableText(
                      state.link,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AppCtaButton(
                            label: localization.translate('referrals_share_cta'),
                            leading: const Icon(IconlyBold.send, color: Colors.black),
                            onPressed: () {
                              Share.share(state.link);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () async {
                            await Clipboard.setData(ClipboardData(text: state.link));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(localization.translate('referrals_copied'))),
                            );
                          },
                          icon: const Icon(IconlyLight.copy),
                          tooltip: localization.translate('referrals_copy_link'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile.adaptive(
                      value: state.boostActive,
                      onChanged: (value) => ref.read(referralsProvider.notifier).toggleBoost(value),
                      title: Text(localization.translate('referrals_boost_label')),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        await ref.read(referralsProvider.notifier).simulateInvite();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(localization.translate('referrals_invite_simulate'))),
                        );
                      },
                      icon: const Icon(IconlyLight.add_user),
                      label: Text(localization.translate('referrals_add_mock')),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: AppAnimations.medium),
              const SizedBox(height: 32),
              Text(
                localization.translate('referrals_rewards_section'),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              ...state.rewards.map((reward) {
                final progress = (state.totalPoints / reward.pointsRequired).clamp(0.0, 1.0);
                final canClaim = !reward.isClaimed && state.totalPoints >= reward.pointsRequired;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GlassContainer(
                    borderRadius: AppRadiusTokens.lg,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: AppRadiusTokens.md,
                          child: CachedNetworkImage(
                            imageUrl: reward.imageUrl,
                            width: 88,
                            height: 88,
                            fit: BoxFit.cover,
                          ),
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
                                      localization.translate(reward.titleKey),
                                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  if (reward.badgeKey != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        borderRadius: AppRadiusTokens.sm,
                                        gradient: AppGradients.aurora,
                                      ),
                                      child: Text(
                                        localization.translate(reward.badgeKey!),
                                        style: theme.textTheme.labelSmall?.copyWith(color: Colors.white),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                localization.translate(reward.descriptionKey),
                                style: theme.textTheme.bodySmall,
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: AppRadiusTokens.sm,
                                child: LinearProgressIndicator(
                                  value: progress.toDouble(),
                                  minHeight: 8,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                localization.translate('referrals_requirement').replaceFirst('{points}', reward.pointsRequired.toString()),
                                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: ElevatedButton.icon(
                                  onPressed: canClaim
                                      ? () async {
                                          final claimed = await ref.read(referralsProvider.notifier).claimReward(reward.id);
                                          if (claimed && context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(localization.translate('referrals_claim_success'))),
                                            );
                                          }
                                        }
                                      : null,
                                  icon: Icon(canClaim ? IconlyBold.tick_square : IconlyLight.lock),
                                  label: Text(
                                    reward.isClaimed
                                        ? localization.translate('referrals_claimed')
                                        : localization.translate('referrals_claim'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassContainer(
      borderRadius: AppRadiusTokens.md,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(label, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
