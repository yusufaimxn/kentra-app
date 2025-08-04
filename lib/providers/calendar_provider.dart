import 'package:flutter/foundation.dart';
import '../services/firebase_service.dart';

class CalendarProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<Task> _tasks = [];
  List<Event> _events = [];
  DateTime _selectedDate = DateTime.now();
  CalendarView _currentView = CalendarView.grid;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Task> get tasks => _tasks;
  List<Event> get events => _events;
  DateTime get selectedDate => _selectedDate;
  CalendarView get currentView => _currentView;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Task> get todayTasks {
    final today = DateTime.now();
    return _tasks.where((task) {
      return task.dueDate.year == today.year &&
             task.dueDate.month == today.month &&
             task.dueDate.day == today.day;
    }).toList();
  }

  List<Task> get upcomingTasks {
    final now = DateTime.now();
    return _tasks.where((task) => task.dueDate.isAfter(now) && !task.isCompleted).toList();
  }

  // Task methods
  Future<bool> addTask({
    required String title,
    required DateTime dueDate,
    String? description,
    TaskPriority priority = TaskPriority.medium,
    List<String>? tags,
    bool isRecurring = false,
    RecurrenceType? recurrenceType,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final String userId = _firebaseService.auth.currentUser?.uid ?? '';
      if (userId.isEmpty) return false;

      final Map<String, dynamic> taskData = {
        'userId': userId,
        'title': title,
        'description': description ?? '',
        'dueDate': dueDate.toIso8601String(),
        'priority': priority.name,
        'tags': tags ?? [],
        'isCompleted': false,
        'isRecurring': isRecurring,
        'recurrenceType': recurrenceType?.name,
        'createdAt': DateTime.now().toIso8601String(),
      };

      await _firebaseService.addDocument('tasks', taskData);
      await loadTasks();
      
      return true;
    } catch (e) {
      _setError('Failed to add task: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadTasks() async {
    try {
      final String userId = _firebaseService.auth.currentUser?.uid ?? '';
      if (userId.isEmpty) return;

      final querySnapshot = await _firebaseService.firestore
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .orderBy('dueDate')
          .get();

      _tasks = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Task.fromMap(doc.id, data);
      }).toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load tasks: $e');
    }
  }

  Future<bool> updateTask(String taskId, {
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    bool? isCompleted,
  }) async {
    try {
      final Map<String, dynamic> updates = {};
      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (dueDate != null) updates['dueDate'] = dueDate.toIso8601String();
      if (priority != null) updates['priority'] = priority.name;
      if (isCompleted != null) updates['isCompleted'] = isCompleted;
      
      updates['updatedAt'] = DateTime.now().toIso8601String();

      await _firebaseService.updateDocument('tasks', taskId, updates);
      await loadTasks();
      
      return true;
    } catch (e) {
      _setError('Failed to update task: $e');
      return false;
    }
  }

  Future<bool> deleteTask(String taskId) async {
    try {
      await _firebaseService.deleteDocument('tasks', taskId);
      await loadTasks();
      return true;
    } catch (e) {
      _setError('Failed to delete task: $e');
      return false;
    }
  }

  // Event methods
  Future<bool> addEvent({
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    String? description,
    String? location,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final String userId = _firebaseService.auth.currentUser?.uid ?? '';
      if (userId.isEmpty) return false;

      final Map<String, dynamic> eventData = {
        'userId': userId,
        'title': title,
        'description': description ?? '',
        'location': location,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
      };

      await _firebaseService.addDocument('events', eventData);
      await loadEvents();
      
      return true;
    } catch (e) {
      _setError('Failed to add event: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadEvents() async {
    try {
      final String userId = _firebaseService.auth.currentUser?.uid ?? '';
      if (userId.isEmpty) return;

      final querySnapshot = await _firebaseService.firestore
          .collection('events')
          .where('userId', isEqualTo: userId)
          .orderBy('startTime')
          .get();

      _events = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Event.fromMap(doc.id, data);
      }).toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load events: $e');
    }
  }

  // Calendar navigation
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setCalendarView(CalendarView view) {
    _currentView = view;
    notifyListeners();
  }

  void goToToday() {
    _selectedDate = DateTime.now();
    notifyListeners();
  }

  void goToPreviousDay() {
    _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    notifyListeners();
  }

  void goToNextDay() {
    _selectedDate = _selectedDate.add(const Duration(days: 1));
    notifyListeners();
  }

  // Analytics
  Map<String, int> getTaskCompletionStats() {
    final completed = _tasks.where((task) => task.isCompleted).length;
    final pending = _tasks.where((task) => !task.isCompleted).length;
    final overdue = _tasks.where((task) => 
      !task.isCompleted && task.dueDate.isBefore(DateTime.now())
    ).length;

    return {
      'completed': completed,
      'pending': pending,
      'overdue': overdue,
      'total': _tasks.length,
    };
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

// Enums
enum CalendarView { grid, kanban, priority, focus, analytics, automation }
enum TaskPriority { low, medium, high, urgent }
enum RecurrenceType { daily, weekly, monthly, yearly }

// Data models
class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final List<String> tags;
  final bool isCompleted;
  final bool isRecurring;
  final RecurrenceType? recurrenceType;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.tags,
    required this.isCompleted,
    required this.isRecurring,
    this.recurrenceType,
    required this.createdAt,
  });

  factory Task.fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: DateTime.parse(map['dueDate']),
      priority: TaskPriority.values.firstWhere(
        (p) => p.name == map['priority'],
        orElse: () => TaskPriority.medium,
      ),
      tags: List<String>.from(map['tags'] ?? []),
      isCompleted: map['isCompleted'] ?? false,
      isRecurring: map['isRecurring'] ?? false,
      recurrenceType: map['recurrenceType'] != null
          ? RecurrenceType.values.firstWhere((r) => r.name == map['recurrenceType'])
          : null,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

class Event {
  final String id;
  final String title;
  final String description;
  final String? location;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime createdAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    this.location,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
  });

  factory Event.fromMap(String id, Map<String, dynamic> map) {
    return Event(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
