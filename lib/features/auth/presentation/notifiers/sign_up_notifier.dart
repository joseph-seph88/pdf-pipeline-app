import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_pipeline_app/core/constants/app_message.dart';
import 'package:pdf_pipeline_app/core/constants/server_status_type.dart';
import 'package:pdf_pipeline_app/features/auth/providers/auth_providers.dart';
import '../states/sign_up_state.dart';

class SignUpNotifier extends Notifier<SignUpState> {
  @override
  SignUpState build() => const SignUpState();

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required bool termsAgreed,
    required bool privacyAgreed,
  }) async {
    state = state.copyWith(status: SignUpStatus.loading);

    final result = await ref.read(authRepositoryProvider).signUp(
          email: email,
          password: password,
          name: name,
          termsAgreed: termsAgreed,
          privacyAgreed: privacyAgreed,
        );

    result.fold(
      (failure) => state = state.copyWith(
        status: SignUpStatus.failure,
        errorMessage: failure.message,
      ),
      (res) {
        if (res.statusType != ServerStatusType.success.value) {
          state = state.copyWith(
            status: SignUpStatus.failure,
            errorMessage: ServerStatusType.fromValue(res.statusType)?.message ??
                AppMessage.unknown,
          );
          return;
        }
        state = state.copyWith(status: SignUpStatus.success);
      },
    );
  }

  void reset() => state = const SignUpState();
}
