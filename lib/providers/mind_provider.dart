import 'package:flutter/foundation.dart';
import '../services/firebase_service.dart';
import '../services/ai_service.dart';

class MindProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final AIService _aiService = AIService();

  List<JournalEntry> _journalEntries = [];
  List<MindDump> _mindDumps = [];
  List<Goal> _goals = [];
  Map<String, int> _streaks = {};
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<JournalEntry> get journalEntries => _journalEntries;
  List<MindDump> get mindDumps => _mindDumps;
  List<Goal> get goals => _goals;
  Map<String, int> get streaks => _streaks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Journal methods
  Future<bool> addJournalEntry({
    required String content,
    required int moodScore,
    List<String>? tags,
    String? imageUrl,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final String userId = _firebaseService.auth.currentUser?.uid ?? '';
      if (userId.isEmpty) return false;

      final Map<String, dynamic> entryData = {
        'userId': userId,
        'content': content,
        'moodScore': moodScore,
        'tags': tags ?? [],
        'imageUrl': imageUrl,
        'createdAt': DateTime.now().toIso8601String(),
      };

      final docRef = await _firebaseService.addDocument('journal_entries', entryData);
      
      // Analyze mood with AI
      final moodAnalysis = await _aiService.analyzeMoodEntry(
        journalEntry: content,
        moodScore: moodScore,
      );

      // Update entry with AI insights
      await _firebaseService.updateDocument('journal_entries', docRef.id, {
        'aiInsights': moodAnalysis,
      });

      // Update streak
      await _updateJournalStreak();
      
      // Refresh data
      await loadJournalEntries();
      
      return true;
    } catch (e) {
      _setError('Failed to add journal entry: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadJournalEntries() async {
    try {
      final String userId = _firebaseService.auth.currentUser?.uid ?? '';
      if (userId.isEmpty) return;

      final querySnapshot = await _firebaseService.firestore
          .collection('journal_entries')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _journalEntries = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return JournalEntry.fromMap(doc.id, data);
      }).toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load journal entries: $e');
    }
  }

  // Mind Dump methods
  Future<bool> addMindDump({
    required String title,
    required String content,
    List<String>? tags,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final String userId = _firebaseService.auth.currentUser?.uid ?? '';
      if (userId.isEmpty) return false;

      final Map<String, dynamic> dumpData = {
        'userId': userId,
        'title': title,
        'content': content,
        'tags': tags ?? [],
        'isPinned': false,
        'isArchived': false,
        'createdAt': DateTime.now().toIso8601String(),
      };

      await _firebaseService.addDocument('mind_dumps', dumpData);
      await loadMindDumps();
      
      return true;
    } catch (e) {
      _setError('Failed to add mind dump: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadMindDumps() async {
    try {
      final String userId = _firebaseService.auth.currentUser?.uid ?? '';
      if (userId.isEmpty) return;

      final querySnapshot = await _firebaseService.firestore
          .collection('mind_dumps')
          .where('userId', isEqualTo: userId)
          .where('isArchived', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .get();

      _mindDumps = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return MindDump.fromMap(doc.id, data);
      }).toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load mind dumps: $e');
    }
  }

  Future<bool> updateMindDump(String id, {
    String? title,
    String? content,
    bool? isPinned,
    bool? isArchived,
  }) async {
    try {
      final Map<String, dynamic> updates = {};
      if (title != null) updates['title'] = title;
      if (content != null) updates['content'] = content;
      if (isPinned != null) updates['isPinned'] = isPinned;
      if (isArchived != null) updates['isArchived'] = isArchived;

      await _firebaseService.updateDocument('mind_dumps', id, updates);
      await loadMindDumps();
      
      return true;
    } catch (e) {
      _setError('Failed to update mind dump: $e');
      return false;
    }
  }

  // Goals methods
  Future<bool> addGoal({
    required String title,
    required String description,
    required DateTime targetDate,
    String? category,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final String userId = _firebaseService.auth.currentUser?.uid ?? '';
      if (userId.isEmpty) return false;

      final Map<String, dynamic> goalData = {
        'userId': userId,
        'title': title,
        'description': description,
        'targetDate': targetDate.toIso8601String(),
        'category': category ?? 'personal',
        'progress': 0,
        'isCompleted': false,
        'createdAt': DateTime.now().toIso8601String(),
      };

      await _firebaseService.addDocument('goals', goalData);
      await loadGoals();
      
      return true;
    } catch (e) {
      _setError('Failed to add goal: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadGoals() async {
    try {
      final String userId = _firebaseService.auth.currentUser?.uid ?? '';
      if (userId.isEmpty) return;

      final querySnapshot = await _firebaseService.firestore
          .collection('goals')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _goals = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Goal.fromMap(doc.id, data);
      }).toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load goals: $e');
    }
  }

  Future<bool> updateGoalProgress(String goalId, int progress) async {
    try {
      await _firebaseService.updateDocument('goals', goalId, {
        'progress': progress,
        'isCompleted': progress >= 100,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      
      await loadGoals();
      return true;
    } catch (e) {
      _setError('Failed to update goal progress: $e');
      return false;
    }
  }

  // Streak methods
  Future<void> _updateJournalStreak() async {
    final String userId = _firebaseService.auth.currentUser?.uid ?? '';
    if (userId.isEmpty) return;

    // Check if user journaled today
    final DateTime today = DateTime.now();
    final DateTime startOfDay = DateTime(today.year, today.month, today.day);
    
    final querySnapshot = await _firebaseService.firestore
        .collection('journal_entries')
        .where('userId', isEqualTo: userId)
        .where('createdAt', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      _streaks['journal'] = (_streaks['journal'] ?? 0) + 1;
      
      // Update streak in Firestore
      await _firebaseService.updateDocument('users', userId, {
        'streaks.journal': _streaks['journal'],
      });
      
      notifyListeners();
    }
  }

  Future<void> loadStreaks() async {
    try {
      final String userId = _firebaseService.auth.currentUser?.uid ?? '';
      if (userId.isEmpty) return;

      final doc = await _firebaseService.getDocument('users', userId);
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        _streaks = Map<String, int>.from(data['streaks'] ?? {});
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to load streaks: $e');
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

// Data models
class JournalEntry {
  final String id;
  final String content;
  final int moodScore;
  final List<String> tags;
  final String? imageUrl;
  final DateTime createdAt;
  final Map<String, dynamic>? aiInsights;

  JournalEntry({
    required this.id,
    required this.content,
    required this.moodScore,
    required this.tags,
    this.imageUrl,
    required this.createdAt,
    this.aiInsights,
  });

  factory JournalEntry.fromMap(String id, Map<String, dynamic> map) {
    return JournalEntry(
      id: id,
      content: map['content'] ?? '',
      moodScore: map['moodScore'] ?? 5,
      tags: List<String>.from(map['tags'] ?? []),
      imageUrl: map['imageUrl'],
      createdAt: DateTime.parse(map['createdAt']),
      aiInsights: map['aiInsights'],
    );
  }
}

class MindDump {
  final String id;
  final String title;
  final String content;
  final List<String> tags;
  final bool isPinned;
  final bool isArchived;
  final DateTime createdAt;

  MindDump({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.isPinned,
    required this.isArchived,
    required this.createdAt,
  });

  factory MindDump.fromMap(String id, Map<String, dynamic> map) {
    return MindDump(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      isPinned: map['isPinned'] ?? false,
      isArchived: map['isArchived'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

class Goal {
  final String id;
  final String title;
  final String description;
  final DateTime targetDate;
  final String category;
  final int progress;
  final bool isCompleted;
  final DateTime createdAt;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.targetDate,
    required this.category,
    required this.progress,
    required this.isCompleted,
    required this.createdAt,
  });

  factory Goal.fromMap(String id, Map<String, dynamic> map) {
    return Goal(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      targetDate: DateTime.parse(map['targetDate']),
      category: map['category'] ?? 'personal',
      progress: map['progress'] ?? 0,
      isCompleted: map['isCompleted'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
