import 'package:flutter/foundation.dart';
import '../services/ai_service.dart';
import '../services/firebase_service.dart';

class AIProvider extends ChangeNotifier {
  final AIService _aiService = AIService();
  final FirebaseService _firebaseService = FirebaseService();

  List<ChatMessage> _chatHistory = [];
  AIService.AIPersona _currentPersona = AIService.AIPersona.friend;
  String? _currentContext;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<ChatMessage> get chatHistory => _chatHistory;
  AIService.AIPersona get currentPersona => _currentPersona;
  String? get currentContext => _currentContext;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Chat methods
  Future<bool> sendMessage(String message) async {
    try {
      _setLoading(true);
      _clearError();

      // Add user message to history
      final userMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: message,
        isUser: true,
        timestamp: DateTime.now(),
        persona: _currentPersona,
      );
      
      _chatHistory.add(userMessage);
      notifyListeners();

      // Check if it's a slash command
      if (message.startsWith('/')) {
        return await _handleSlashCommand(message);
      }

      // Prepare conversation history for AI
      final conversationHistory = _chatHistory
          .where((msg) => !msg.isUser || !msg.content.startsWith('/'))
          .map((msg) => {
            'role': msg.isUser ? 'user' : 'assistant',
            'content': msg.content,
          })
          .toList();

      // Send to AI service
      final response = await _aiService.sendChatMessage(
        message: message,
        persona: _currentPersona,
        context: _currentContext,
        conversationHistory: conversationHistory,
      );

      // Add AI response to history
      final aiMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: response,
        isUser: false,
        timestamp: DateTime.now(),
        persona: _currentPersona,
      );
      
      _chatHistory.add(aiMessage);
      
      // Save chat history to Firestore
      await _saveChatHistory();
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to send message: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> _handleSlashCommand(String message) async {
    try {
      final parts = message.split(' ');
      final command = parts[0];
      final parameters = parts.length > 1 ? parts.sublist(1).join(' ') : '';

      final response = await _aiService.processSlashCommand(
        command: command,
        parameters: parameters,
        workspaceContext: _currentContext,
      );

      // Add command response to history
      final commandMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: response,
        isUser: false,
        timestamp: DateTime.now(),
        persona: _currentPersona,
        isCommand: true,
      );
      
      _chatHistory.add(commandMessage);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to process command: $e');
      return false;
    }
  }

  // Persona management
  void setPersona(AIService.AIPersona persona) {
    _currentPersona = persona;
    notifyListeners();
  }

  // Context management
  void setContext(String? context) {
    _currentContext = context;
    notifyListeners();
  }

  void setWorkspaceContext(String workspaceId, String workspaceName) {
    _currentContext = 'Workspace: $workspaceName (ID: $workspaceId)';
    notifyListeners();
  }

  void setProjectContext(String projectId, String projectName) {
    _currentContext = 'Project: $projectName (ID: $projectId)';
    notifyListeners();
  }

  void clearContext() {
    _currentContext = null;
    notifyListeners();
  }

  // Chat history management
  Future<void> loadChatHistory() async {
    try {
      final String userId = _firebaseService.auth.currentUser?.uid ?? '';
      if (userId.isEmpty) return;

      final querySnapshot = await _firebaseService.firestore
          .collection('chat_history')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp')
          .limit(100) // Load last 100 messages
          .get();

      _chatHistory = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return ChatMessage.fromMap(doc.id, data);
      }).toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load chat history: $e');
    }
  }

  Future<void> _saveChatHistory() async {
    try {
      final String userId = _firebaseService.auth.currentUser?.uid ?? '';
      if (userId.isEmpty) return;

      // Save only the last message (most recent)
      if (_chatHistory.isNotEmpty) {
        final lastMessage = _chatHistory.last;
        await _firebaseService.addDocument('chat_history', {
          'userId': userId,
          'content': lastMessage.content,
          'isUser': lastMessage.isUser,
          'persona': lastMessage.persona.name,
          'context': _currentContext,
          'isCommand': lastMessage.isCommand,
          'timestamp': lastMessage.timestamp.toIso8601String(),
        });
      }
    } catch (e) {
      // Silently fail to avoid disrupting chat flow
      debugPrint('Failed to save chat history: $e');
    }
  }

  void clearChatHistory() {
    _chatHistory.clear();
    notifyListeners();
  }

  // AI assistance methods
  Future<List<String>> generateTaskSuggestions({
    required String projectContext,
    required String currentGoal,
  }) async {
    try {
      return await _aiService.generateTaskSuggestions(
        projectContext: projectContext,
        currentGoal: currentGoal,
      );
    } catch (e) {
      _setError('Failed to generate task suggestions: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> analyzeMoodEntry({
    required String journalEntry,
    required int moodScore,
  }) async {
    try {
      return await _aiService.analyzeMoodEntry(
        journalEntry: journalEntry,
        moodScore: moodScore,
      );
    } catch (e) {
      _setError('Failed to analyze mood entry: $e');
      return {};
    }
  }

  Future<String> generateMotivationalMessage({
    required String userGoal,
    required int streakCount,
    required String recentActivity,
  }) async {
    try {
      return await _aiService.generateMotivationalMessage(
        userGoal: userGoal,
        streakCount: streakCount,
        recentActivity: recentActivity,
      );
    } catch (e) {
      _setError('Failed to generate motivational message: $e');
      return 'Keep up the great work! 🌟';
    }
  }

  Future<Map<String, dynamic>> provideDecisionSupport({
    required String decision,
    required List<String> options,
    String? context,
  }) async {
    try {
      return await _aiService.provideDecisionSupport(
        decision: decision,
        options: options,
        context: context,
      );
    } catch (e) {
      _setError('Failed to provide decision support: $e');
      return {};
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }
}

// Data model
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final AIService.AIPersona persona;
  final bool isCommand;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    required this.persona,
    this.isCommand = false,
  });

  factory ChatMessage.fromMap(String id, Map<String, dynamic> map) {
    return ChatMessage(
      id: id,
      content: map['content'] ?? '',
      isUser: map['isUser'] ?? false,
      timestamp: DateTime.parse(map['timestamp']),
      persona: AIService.AIPersona.values.firstWhere(
        (p) => p.name == map['persona'],
        orElse: () => AIService.AIPersona.friend,
      ),
      isCommand: map['isCommand'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'persona': persona.name,
      'isCommand': isCommand,
    };
  }
}
