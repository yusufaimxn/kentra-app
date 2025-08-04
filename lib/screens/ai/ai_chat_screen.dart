import 'package:flutter/material.dart';
import '../../core/constants.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Mock chat messages for demonstration
  final List<Map<String, dynamic>> _messages = [
    {
      'content': 'Hello! I\'m your AI Co-Pilot. How can I help you today?',
      'isUser': false,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AI Persona selector
        _buildPersonaSelector(),
        
        // Context selector
        _buildContextSelector(),
        
        // Chat messages
        Expanded(
          child: _buildChatMessages(),
        ),
        
        // Message input
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildPersonaSelector() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: AppColors.primary.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          const Icon(AppIcons.aiChat, color: AppColors.primary),
          const SizedBox(width: AppSizes.paddingSmall),
          const Text(
            'AI Mode:',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: AppSizes.paddingMedium),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPersonaChip('Friend', Icons.favorite, true),
                  const SizedBox(width: AppSizes.paddingSmall),
                  _buildPersonaChip('Mentor', Icons.school, false),
                  const SizedBox(width: AppSizes.paddingSmall),
                  _buildPersonaChip('Strategist', Icons.psychology, false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonaChip(String label, IconData icon, bool isSelected) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        // TODO: Handle persona selection
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildContextSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: AppColors.accent.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.link, color: AppColors.accent, size: 16),
          const SizedBox(width: AppSizes.paddingSmall),
          const Text(
            'Context:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: AppSizes.paddingSmall),
          Expanded(
            child: Text(
              'No workspace selected',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Show context selector
            },
            child: const Text('Select', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(
          message['content'] as String,
          message['isUser'] as bool,
          message['timestamp'] as DateTime,
        );
      },
    );
  }

  Widget _buildMessageBubble(String content, bool isUser, DateTime timestamp) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingMedium),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: const Icon(
                AppIcons.aiChat,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: AppSizes.paddingSmall),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                border: isUser ? null : Border.all(color: AppColors.textLight.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content,
                    style: TextStyle(
                      color: isUser ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingSmall),
                  Text(
                    _formatTime(timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: isUser ? Colors.white70 : AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: AppSizes.paddingSmall),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.accent,
              child: const Icon(
                Icons.person,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: AppColors.textLight.withOpacity(0.3)),
        ),
      ),
      child: Column(
        children: [
          // Slash commands hint
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.paddingSmall),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
            ),
            child: const Text(
              'Try slash commands: /task, /note, /focus',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.info,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSizes.paddingSmall),
          
          // Input row
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // TODO: Handle file upload
                },
                icon: const Icon(Icons.attach_file),
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMedium,
                      vertical: AppSizes.paddingSmall,
                    ),
                  ),
                  maxLines: null,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: AppSizes.paddingSmall),
              IconButton(
                onPressed: () {
                  // TODO: Handle voice input
                },
                icon: const Icon(Icons.mic),
              ),
              IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send),
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({
        'content': message,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
    });

    _messageController.clear();

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add({
          'content': 'This is a placeholder AI response. The actual AI integration will be implemented in Step 7.',
          'isUser': false,
          'timestamp': DateTime.now(),
        });
      });

      // Scroll to bottom again
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}
