class MockSeries {
  final String title;
  final String icon;
  final List<MockCategory> categories;

  MockSeries({
    required this.title,
    required this.icon,
    required this.categories,
  });
}

class MockCategory {
  final String title;
  final String icon;
  final String subtitle;
  final List<MockTest> tests;

  MockCategory({
    required this.title,
    required this.icon,
    required this.subtitle,
    required this.tests,
  });
}

class MockTest {
  final String title;
  final String markingScheme;
  final int totalMarks;
  final String duration;
  final int questionCount;
  final String lastAttemptedDate;
  final int attemptCount;
  final bool isNew;
  final bool isLocked;

  MockTest({
    required this.title,
    required this.markingScheme,
    required this.totalMarks,
    required this.duration,
    required this.questionCount,
    required this.lastAttemptedDate,
    required this.attemptCount,
    this.isNew = true,
    this.isLocked = false,
  });
}

class MockPerformance {
  final String paperName;
  final String attemptNumber;
  final String questionsAttempt;
  final int totalMarks;
  final String markingScheme;
  final String timeTaken;
  final String startTime;
  final String endTime;
  final int rank;
  final double correctPercentage;
  final double incorrectPercentage;
  final double unansweredPercentage;
  final List<LeaderboardEntry> leaderboard;

  MockPerformance({
    required this.paperName,
    required this.attemptNumber,
    required this.questionsAttempt,
    required this.totalMarks,
    required this.markingScheme,
    required this.timeTaken,
    required this.startTime,
    required this.endTime,
    required this.rank,
    required this.correctPercentage,
    required this.incorrectPercentage,
    required this.unansweredPercentage,
    required this.leaderboard,
  });
}

class LeaderboardEntry {
  final String rank;
  final String name;
  final String score;
  final bool isUser;

  LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.score,
    this.isUser = false,
  });
}
