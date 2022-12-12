import 'package:kfazer3/src/constants/test_groups.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';

/// Test motivational messages to be used until a data source is implemented
Map<GroupId, List<String>> get kTestQuotes => {
      for (final group in kTestGroups) group.id: _kTestQuotes,
    };

const _kTestQuotes = [
  "Great job! You knocked it out of the park.",
  "Well done! Your hard work paid off.",
  "Good work. Your efforts are appreciated.",
  "Congratulations on a job well done.",
  "Your dedication is inspiring. Keep up the good work.",
  "Thank you for your hard work and determination.",
  "Your hard work paid off. Keep pushing yourself.",
  "You exceeded expectations. Keep up the fantastic work.",
  "Your performance is a testament to your talent and dedication.",
  "You have set a high bar. Keep striving for excellence.",
];
