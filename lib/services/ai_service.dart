import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  static const String _baseUrl = 'https://api.openai.com/v1';
  static const String _apiKey = 'YOUR_OPENAI_API_KEY'; // TODO: Move to environment variables

  // AI Persona Modes
  enum AIPersona {
    mentor,
    friend,
    strategist,
  }

  // Chat completion
  Future<String> sendChatMessage({
    required String message,
    required AIPersona persona,
    String? context,
    List<Map<String, String>>? conversationHistory,
  }) async {
    try {
      final String systemPrompt = _getSystemPrompt(persona);
      final List<Map<String, String>> messages = [
        {'role': 'system', 'content': systemPrompt},
        if (context != null) {'role': 'system', 'content': 'Context: $context'},
        if (conversationHistory != null) ...conversationHistory,
        {'role': 'user', 'content': message},
      ];

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': messages,
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('AI service error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to send chat message: $e');
    }
  }

  // Generate task suggestions
  Future<List<String>> generateTaskSuggestions({
    required String projectContext,
    required String currentGoal,
  }) async {
    try {
      final String prompt = '''
Based on the project context: "$projectContext" and current goal: "$currentGoal",
suggest 5 specific, actionable tasks that would help achieve this goal.
Return only the task descriptions, one per line.
''';

      final response = await sendChatMessage(
        message: prompt,
        persona: AIPersona.strategist,
      );

      return response.split('\n')
          .where((line) => line.trim().isNotEmpty)
          .map((line) => line.trim().replaceFirst(RegExp(r'^\d+\.\s*'), ''))
          .toList();
    } catch (e) {
      throw Exception('Failed to generate task suggestions: $e');
    }
  }

  // Analyze mood and provide insights
  Future<Map<String, dynamic>> analyzeMoodEntry({
    required String journalEntry,
    required int moodScore,
  }) async {
    try {
      final String prompt = '''
Analyze this journal entry and mood score (1-10): 
Entry: "$journalEntry"
Mood Score: $moodScore

Provide insights in JSON format with:
- "sentiment": "positive/neutral/negative"
- "keyThemes": ["theme1", "theme2", ...]
- "suggestions": ["suggestion1", "suggestion2", ...]
- "moodTrend": "improving/stable/declining"
''';

      final response = await sendChatMessage(
        message: prompt,
        persona: AIPersona.mentor,
      );

      return jsonDecode(response);
    } catch (e) {
      return {
        'sentiment': 'neutral',
        'keyThemes': ['reflection'],
        'suggestions': ['Continue journaling regularly'],
        'moodTrend': 'stable',
      };
    }
  }

  // Generate motivational message
  Future<String> generateMotivationalMessage({
    required String userGoal,
    required int streakCount,
    required String recentActivity,
  }) async {
    try {
      final String prompt = '''
Create a personalized motivational message for a user with:
- Goal: "$userGoal"
- Current streak: $streakCount days
- Recent activity: "$recentActivity"

Make it encouraging, specific to their progress, and under 100 words.
''';

      return await sendChatMessage(
        message: prompt,
        persona: AIPersona.friend,
      );
    } catch (e) {
      return 'Keep up the great work! You\'re making excellent progress towards your goals. 🌟';
    }
  }

  // Process slash commands
  Future<String> processSlashCommand({
    required String command,
    required String parameters,
    String? workspaceContext,
  }) async {
    try {
      switch (command.toLowerCase()) {
        case '/task':
          return await _createTaskFromCommand(parameters, workspaceContext);
        case '/note':
          return await _createNoteFromCommand(parameters, workspaceContext);
        case '/focus':
          return await _generateFocusSession(parameters);
        default:
          return 'Unknown command. Available commands: /task, /note, /focus';
      }
    } catch (e) {
      return 'Error processing command: $e';
    }
  }

  // Decision support
  Future<Map<String, dynamic>> provideDecisionSupport({
    required String decision,
    required List<String> options,
    String? context,
  }) async {
    try {
      final String prompt = '''
Help analyze this decision: "$decision"
Options: ${options.join(', ')}
${context != null ? 'Context: $context' : ''}

Provide analysis in JSON format with:
- "recommendation": "recommended option"
- "prosAndCons": {"option1": {"pros": [...], "cons": [...]}, ...}
- "considerations": ["factor1", "factor2", ...]
- "confidence": "high/medium/low"
''';

      final response = await sendChatMessage(
        message: prompt,
        persona: AIPersona.strategist,
      );

      return jsonDecode(response);
    } catch (e) {
      return {
        'recommendation': options.first,
        'prosAndCons': {},
        'considerations': ['Consider your priorities and constraints'],
        'confidence': 'low',
      };
    }
  }

  // Private helper methods
  String _getSystemPrompt(AIPersona persona) {
    switch (persona) {
      case AIPersona.mentor:
        return '''You are a wise and supportive mentor. Provide thoughtful guidance, 
ask insightful questions, and help users reflect on their goals and progress. 
Be encouraging but honest, and focus on personal growth and learning.''';
      
      case AIPersona.friend:
        return '''You are a supportive and enthusiastic friend. Be warm, encouraging, 
and relatable. Use casual language, show genuine interest in the user's life, 
and provide emotional support while celebrating their achievements.''';
      
      case AIPersona.strategist:
        return '''You are a strategic advisor focused on productivity and goal achievement. 
Provide clear, actionable advice, break down complex problems into manageable steps, 
and help users optimize their workflows and decision-making processes.''';
    }
  }

  Future<String> _createTaskFromCommand(String parameters, String? context) async {
    final String prompt = '''
Create a task based on: "$parameters"
${context != null ? 'Workspace context: $context' : ''}

Format as: "Task created: [task title] - [brief description]"
''';

    return await sendChatMessage(
      message: prompt,
      persona: AIPersona.strategist,
    );
  }

  Future<String> _createNoteFromCommand(String parameters, String? context) async {
    final String prompt = '''
Create a note based on: "$parameters"
${context != null ? 'Workspace context: $context' : ''}

Format as: "Note created: [note title] - [brief summary]"
''';

    return await sendChatMessage(
      message: prompt,
      persona: AIPersona.mentor,
    );
  }

  Future<String> _generateFocusSession(String parameters) async {
    final String prompt = '''
Create a focus session plan for: "$parameters"

Suggest a structured approach with time blocks and specific activities.
Format as a brief, actionable plan.
''';

    return await sendChatMessage(
      message: prompt,
      persona: AIPersona.strategist,
    );
  }
}
