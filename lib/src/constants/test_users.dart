import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';

import 'test_groups.dart';

/// Test users to be used until a data source is implemented
Map<AppUser, List<GroupId>> get kTestUsers => Map.fromIterable(
      _kTestUsers,
      value: (user) => kTestGroupIds.map((i) => i.toString()).toList(),
    );

final _kTestUsers = List.generate(
  20,
  (i) => AppUser(
    id: i.toString(),
    name: 'User $i',
    phoneNumber: PhoneNumber('+351', (900000000 + i).toString()),
  ),
);
