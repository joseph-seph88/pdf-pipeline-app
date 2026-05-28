import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:pdf_pipeline_app/core/entities/user.dart';

enum UserStatus { loading, success, failure }

class UserState extends Equatable {
  const UserState({
    this.status = UserStatus.loading,
    this.user,
    this.errorMessage,
    this.isUpdating = false,
    this.updateError,
    this.pendingImageBytes,
    this.pendingImageFileName,
  });

  final UserStatus status;
  final User? user;
  final String? errorMessage;
  final bool isUpdating;
  final String? updateError;
  final Uint8List? pendingImageBytes;
  final String? pendingImageFileName;

  UserState copyWith({
    UserStatus? status,
    User? user,
    String? errorMessage,
    bool? isUpdating,
    String? updateError,
    Uint8List? pendingImageBytes,
    String? pendingImageFileName,
  }) {
    return UserState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      isUpdating: isUpdating ?? this.isUpdating,
      updateError: updateError ?? this.updateError,
      pendingImageBytes: pendingImageBytes ?? this.pendingImageBytes,
      pendingImageFileName: pendingImageFileName ?? this.pendingImageFileName,
    );
  }

  UserState withUpdateCleared() => UserState(
        status: status,
        user: user,
        errorMessage: errorMessage,
      );

  UserState clearPendingImage() => UserState(
        status: status,
        user: user,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [
        status,
        user,
        errorMessage,
        isUpdating,
        updateError,
        pendingImageBytes,
        pendingImageFileName,
      ];
}
