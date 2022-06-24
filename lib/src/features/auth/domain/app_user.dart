/// Simple class representing the user id, name, and phone number.
class AppUser {
  final String id;
  final String name;
  final String phoneNumber;
  final String? photoUrl;

  const AppUser({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.photoUrl,
  });
}
