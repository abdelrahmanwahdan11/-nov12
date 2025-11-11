import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/models/notification_message.dart';
import '../../../../core/providers/notifications_provider.dart';
import '../../../../core/theme/animations.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class NotificationsCenterView extends ConsumerWidget {
  const NotificationsCenterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isRtl = localization.isRtl;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(localization.translate('notifications_center_title')),
          flexibleSpace: Opacity(
            opacity: 0.9,
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.aurora),
            ),
          ),
          actions: [
            IconButton(
              onPressed: notifications.isEmpty
                  ? null
                  : () => ref.read(notificationsProvider.notifier).markAllRead(),
              icon: const Icon(Icons.done_all_rounded),
              tooltip: localization.translate('notifications_mark_all'),
            ),
            IconButton(
              onPressed: notifications.isEmpty
                  ? null
                  : () => ref.read(notificationsProvider.notifier).clearAll(),
              icon: const Icon(Icons.delete_sweep_rounded),
              tooltip: localization.translate('notifications_clear_all'),
            ),
          ],
        ),
        body: SafeArea(
          child: notifications.isEmpty
              ? _EmptyNotifications(message: localization.translate('notifications_empty'))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  itemBuilder: (context, index) {
                    final message = notifications[index];
                    return _NotificationTile(message: message)
                        .animate()
                        .fadeIn(duration: AppAnimations.medium, delay: Duration(milliseconds: 60 * index));
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemCount: notifications.length,
                ),
        ),
      ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  const _NotificationTile({required this.message});

  final NotificationMessage message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final icon = switch (message.category) {
      NotificationCategory.queue => Icons.auto_mode_rounded,
      NotificationCategory.download => Icons.download_done_rounded,
      NotificationCategory.announcement => Icons.campaign_rounded,
      NotificationCategory.system => Icons.info_outline_rounded,
    };
    final color = switch (message.category) {
      NotificationCategory.queue => theme.colorScheme.primary,
      NotificationCategory.download => theme.colorScheme.secondary,
      NotificationCategory.announcement => theme.colorScheme.tertiary,
      NotificationCategory.system => theme.colorScheme.primaryContainer,
    };

    var body = localization.translate(message.bodyKey);
    message.data.forEach((key, value) {
      body = body.replaceAll('{$key}', value);
    });

    final timeAgo = _relativeTime(context, message.createdAt);

    return GlassContainer(
      borderRadius: AppRadiusTokens.lg,
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
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
                        localization.translate(message.titleKey),
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    if (!message.isRead)
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timeAgo,
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    TextButton(
                      onPressed: () => ref.read(notificationsProvider.notifier).markRead(message.id),
                      child: Text(localization.translate('notifications_action_mark_read')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _relativeTime(BuildContext context, DateTime time) {
    final localization = AppLocalizations.of(context);
    final difference = DateTime.now().difference(time);
    if (difference.inMinutes < 1) {
      return localization.translate('notifications_relative_now');
    }
    if (difference.inMinutes < 60) {
      return localization
          .translate('notifications_relative_minutes')
          .replaceAll('{value}', difference.inMinutes.toString());
    }
    if (difference.inHours < 24) {
      return localization
          .translate('notifications_relative_hours')
          .replaceAll('{value}', difference.inHours.toString());
    }
    return localization
        .translate('notifications_relative_days')
        .replaceAll('{value}', difference.inDays.toString());
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_rounded, size: 64, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
