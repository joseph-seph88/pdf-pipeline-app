import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_pipeline_app/core/di/core_provider.dart';
import '../data/repositories_impl/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../presentation/notifiers/login_notifier.dart';
import '../presentation/notifiers/sign_up_notifier.dart';
import '../presentation/states/login_state.dart';
import '../presentation/states/sign_up_state.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.read(apiClientProvider)),
);

final loginProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);

final signUpProvider = NotifierProvider<SignUpNotifier, SignUpState>(
  SignUpNotifier.new,
);
