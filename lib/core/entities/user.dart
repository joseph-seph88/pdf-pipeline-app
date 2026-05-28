import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.nickname,
    this.profileImage,
  });

  final String id;
  final String email;
  final String name;
  final String? nickname;
  final String? profileImage;

  String get displayName => nickname?.isNotEmpty == true ? nickname! : name;
  String get initial => name.isNotEmpty ? name[0].toUpperCase() : '?';

  @override
  List<Object?> get props => [id, email, name, nickname, profileImage];
}
