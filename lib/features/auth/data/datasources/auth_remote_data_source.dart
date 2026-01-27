

// import 'package:autotech/core/error/exceptions.dart';
// import 'package:autotech/features/auth/data/models/user_model.dart';
// import 'package:dio/dio.dart';

// abstract interface class AuthRemoteDataSource {
//   get currentUserSession => null;

//   Future<UserModel> signUpWithEmailPassword({
//     required String name,
//     required String email,
//     required String password,
//   });

//   Future<UserModel> loginWithEmailPassword({
//     required String email,
//     required String password,
//   });

//   Future<UserModel?> getCurrentUserData();
// }

// class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
//   final Dio dio;

//   AuthRemoteDataSourceImpl(this.dio) {
//     // Optional: global config (base URL, timeouts, etc.)
//     dio.options
//       ..baseUrl = 'http://localhost:3000'
//       ..connectTimeout = const Duration(seconds: 10)
//       ..receiveTimeout = const Duration(seconds: 10)
//       ..headers['Content-Type'] = 'application/json';
//   }

//   @override
//   Future<UserModel> loginWithEmailPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final response = await dio.post(
//         '/api/auth/login', // ← adjust if your endpoint is different
//         data: {
//           'email': email,
//           'password': password,
//         },
//       );

//       if (response.statusCode != 200) {
//         throw ServerException('Login failed: ${response.statusMessage}');
//       }

//       final data = response.data as Map<String, dynamic>;

//       // Adjust based on your backend response shape
//       final userJson = data['user'] as Map<String, dynamic>? ?? data;
//       final token = data['token'] as String?;

//       final user = UserModel.fromJson(userJson);

//       // TODO: Store token separately (e.g., in secure storage or state management)
//       return user;
//     } on DioException catch (e) {
//       throw ServerException(
//         e.response?.data['message'] ?? e.message ?? 'Network error during login',
//       );
//     } catch (e) {
//       throw ServerException('Unexpected error: $e');
//     }
//   }

//   @override
//   Future<UserModel> signUpWithEmailPassword({
//     required String name,
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final response = await dio.post(
//         '/api/auth/register', // ← adjust endpoint if needed (e.g. /signup, /users)
//         data: {
//           'name': name,
//           'email': email,
//           'password': password,
//         },
//       );

//       if (response.statusCode != 201 && response.statusCode != 200) {
//         throw ServerException('Sign up failed: ${response.statusMessage}');
//       }

//       final data = response.data as Map<String, dynamic>;

//       final userJson = data['user'] as Map<String, dynamic>? ?? data;
//       final token = data['token'] as String?;

//       final user = UserModel.fromJson(userJson);

//       // TODO: Store token separately (e.g., in secure storage or state management)
//       return user;
//     } on DioException catch (e) {
//       throw ServerException(
//         e.response?.data['message'] ?? e.message ?? 'Network error during sign up',
//       );
//     } catch (e) {
//       throw ServerException('Unexpected error: $e');
//     }
//   }

//   @override
//   Future<UserModel?> getCurrentUserData() async {
//     try {
//       // You need the token from login/signup – in real app, get it from secure storage / cubit / provider
//       // For now, assume it's injected or stored in a better place (see next steps)
//       final token = 'YOUR_TOKEN_HERE'; // ← Replace with real token retrieval

//       if (token.isEmpty) return null;

//       dio.options.headers['Authorization'] = 'Bearer $token';

//       final response = await dio.get('/api/auth/me'); // ← adjust endpoint

//       if (response.statusCode != 200) {
//         throw ServerException('Failed to fetch user: ${response.statusMessage}');
//       }

//       final data = response.data as Map<String, dynamic>;
//       return UserModel.fromJson(data);
//     } on DioException catch (e) {
//       if (e.response?.statusCode == 401) {
//         // Token expired/invalid → handle logout or refresh in upper layer
//         return null;
//       }
//       throw ServerException(
//         e.response?.data['message'] ?? e.message ?? 'Network error fetching user',
//       );
//     } catch (e) {
//       throw ServerException('Unexpected error: $e');
//     }
//   }
  
//   @override
//   // TODO: implement currentUserSession
//   get currentUserSession => throw UnimplementedError();
// }













import 'package:autotech/features/auth/data/models/user_model.dart';
import '../../../../core/network/api_base_helper.dart';

class AuthRemoteDataSource {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<UserModel> login(String email, String password) async {
    final body = {'email': email, 'password': password};
    final response = await _helper.post('/auth/login', body, '');
    return UserModel.fromJson(response);
  }

  Future signUpWithEmailPassword({required String name, required String email, required String password}) async {}

  Future loginWithEmailPassword({required String email, required String password}) async {}

  // Add register, etc.
}