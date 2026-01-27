class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? token;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.token,
  });
}

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      token: json['token']?.toString(),
    );
  }

  // This method converts model → entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      token: token,
    );
  }
}