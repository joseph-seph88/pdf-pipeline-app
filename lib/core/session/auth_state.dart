import 'package:equatable/equatable.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, tokenExpired }

class AuthState extends Equatable {
  const AuthState({this.status = AuthStatus.unknown});

  final AuthStatus status;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({AuthStatus? status}) =>
      AuthState(status: status ?? this.status);

  @override
  List<Object?> get props => [status];
}
