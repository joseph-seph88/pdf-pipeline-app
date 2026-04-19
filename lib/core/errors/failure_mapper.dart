import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pdf_pipeline_app/core/constants/app_message.dart';
import 'package:pdf_pipeline_app/core/constants/server_status_type.dart';
import 'package:pdf_pipeline_app/core/logger/app_logger.dart';
import 'failure.dart';

Either<Failure, T> handleError<T>(Object e, StackTrace s) {
  logger.e('[handleError] Exception :: $e');

  if (e is DioException) {
    return Left(_handleDioException(e));
  }
  return Left(UnknownFailure(e.toString()));
}

Either<Failure, T> handleResponse<T>(
  Response res,
  T Function(dynamic) fromData,
) {
  try {
    return Right(fromData(res.data));
  } catch (e, s) {
    logger.e('[handleResponse] 데이터 파싱 에러 :: $e\n$s');
    return const Left(UnknownFailure(AppMessage.dataParse));
  }
}

Failure _handleDioException(DioException e) {
  final statusCode = e.response?.statusCode;

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const NetworkFailure(AppMessage.timeout);

    case DioExceptionType.connectionError:
      return const NetworkFailure(AppMessage.connection);

    case DioExceptionType.cancel:
      return const UnknownFailure(AppMessage.cancel);

    case DioExceptionType.badCertificate:
      return const ServerFailure(AppMessage.badCertificate);

    case DioExceptionType.unknown:
      return UnknownFailure(e.message ?? AppMessage.unknown);

    case DioExceptionType.badResponse:
      final rawData = e.response?.data;
      logger.e(
        '[handleError] badResponse :: statusCode=$statusCode, data=$rawData',
      );
      final extracted = _extractErrorMessage(rawData);

      if (statusCode == 401) {
        return UnauthorizedFailure(extracted ?? AppMessage.badResponse);
      }
      if (statusCode == 404) {
        return ServerFailure(AppMessage.notFound, statusCode: statusCode);
      }
      if (statusCode != null && statusCode >= 500) {
        return ServerFailure(
          extracted ?? AppMessage.serverError,
          statusCode: statusCode,
        );
      }
      return ServerFailure(
        extracted ?? AppMessage.badResponse,
        statusCode: statusCode,
      );
  }
}

String? _extractErrorMessage(dynamic rawData) {
  if (rawData is Map) {
    final statusType = rawData['status_type'];
    if (statusType is String && statusType.isNotEmpty) {
      final mapped = ServerStatusType.fromValue(statusType)?.message;
      if (mapped != null) return mapped;
    }

    final detail = rawData['detail'];
    if (detail is String) return detail;
    if (detail is List && detail.isNotEmpty) {
      final first = detail.first;
      if (first is Map && first.containsKey('msg')) {
        return first['msg']?.toString();
      }
    }
  }

  if (rawData is String && rawData.isNotEmpty) return rawData;

  return null;
}
