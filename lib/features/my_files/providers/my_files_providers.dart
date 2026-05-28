import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_pipeline_app/core/di/core_provider.dart';
import '../data/repositories_impl/my_files_repository_impl.dart';
import '../data/repositories_impl/user_repository_impl.dart';
import '../domain/repositories/my_files_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../presentation/notifiers/my_files_notifier.dart';
import '../presentation/notifiers/user_notifier.dart';
import '../presentation/states/my_files_state.dart';
import '../presentation/states/user_state.dart';

final myFilesRepositoryProvider = Provider<MyFilesRepository>(
  (ref) => MyFilesRepositoryImpl(ref.read(apiClientProvider)),
);

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepositoryImpl(ref.read(apiClientProvider)),
);

final myFilesProvider = NotifierProvider<MyFilesNotifier, MyFilesState>(
  MyFilesNotifier.new,
);

final userProvider = NotifierProvider<UserNotifier, UserState>(
  UserNotifier.new,
);
