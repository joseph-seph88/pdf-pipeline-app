import 'package:equatable/equatable.dart';

enum SignUpStatus { idle, loading, success, failure }

class SignUpState extends Equatable {
  const SignUpState({
    this.status = SignUpStatus.idle,
    this.errorMessage,
  });

  final SignUpStatus status;
  final String? errorMessage;

  bool get isLoading => status == SignUpStatus.loading;

  SignUpState copyWith({
    SignUpStatus? status,
    String? errorMessage,
  }) {
    return SignUpState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
