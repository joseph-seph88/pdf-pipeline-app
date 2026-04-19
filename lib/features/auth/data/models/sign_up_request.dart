class SignUpRequest {
  const SignUpRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.termsAgreed,
    required this.privacyAgreed,
  });

  final String email;
  final String password;
  final String name;
  final bool termsAgreed;
  final bool privacyAgreed;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'name': name,
        'terms_agreed': termsAgreed,
        'privacy_agreed': privacyAgreed,
      };
}
