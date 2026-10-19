class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  factory UserModel.demo() {
    return const UserModel(
      id: 'usr_yang_mulia_01',
      name: 'Yang Mulia Penguasa Cashifly',
      email: 'yangmulia@cashifly.app',
      avatarUrl: null,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? map['email'] as String? ?? 'Pengguna',
      email: map['email'] as String? ?? '',
      avatarUrl: map['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
    };
  }
}

