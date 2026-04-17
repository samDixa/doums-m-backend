class QuestionModel {
  final int id;
  final String questionText;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String? correctOption;
  final String? description;
  final String? subject;
  final String? topic;
  final Map<String, double>? optionStats;
  final int? selectedOptionIndex;

  const QuestionModel({
    required this.id,
    required this.questionText,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    this.correctOption,
    this.description,
    this.subject,
    this.topic,
    this.optionStats,
    this.selectedOptionIndex,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    // Determine selectedOptionIndex from 'selected_option' string (A, B, C, D)
    int? selectedIndex;
    final selectedOption = json['selected_option'] as String?;
    if (selectedOption != null) {
      if (selectedOption.toUpperCase() == 'A') selectedIndex = 0;
      else if (selectedOption.toUpperCase() == 'B') selectedIndex = 1;
      else if (selectedOption.toUpperCase() == 'C') selectedIndex = 2;
      else if (selectedOption.toUpperCase() == 'D') selectedIndex = 3;
    }

    return QuestionModel(
      id: json['id'] ?? 0,
      questionText: json['question_text'] ?? '',
      optionA: json['option_a'] ?? '',
      optionB: json['option_b'] ?? '',
      optionC: json['option_c'] ?? '',
      optionD: json['option_d'] ?? '',
      correctOption: json['correct_option'],
      description: json['description'],
      subject: json['subject'],
      topic: json['topic'],
      optionStats: json['option_stats'] != null 
          ? Map<String, double>.from(json['option_stats'].map((k, v) => MapEntry(k, v.toDouble())))
          : null,
      selectedOptionIndex: selectedIndex,
    );
  }

  QuestionModel copyWith({
    int? id,
    String? questionText,
    String? optionA,
    String? optionB,
    String? optionC,
    String? optionD,
    String? correctOption,
    String? description,
    String? subject,
    String? topic,
    Map<String, double>? optionStats,
    int? selectedOptionIndex,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      questionText: questionText ?? this.questionText,
      optionA: optionA ?? this.optionA,
      optionB: optionB ?? this.optionB,
      optionC: optionC ?? this.optionC,
      optionD: optionD ?? this.optionD,
      correctOption: correctOption ?? this.correctOption,
      description: description ?? this.description,
      subject: subject ?? this.subject,
      topic: topic ?? this.topic,
      optionStats: optionStats ?? this.optionStats,
      selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_text': questionText,
      'option_a': optionA,
      'option_b': optionB,
      'option_c': optionC,
      'option_d': optionD,
      'correct_option': correctOption,
      'description': description,
      'subject': subject,
      'topic': topic,
      'option_stats': optionStats,
      'selected_option_index': selectedOptionIndex,
    };
  }
}
