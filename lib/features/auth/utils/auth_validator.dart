abstract class AuthValidator {
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return '이메일을 입력해주세요';
    final regex = RegExp(r'^[\w.-]+@[\w.-]+\.\w+$');
    if (!regex.hasMatch(value.trim())) return '올바른 이메일 형식을 입력해주세요';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return '비밀번호를 입력해주세요';
    if (value.length < 8) return '비밀번호는 8자 이상이어야 합니다';
    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) return '영문자를 포함해야 합니다';
    if (!RegExp(r'[0-9]').hasMatch(value)) return '숫자를 포함해야 합니다';
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) return '특수문자를 포함해야 합니다';
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return '이름을 입력해주세요';
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return '비밀번호를 다시 입력해주세요';
    if (value != password) return '비밀번호가 일치하지 않습니다';
    return null;
  }
}
