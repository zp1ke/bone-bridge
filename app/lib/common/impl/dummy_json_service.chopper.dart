// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dummy_json_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$_ChopperAuthService extends _ChopperAuthService {
  _$_ChopperAuthService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = _ChopperAuthService;

  @override
  Future<Response<Auth>> login(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/auth/login');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Auth, Auth>($request);
  }
}
