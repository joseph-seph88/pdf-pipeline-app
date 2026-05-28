import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_pipeline_app/core/constants/app_message.dart';
import 'package:pdf_pipeline_app/core/constants/server_status_type.dart';
import 'package:pdf_pipeline_app/features/my_files/providers/my_files_providers.dart';
import '../states/user_state.dart';

class UserNotifier extends Notifier<UserState> {
  @override
  UserState build() {
    Future.microtask(loadUser);
    return const UserState();
  }

  Future<void> loadUser() async {
    state = state.copyWith(status: UserStatus.loading);

    final result = await ref.read(userRepositoryProvider).getMe();

    result.fold(
      (failure) => state = state.copyWith(
        status: UserStatus.failure,
        errorMessage: failure.message,
      ),
      (response) {
        if (response.statusType != ServerStatusType.success.value ||
            response.data == null) {
          state = state.copyWith(
            status: UserStatus.failure,
            errorMessage:
                ServerStatusType.fromValue(response.statusType)?.message ??
                    AppMessage.unknown,
          );
          return;
        }
        state = state.copyWith(
          status: UserStatus.success,
          user: response.data,
        );
      },
    );
  }

  void setPendingImage({required Uint8List bytes, required String fileName}) {
    state = state.copyWith(
      pendingImageBytes: bytes,
      pendingImageFileName: fileName,
    );
  }

  Future<void> saveProfile(String nickname) async {
    if (state.user == null) return;

    state = state.copyWith(isUpdating: true);

    final result = await ref.read(userRepositoryProvider).updateUser(
          nickname: nickname.trim().isEmpty ? null : nickname.trim(),
          imageBytes: state.pendingImageBytes,
          imageFileName: state.pendingImageFileName,
        );

    result.fold(
      (failure) => state = state.copyWith(
        isUpdating: false,
        updateError: failure.message,
      ),
      (response) {
        if (response.statusType != ServerStatusType.success.value ||
            response.data == null) {
          state = state.copyWith(
            isUpdating: false,
            updateError:
                ServerStatusType.fromValue(response.statusType)?.message ??
                    AppMessage.unknown,
          );
          return;
        }
        state = UserState(
          status: UserStatus.success,
          user: response.data,
        );
      },
    );
  }

  void clearUpdateError() => state = state.withUpdateCleared();
}
