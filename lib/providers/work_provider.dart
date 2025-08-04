import 'package:flutter/foundation.dart';
import '../services/firebase_service.dart';

class WorkProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<Project> _projects = [];
  List<Workspace> _workspaces = [];
  WorkTool _selectedTool = WorkTool.gantt;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Project> get projects => _projects;
  List<Workspace> get workspaces => _workspaces;
  WorkTool get selectedTool => _selectedTool;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Workspace methods
  Future<bool> createWorkspace({
    required String name,
    required String description,
    String? iconUrl,
    String? headerUrl,
    List<String>? roleTags,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final String userId = _firebaseService.auth.currentUser?.uid ?? '';
      if (userId.isEmpty) return false;

      final Map<String, dynamic> workspaceData = {
        'userId': userId,
        'name': name,
        'description': description,
        'iconUrl': iconUrl,
        'headerUrl': headerUrl,
        'roleTags': roleTags ?? [],
        'widgets': [],
        'folders': [],
        'createdAt': DateTime.now().toIso8601String(),
      };

      await _firebaseService.addDocument('workspaces', workspaceData);
      await loadWorkspaces();
      
      return true;
    } catch (e) {
      _setError('Failed to create workspace: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadWorkspaces() async {
    try {
      final String userId = _firebaseService.auth.currentUser?.uid ?? '';
      if (userId.isEmpty) return;

      final querySnapshot = await _firebaseService.firestore
          .collection('workspaces')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _workspaces = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Workspace.fromMap(doc.id, data);
      }).toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load workspaces: $e');
    }
  }

  Future<bool> updateWorkspace(String workspaceId, {
    String? name,
    String? description,
    String? iconUrl,
    String? headerUrl,
    List<String>? roleTags,
    List<WorkspaceWidget>? widgets,
  }) async {
    try {
      final Map<String, dynamic> updates = {};
      if (name != null) updates['name'] = name;
      if (description != null) updates['description'] = description;
      if (iconUrl != null) updates['iconUrl'] = iconUrl;
      if (headerUrl != null) updates['headerUrl'] = headerUrl;
      if (roleTags != null) updates['roleTags'] = roleTags;
      if (widgets != null) {
        updates['widgets'] = widgets.map((w) => w.toMap()).toList();
      }
      
      updates['updatedAt'] = DateTime.now().toIso8601String();

      await _firebaseService.updateDocument('workspaces', workspaceId, updates);
      await loadWorkspaces();
      
      return true;
    } catch (e) {
      _setError('Failed to update workspace: $e');
      return false;
    }
  }

  // Project methods
  Future<bool> createProject({
    required String workspaceId,
    required String name,
    required String description,
    ProjectType type = ProjectType.general,
    DateTime? deadline,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final String userId = _firebaseService.auth.currentUser?.uid ?? '';
      if (userId.isEmpty) return false;

      final Map<String, dynamic> projectData = {
        'userId': userId,
        'workspaceId': workspaceId,
        'name': name,
        'description': description,
        'type': type.name,
        'deadline': deadline?.toIso8601String(),
        'progress': 0,
        'status': ProjectStatus.planning.name,
        'nodes': [],
        'connections': [],
        'createdAt': DateTime.now().toIso8601String(),
      };

      await _firebaseService.addDocument('projects', projectData);
      await loadProjects();
      
      return true;
    } catch (e) {
      _setError('Failed to create project: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadProjects() async {
    try {
      final String userId = _firebaseService.auth.currentUser?.uid ?? '';
      if (userId.isEmpty) return;

      final querySnapshot = await _firebaseService.firestore
          .collection('projects')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _projects = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Project.fromMap(doc.id, data);
      }).toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load projects: $e');
    }
  }

  Future<bool> updateProjectProgress(String projectId, int progress) async {
    try {
      ProjectStatus status = ProjectStatus.planning;
      if (progress > 0 && progress < 100) {
        status = ProjectStatus.inProgress;
      } else if (progress >= 100) {
        status = ProjectStatus.completed;
      }

      await _firebaseService.updateDocument('projects', projectId, {
        'progress': progress,
        'status': status.name,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      
      await loadProjects();
      return true;
    } catch (e) {
      _setError('Failed to update project progress: $e');
      return false;
    }
  }

  // Work tool methods
  void setSelectedTool(WorkTool tool) {
    _selectedTool = tool;
    notifyListeners();
  }

  Future<bool> createGanttChart({
    required String projectId,
    required List<GanttTask> tasks,
  }) async {
    try {
      final Map<String, dynamic> ganttData = {
        'projectId': projectId,
        'tasks': tasks.map((task) => task.toMap()).toList(),
        'createdAt': DateTime.now().toIso8601String(),
      };

      await _firebaseService.addDocument('gantt_charts', ganttData);
      return true;
    } catch (e) {
      _setError('Failed to create Gantt chart: $e');
      return false;
    }
  }

  Future<bool> createSWOTAnalysis({
    required String projectId,
    required List<String> strengths,
    required List<String> weaknesses,
    required List<String> opportunities,
    required List<String> threats,
  }) async {
    try {
      final Map<String, dynamic> swotData = {
        'projectId': projectId,
        'strengths': strengths,
        'weaknesses': weaknesses,
        'opportunities': opportunities,
        'threats': threats,
        'createdAt': DateTime.now().toIso8601String(),
      };

      await _firebaseService.addDocument('swot_analyses', swotData);
      return true;
    } catch (e) {
      _setError('Failed to create SWOT analysis: $e');
      return false;
    }
  }

  // Analytics
  Map<String, dynamic> getProjectAnalytics() {
    final totalProjects = _projects.length;
    final completedProjects = _projects.where((p) => p.status == ProjectStatus.completed).length;
    final inProgressProjects = _projects.where((p) => p.status == ProjectStatus.inProgress).length;
    final planningProjects = _projects.where((p) => p.status == ProjectStatus.planning).length;

    final averageProgress = totalProjects > 0
        ? _projects.map((p) => p.progress).reduce((a, b) => a + b) / totalProjects
        : 0.0;

    return {
      'totalProjects': totalProjects,
      'completedProjects': completedProjects,
      'inProgressProjects': inProgressProjects,
      'planningProjects': planningProjects,
      'averageProgress': averageProgress,
      'completionRate': totalProjects > 0 ? (completedProjects / totalProjects) * 100 : 0.0,
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
enum WorkTool {
  gantt, wbs, agile, cpm, // Project Tools
  flowchart, pareto, fishbone, // Quality Tools
  swot, impactMatrix, // Risk Tools
  delegationMatrix, feedbackBoard, // Team Tools
  stakeholderAnalysis, decisionTree, scrum, // Decision Tools
}

enum ProjectType { general, software, marketing, research, design }
enum ProjectStatus { planning, inProgress, completed, onHold, cancelled }
enum WidgetType { checklist, calendar, kanban, progressBar }

// Data models
class Workspace {
  final String id;
  final String name;
  final String description;
  final String? iconUrl;
  final String? headerUrl;
  final List<String> roleTags;
  final List<WorkspaceWidget> widgets;
  final DateTime createdAt;

  Workspace({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
    this.headerUrl,
    required this.roleTags,
    required this.widgets,
    required this.createdAt,
  });

  factory Workspace.fromMap(String id, Map<String, dynamic> map) {
    return Workspace(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      iconUrl: map['iconUrl'],
      headerUrl: map['headerUrl'],
      roleTags: List<String>.from(map['roleTags'] ?? []),
      widgets: (map['widgets'] as List<dynamic>?)
          ?.map((w) => WorkspaceWidget.fromMap(w))
          .toList() ?? [],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

class WorkspaceWidget {
  final WidgetType type;
  final String title;
  final Map<String, dynamic> config;

  WorkspaceWidget({
    required this.type,
    required this.title,
    required this.config,
  });

  factory WorkspaceWidget.fromMap(Map<String, dynamic> map) {
    return WorkspaceWidget(
      type: WidgetType.values.firstWhere((t) => t.name == map['type']),
      title: map['title'] ?? '',
      config: Map<String, dynamic>.from(map['config'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'title': title,
      'config': config,
    };
  }
}

class Project {
  final String id;
  final String workspaceId;
  final String name;
  final String description;
  final ProjectType type;
  final DateTime? deadline;
  final int progress;
  final ProjectStatus status;
  final DateTime createdAt;

  Project({
    required this.id,
    required this.workspaceId,
    required this.name,
    required this.description,
    required this.type,
    this.deadline,
    required this.progress,
    required this.status,
    required this.createdAt,
  });

  factory Project.fromMap(String id, Map<String, dynamic> map) {
    return Project(
      id: id,
      workspaceId: map['workspaceId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      type: ProjectType.values.firstWhere(
        (t) => t.name == map['type'],
        orElse: () => ProjectType.general,
      ),
      deadline: map['deadline'] != null ? DateTime.parse(map['deadline']) : null,
      progress: map['progress'] ?? 0,
      status: ProjectStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => ProjectStatus.planning,
      ),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

class GanttTask {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final int progress;
  final List<String> dependencies;

  GanttTask({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.progress,
    required this.dependencies,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'progress': progress,
      'dependencies': dependencies,
    };
  }
}
