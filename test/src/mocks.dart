import 'package:image_picker/image_picker.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/data/country_repository.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sms_code_controller.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/notifications/data/notifications_repository.dart';
import 'package:kfazer3/src/features/workspace/data/workspace_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockCountryRepository extends Mock implements CountryRepository {}

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

//TODO remove this mock
class MockWorkspaceRepository extends Mock implements WorkspaceRepository {}

class MockGroupsRepository extends Mock implements GroupsRepository {}

class MockSmsCodeController extends Mock implements SmsCodeController {}

class MockXFile extends Mock implements XFile {}
