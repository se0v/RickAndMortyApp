class AppUser {
  final String uid;
  final String? email;

  AppUser({required this.uid, this.email});

  factory AppUser.fromFirebase(dynamic user) {
    return AppUser(
      uid: user.uid,
      email: user.email,
    );
  }
}