import 'preferences.dart';
import 'workspace.dart';

/// Helper extension used to mark a workspace as read
extension UpdatableWorkspace on Workspace {
  Workspace updateTitle(String title) => Workspace(
        id: id,
        title: title,
        description: description,
        photoUrl: photoUrl,
        motivationalMessages: motivationalMessages,
        plan: plan,
      );
  Workspace updateDescription(String description) => Workspace(
        id: id,
        title: title,
        description: description,
        photoUrl: photoUrl,
        motivationalMessages: motivationalMessages,
        plan: plan,
      );
  Workspace updatePlan(WorkspacePlan plan) => Workspace(
        id: id,
        title: title,
        description: description,
        photoUrl: photoUrl,
        motivationalMessages: motivationalMessages,
        plan: plan,
      );
}
