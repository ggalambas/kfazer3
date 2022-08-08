import 'package:image_picker/image_picker.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sms_code_controller.dart';
import 'package:kfazer3/src/features/notifications/data/notifications_repository.dart';
import 'package:kfazer3/src/features/workspace/data/workspace_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

class MockWorkspaceRepository extends Mock implements WorkspaceRepository {}

class MockSmsCodeController extends Mock implements SmsCodeController {}

class MockXFile extends Mock implements XFile {}
