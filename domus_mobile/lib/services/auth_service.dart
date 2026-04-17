import 'package:dio/dio.dart';
import 'package:domus_mobile/api/dio_client.dart';
import 'package:domus_mobile/core/constants/api_constants.dart';
import 'package:domus_mobile/models/user.dart';
import 'package:domus_mobile/services/auth_storage_service.dart';

class AuthService {
  final DioClient _dioClient;
  final AuthStorageService _authStorage;

  AuthService(this._dioClient, this._authStorage);

  Future<String?> sendOTP(String mobile) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.sendOtp,
        data: {'mobile': mobile},
      );
      if (response.statusCode == 200) {
        return response.data['otp']?.toString();
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<Map<String, dynamic>?> verifyOTP(String mobile, String otp) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.verifyOtp,
        data: {
          'mobile': mobile,
          'otp': otp,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['access_token'] != null) {
          await _authStorage.saveToken(data['access_token']);
        }
        return data;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<User?> register({
    required String firstName,
    required String lastName,
    String? email,
    required String mobile,
    String? gender,
    String? dob,
    String? country,
    String? domicileState,
    String? district,
    String? category,
    String? designation,
    String? batch,
    String? ugCollegeState,
    String? ugCollegeName,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.register,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'mobile': mobile,
          'gender': gender,
          'dob': dob,
          'country': country,
          'state': domicileState,
          'district': district,
          'category': category,
          'designation': designation,
          'batch': batch,
          'ug_college_state': ugCollegeState,
          'ug_college_name': ugCollegeName,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['access_token'] != null) {
          await _authStorage.saveToken(data['access_token']);
        }
        return User.fromJson(data['user']);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<User?> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.dio.put(
        ApiConstants.updateProfile,
        data: data,
      );
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<User?> uploadProfilePhoto(List<int> bytes, String fileName) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes, filename: fileName),
      });

      final response = await _dioClient.dio.post(
        ApiConstants.uploadPhoto,
        data: formData,
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<User?> getProfile() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.profile);
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<void> logout() async {
    await _authStorage.clearAll();
  }
}
