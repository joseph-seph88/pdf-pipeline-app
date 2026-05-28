import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pdf_pipeline_app/core/constants/app_message.dart';
import 'package:pdf_pipeline_app/core/errors/failure.dart';
import 'package:pdf_pipeline_app/core/errors/failure_mapper.dart';
import 'package:pdf_pipeline_app/core/logger/app_logger.dart';
import 'api_response.dart';

class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;
  final _plainDio = Dio();

  Future<Either<Failure, ApiResponse<T>>> get<T>(
    String path,
    T Function(dynamic) fromData, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) =>
      _handleRequest(
        fromData,
        () => _dio.get(
          path,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        ),
      );

  Future<Either<Failure, ApiResponse<T>>> post<T>(
    String path,
    T Function(dynamic) fromData, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
      _handleRequest(
        fromData,
        () => _dio.post(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        ),
      );

  Future<Either<Failure, ApiResponse<T>>> put<T>(
    String path,
    T Function(dynamic) fromData, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
      _handleRequest(
        fromData,
        () => _dio.put(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        ),
      );

  Future<Either<Failure, ApiResponse<T>>> patch<T>(
    String path,
    T Function(dynamic) fromData, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
      _handleRequest(
        fromData,
        () => _dio.patch(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        ),
      );

  Future<Either<Failure, ApiResponse<T>>> delete<T>(
    String path,
    T Function(dynamic) fromData, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) =>
      _handleRequest(
        fromData,
        () => _dio.delete(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        ),
      );

  Future<Either<Failure, Uint8List>> downloadBytes(String url) async {
    try {
      final res = await _plainDio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return Right(Uint8List.fromList(res.data!));
    } on DioException catch (e, s) {
      return handleError(e, s);
    } catch (e, s) {
      return handleError(e, s);
    }
  }

  Future<Either<Failure, ApiResponse<T>>> _handleRequest<T>(
    T Function(dynamic) fromData,
    Future<Response> Function() call,
  ) async {
    try {
      final res = await call();
      return _parse<T>(res.data, fromData);
    } on DioException catch (e, s) {
      if (e.type == DioExceptionType.badResponse) {
        final statusCode = e.response?.statusCode ?? 0;
        final body = e.response?.data;
        if (statusCode == 413) {
          return const Left(ServerFailure('파일 크기가 서버 허용 한도를 초과합니다'));
        }
        if (statusCode >= 400 &&
            statusCode < 500 &&
            body is Map<String, dynamic> &&
            body['status_code'] is int &&
            body['status_type'] is String) {
          return _parse<T>(body, fromData);
        }
      }
      return handleError<ApiResponse<T>>(e, s);
    } catch (e, s) {
      return handleError<ApiResponse<T>>(e, s);
    }
  }

  Either<Failure, ApiResponse<T>> _parse<T>(
    dynamic data,
    T Function(dynamic) fromData,
  ) {
    try {
      return Right(
        ApiResponse<T>.fromJson(data as Map<String, dynamic>, fromData),
      );
    } catch (e, s) {
      logger.e('[ApiClient] 파싱 에러', error: e, stackTrace: s);
      return const Left(UnknownFailure(AppMessage.dataParse));
    }
  }
}
