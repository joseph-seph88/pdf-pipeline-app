abstract class AppMessage {
  static const unknown = '알 수 없는 오류가 발생했습니다.\n잠시 후 다시 시도해주세요';
  static const timeout = '요청 시간이 초과되었습니다.\n네트워크 상태를 확인하거나 잠시 후 다시 시도해주세요';
  static const connection = '네트워크 연결을 확인해주세요';
  static const cancel = '요청이 취소되었습니다';
  static const badCertificate = '보안 인증서가 유효하지 않습니다.\n네트워크 보안 설정을 확인해주세요.';
  static const badResponse = '요청을 처리할 수 없습니다.\n잠시 후 다시 시도해주세요';
  static const notFound = '요청하신 기능을 찾을 수 없습니다.\n잠시 후 다시 시도해주세요';
  static const dataParse = '데이터를 변환 시킬 수 없습니다.\n잠시 후 다시 시도해주세요';
  static const serverError = '서버 오류가 발생했습니다.\n잠시 후 다시 시도해주세요';
}
