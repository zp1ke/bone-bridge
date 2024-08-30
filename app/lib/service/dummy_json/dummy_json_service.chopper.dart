// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dummy_json_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$_ChopperService extends _ChopperService {
  _$_ChopperService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = _ChopperService;

  @override
  Future<Response<dynamic>> login(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/auth/login');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> fetchTodos(
    int limit,
    int skip,
  ) {
    final Uri $url = Uri.parse('/todos');
    final Map<String, dynamic> $params = <String, dynamic>{
      'limit': limit,
      'skip': skip,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
