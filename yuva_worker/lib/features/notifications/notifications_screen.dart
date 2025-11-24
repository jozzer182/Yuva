import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuva_worker/l10n/app_localizations.dart';
import '../../core/providers.dart';
import '../../data/models/worker_notification.dart';
import '../../design_system/colors.dart';
import '../../design_system/components/yuva_card.dart';
import '../messaging/conversations_list_screen.dart';
import '../jobs/job_detail_screen.dart';

/// Pantalla de centro de notificaciones
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  List<WorkerNotification>? _notifications;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final repo = ref.read(workerNotificationsRepositoryProvider);
    final notifications = await repo.getNotifications();

    if (mounted) {
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    final repo = ref.read(workerNotificationsRepositoryProvider);
    await repo.markNotificationRead(notificationId);
    _loadNotifications();
  }

  Future<void> _markAllAsRead() async {
    final repo = ref.read(workerNotificationsRepositoryProvider);
    await repo.markAllRead();
    _loadNotifications();
  }

  void _handleNotificationTap(WorkerNotification notification) {
    // Marcar como leída
    _markAsRead(notification.id);

    // Navegar según el tipo
    switch (notification.type) {
      case WorkerNotificationType.newMessage:
        if (notification.conversationId != null) {
          // Navegar a la conversación específica
          // Por ahora, navegar a la lista de conversaciones
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ConversationsListScreen(),
            ),
          );
        }
        break;
      case WorkerNotificationType.proposalStatusChange:
      case WorkerNotificationType.jobStatusChange:
        if (notification.jobPostId != null) {
          // Navegar al detalle del trabajo
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobDetailScreen(jobId: notification.jobPostId!),
            ),
          );
        }
        break;
      case WorkerNotificationType.genericInfo:
        // No navegar, solo mostrar
        break;
    }
  }

  IconData _getNotificationIcon(WorkerNotificationType type) {
    switch (type) {
      case WorkerNotificationType.proposalStatusChange:
        return Icons.description;
      case WorkerNotificationType.newMessage:
        return Icons.message;
      case WorkerNotificationType.jobStatusChange:
        return Icons.work;
      case WorkerNotificationType.genericInfo:
        return Icons.info;
    }
  }

  Color _getNotificationColor(WorkerNotificationType type) {
    switch (type) {
      case WorkerNotificationType.proposalStatusChange:
        return YuvaColors.accentGold;
      case WorkerNotificationType.newMessage:
        return YuvaColors.primaryTeal;
      case WorkerNotificationType.jobStatusChange:
        return Colors.blue;
      case WorkerNotificationType.genericInfo:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return 'hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'hace ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'ahora';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unreadCount = _notifications?.where((n) => !n.isRead).length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
        backgroundColor: isDark ? YuvaColors.darkSurface : YuvaColors.primaryTeal,
        foregroundColor: Colors.white,
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                l10n.markAllAsRead,
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications == null || _notifications!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noNotificationsYet,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.noNotificationsDescription,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[500],
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNotifications,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notifications!.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications![index];
                      final iconColor = _getNotificationColor(notification.type);
                      final icon = _getNotificationIcon(notification.type);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: YuvaCard(
                          onTap: () => _handleNotificationTap(notification),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: iconColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  icon,
                                  color: iconColor,
                                  size: 24,
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
                                            notification.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: notification.isRead
                                                      ? FontWeight.normal
                                                      : FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                        if (!notification.isRead)
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: YuvaColors.primaryTeal,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      notification.body,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Colors.grey[700],
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _formatTime(notification.createdAt),
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Colors.grey[600],
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

