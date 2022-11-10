import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/groups/application/groups_service.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';

import '../../../mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late MockGroupsRepository groupsRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    groupsRepository = MockGroupsRepository();
  });

  GroupsService makeGroupsService() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        groupsRepositoryProvider.overrideWithValue(groupsRepository),
      ],
    );
    addTearDown(container.dispose);
    return container.read(groupsServiceProvider);
  }

  test('watchGroupList', () async {
    //
  });
}
