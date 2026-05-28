import 'package:pdf_pipeline_app/core/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.nickname,
    super.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      nickname: json['nickname'] as String?,
      profileImage: json['profileImage'] as String?,
    );
  }
}
