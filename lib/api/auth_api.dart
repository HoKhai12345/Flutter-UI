import 'api_client.dart';

class AuthApi {
  AuthApi(this.client);

  final ApiClient client;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final data = await client.post('/auth/login', {
      'username': username,
      'password': password,
      'expiresInMins': 30,
    });

    final token = data is Map ? data['accessToken'] : null;
    if (token is! String || token.isEmpty) {
      throw ApiException('Không nhận được token');
    }

    client.token = token;
  }
}

final authApi = AuthApi(apiClient);
