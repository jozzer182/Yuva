import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuva/l10n/app_localizations.dart';
import '../../core/providers.dart';
import '../../data/models/client_conversation.dart';
import '../../data/models/client_message.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';

/// Pantalla de detalle de conversación (chat) para clientes
class ConversationDetailScreen extends ConsumerStatefulWidget {
  final ClientConversation conversation;

  const ConversationDetailScreen({
    super.key,
    required this.conversation,
  });

  @override
  ConsumerState<ConversationDetailScreen> createState() => _ConversationDetailScreenState();
}

class _ConversationDetailScreenState extends ConsumerState<ConversationDetailScreen> {
  List<ClientMessage>? _messages;
  bool _isLoading = true;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _markConversationRead();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final repo = ref.read(clientConversationsRepositoryProvider);
    final messages = await repo.getConversationMessages(widget.conversation.id);

    if (mounted) {
      setState(() {
        _messages = messages;
        _isLoading = false;
      });
      // Scroll al final
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  Future<void> _markConversationRead() async {
    final repo = ref.read(clientConversationsRepositoryProvider);
    await repo.markConversationRead(widget.conversation.id);
  }

  Future<void> _showBlockDialog(BuildContext context, AppLocalizations l10n) async {
    final reasonController = TextEditingController();
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.blockUserTitle(widget.conversation.workerDisplayName)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.blockUserDescription,
                style: YuvaTypography.body(color: YuvaColors.textSecondary),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  hintText: l10n.blockReasonHint,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
                maxLength: 500,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: YuvaColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.blockConfirm),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _blockUser(reasonController.text.trim(), l10n);
    }
    
    reasonController.dispose();
  }

  Future<void> _blockUser(String reason, AppLocalizations l10n) async {
    try {
      final blockService = ref.read(blockServiceProvider);
      await blockService.blockUser(
        blockedUserId: widget.conversation.workerId,
        blockedUserType: 'worker',
        conversationId: widget.conversation.id,
        reason: reason.isNotEmpty ? reason : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.blockSuccess),
            backgroundColor: YuvaColors.success,
          ),
        );
        // Volver a la lista de conversaciones
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.blockError),
            backgroundColor: YuvaColors.error,
          ),
        );
      }
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _isSending = true;
    });

    final repo = ref.read(clientConversationsRepositoryProvider);
    final newMessage = await repo.sendMessage(widget.conversation.id, text);

    _messageController.clear();

    if (mounted) {
      setState(() {
        _messages = [...(_messages ?? []), newMessage];
        _isSending = false;
      });
      // Scroll al final
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.conversation.workerDisplayName),
            Text(
              l10n.activeJob,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: isDark ? YuvaColors.darkSurface : YuvaColors.primaryTeal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.shield_outlined),
            tooltip: l10n.blockUser,
            onPressed: () => _showBlockDialog(context, l10n),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _messages == null || _messages!.isEmpty
                    ? Center(
                        child: Text(
                          l10n.noMessagesInConversation,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages!.length,
                        itemBuilder: (context, index) {
                          final message = _messages![index];
                          final isClient = message.senderType == MessageSenderType.client;
                          final isSystem = message.senderType == MessageSenderType.system;

                          if (isSystem) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    message.text,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Colors.grey[700],
                                          fontStyle: FontStyle.italic,
                                        ),
                                  ),
                                ),
                              ),
                            );
                          }

                          return Align(
                            alignment: isClient ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.75,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isClient ? YuvaColors.primaryTeal : Colors.grey[200],
                                borderRadius: BorderRadius.circular(16).copyWith(
                                  bottomRight: isClient ? const Radius.circular(4) : null,
                                  bottomLeft: !isClient ? const Radius.circular(4) : null,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.text,
                                    style: TextStyle(
                                      color: isClient ? Colors.white : Colors.black87,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatTime(message.createdAt),
                                    style: TextStyle(
                                      color: isClient
                                          ? Colors.white70
                                          : Colors.grey[600],
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? YuvaColors.darkSurface : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: l10n.typeMessage,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _isSending ? null : _sendMessage,
                    icon: _isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                    color: YuvaColors.primaryTeal,
                    style: IconButton.styleFrom(
                      backgroundColor: YuvaColors.primaryTeal.withOpacity(0.1),
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inHours > 0) {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}

