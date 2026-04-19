enum ServerStatusType {
  success('SUCCESS', null),
  domainError('DOMAIN_ERROR', '요청을 처리할 수 없습니다.\n잠시 후 다시 시도해주세요'),
  notFound('NOT_FOUND', '요청하신 항목을 찾을 수 없습니다'),
  alreadyExists('ALREADY_EXISTS', '이미 존재하는 항목입니다'),
  unauthorized('UNAUTHORIZED', '권한이 없습니다'),
  validationError('VALIDATION_ERROR', '입력값이 올바르지 않습니다'),
  httpError('HTTP_ERROR', '통신 중 오류가 발생했습니다.\n잠시 후 다시 시도해주세요'),
  internalServerError(
      'INTERNAL_SERVER_ERROR', '서버 오류가 발생했습니다.\n잠시 후 다시 시도해주세요'),
  authRequired('AUTH_REQUIRED', '로그인이 필요합니다'),
  invalidToken('INVALID_TOKEN', '인증 정보가 유효하지 않습니다.\n다시 로그인해주세요');

  const ServerStatusType(this.value, this.message);
  final String value;
  final String? message;

  static ServerStatusType? fromValue(String value) {
    for (final type in values) {
      if (type.value == value) return type;
    }
    return null;
  }
}
