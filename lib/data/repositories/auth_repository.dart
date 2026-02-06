import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../services/api_service.dart';

class AuthRepository extends BaseApiService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> login(String username, String password) async {
    try {
      final response = await post(
        ApiEndpoints.login,
        data: {'username': username, 'password': password},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        final token = response.data['token'];
        if (token != null) {
          await _storage.write(key: 'token', value: token);
        }
      } else {
        throw Exception('Login Failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid username or password');
      }
      // Parse error message from response data if available
      String errorMessage = 'Network Error';
      if (e.response?.data != null) {
        if (e.response!.data is String) {
          errorMessage = e.response!.data;
        } else if (e.response!.data is Map) {
          errorMessage =
              e.response!.data['message'] ?? e.response!.data.toString();
        }
      }
      throw Exception(errorMessage);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(String username, String email, String password) async {
    try {
      // FakeStoreAPI user creation payload
      final data = {
        'email': email,
        'username': username,
        'password': password,
        'name': {
          'firstname': username,
          'lastname': '',
        }, // Placeholder for name structure
        'address': {
          'city': 'Unknown',
          'street': 'Unknown',
          'number': 0,
          'zipcode': '00000',
          'geolocation': {'lat': '0', 'long': '0'},
        },
        'phone': '000000000',
      };

      final response = await post(
        ApiEndpoints.users,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Registration successful
        // Note: FakeStoreAPI usually returns the new user object, but doesn't automatically log in.
        // We might want to auto-login here or just return success.
        // For simplicity, we'll return void (success) and let the UI/Cubit handle navigation.
        return;
      } else {
        throw Exception('Registration Failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? 'Network Error');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<bool> isLoggedIn() async {
    String? token = await getToken();
    return token != null;
  }
}
