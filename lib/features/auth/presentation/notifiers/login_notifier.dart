import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_pipeline_app/core/constants/app_message.dart';
import 'package:pdf_pipeline_app/core/constants/server_status_type.dart';
import 'package:pdf_pipeline_app/core/di/core_provider.dart';
import 'package:pdf_pipeline_app/features/auth/providers/auth_providers.dart';
import '../states/login_state.dart';

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: LoginStatus.loading);

    final result = await ref
        .read(authRepositoryProvider)
        .login(email: email, password: password);

    await result.fold(
      (failure) async => state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: failure.message,
      ),
      (response) async {
        if (response.statusType != ServerStatusType.success.value ||
            response.data == null) {
          state = state.copyWith(
            status: LoginStatus.failure,
            errorMessage:
                ServerStatusType.fromValue(response.statusType)?.message ??
                    AppMessage.unknown,
          );
          return;
        }

        await ref.read(tokenStorageProvider).saveAccessToken(response.data!);
        ref.read(authStateProvider.notifier).setAuthenticated();
        state = state.copyWith(status: LoginStatus.success);
      },
    );
  }

  void reset() => state = const LoginState();
}
