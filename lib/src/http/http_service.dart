import 'package:dio/dio.dart';

class HttpService {
  final Dio _dio;

  HttpService({Dio? dioClient})
      : _dio = dioClient ??
            Dio(
              BaseOptions(
                baseUrl: 'https://viacep.com.br/ws',
                connectTimeout: 10000, // 10 segundos em ms
                receiveTimeout: 10000,
                responseType: ResponseType.json,
              ),
            ) {
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioError catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioError catch (e) {
      throw Exception(_handleError(e));
    }
  }

  String _handleError(DioError e) {
    switch (e.type) {
      case DioErrorType.connectTimeout:
        return "Tempo de conexão excedido";
      case DioErrorType.receiveTimeout:
        return "Tempo de resposta excedido";
      case DioErrorType.response:
        return "Erro do servidor: ${e.response?.statusCode}";
      case DioErrorType.cancel:
        return "Requisição cancelada";
      case DioErrorType.other:
      default:
        return "Erro inesperado: ${e.message}";
    }
  }
}
