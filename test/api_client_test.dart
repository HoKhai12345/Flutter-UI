import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shop_app/api/api_client.dart';
import 'package:shop_app/api/auth_api.dart';

void main() {
  test('login stores the access token from the response', () async {
    final httpClient = MockClient((request) async {
      expect(request.method, 'POST');
      expect(request.url.path, '/auth/login');
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      expect(body['username'], 'emilys');
      return http.Response(
        jsonEncode({'accessToken': 'token-1'}),
        200,
      );
    });

    final client = ApiClient(client: httpClient, baseUrl: 'https://example.com');
    await AuthApi(client).login(username: 'emilys', password: 'emilyspass');

    expect(client.token, 'token-1');
  });

  test('login throws the message returned by the server', () async {
    final httpClient = MockClient((request) async {
      return http.Response(
        jsonEncode({'message': 'Invalid credentials'}),
        400,
      );
    });

    final auth = AuthApi(
      ApiClient(client: httpClient, baseUrl: 'https://example.com'),
    );

    expect(
      () => auth.login(username: 'emilys', password: 'wrong-pass'),
      throwsA(
        isA<ApiException>().having(
          (error) => error.message,
          'message',
          'Invalid credentials',
        ),
      ),
    );
  });
}
