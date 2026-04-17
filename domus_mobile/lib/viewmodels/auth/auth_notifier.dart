import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domus_mobile/core/providers.dart';
import 'package:domus_mobile/models/user.dart';
import 'package:domus_mobile/services/auth_service.dart';

// We'll define the state for Auth
class AuthState {
  final User? user;
  final bool isLoading;
  final bool isInitializing; // Added to distinguish initial startup
  final String? error;
  final bool isNewUser;
  final String? tempMobile;
  final String? latestOtp;

  AuthState({
    this.user,
    this.isLoading = false,
    this.isInitializing = false,
    this.error,
    this.isNewUser = false,
    this.tempMobile,
    this.latestOtp,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    bool? isInitializing,
    String? error,
    bool? isNewUser,
    String? tempMobile,
    String? latestOtp,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isInitializing: isInitializing ?? this.isInitializing,
      error: error,
      isNewUser: isNewUser ?? this.isNewUser,
      tempMobile: tempMobile ?? this.tempMobile,
      latestOtp: latestOtp ?? this.latestOtp,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState(isInitializing: true)) {
    initAuth();
  }

  Future<void> initAuth() async {
    // We already start with isInitializing: true in constructor
    try {
      final user = await _authService.getProfile();
      if (user != null) {
        state = state.copyWith(user: user, isInitializing: false);
      } else {
        state = state.copyWith(isInitializing: false);
      }
    } catch (e) {
      state = state.copyWith(isInitializing: false);
    }
  }

  Future<void> sendOTP(String mobile) async {
    state = state.copyWith(isLoading: true, error: null, tempMobile: mobile);
    try {
      final otp = await _authService.sendOTP(mobile);
      state = state.copyWith(isLoading: false, latestOtp: otp);
    } on DioException catch (e) {
      final data = e.response?.data;
      String? message;
      if (data is Map) {
        message = data['detail']?.toString();
      }
      message ??= e.message ?? 'Failed to send OTP';
      state = state.copyWith(error: message, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> verifyOTP(String otp) async {
    if (state.tempMobile == null) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _authService.verifyOTP(state.tempMobile!, otp);
      if (data != null) {
        final isNew = data['is_new_user'] ?? false;
        final user = data['user'] != null ? User.fromJson(data['user']) : null;
        state = state.copyWith(
          user: user,
          isNewUser: isNew,
          isLoading: false,
        );
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String? message;
      if (data is Map) {
        message = data['detail']?.toString();
      }
      message ??= e.message ?? 'Verification failed';
      state = state.copyWith(error: message, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    String? email,
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
    if (state.tempMobile == null) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authService.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        mobile: state.tempMobile!,
        gender: gender,
        dob: dob,
        country: country,
        domicileState: domicileState,
        district: district,
        category: category,
        designation: designation,
        batch: batch,
        ugCollegeState: ugCollegeState,
        ugCollegeName: ugCollegeName,
      );
      state = state.copyWith(user: user, isLoading: false, isNewUser: false);
    } on DioException catch (e) {
      final data = e.response?.data;
      String? message;
      if (data is Map) {
        message = data['detail']?.toString();
      }
      message ??= e.message ?? 'Registration failed';
      state = state.copyWith(error: message, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authService.updateProfile(data);
      if (user != null) {
        state = state.copyWith(user: user, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String? message;
      if (data is Map) {
        message = data['detail']?.toString();
      }
      message ??= e.message ?? 'Update failed';
      state = state.copyWith(error: message, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> uploadProfilePhoto(List<int> bytes, String fileName) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authService.uploadProfilePhoto(bytes, fileName);
      if (user != null) {
        state = state.copyWith(user: user, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String? message;
      if (data is Map) {
        message = data['detail']?.toString();
      }
      message ??= e.message ?? 'Upload failed';
      state = state.copyWith(error: message, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = AuthState();
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final authStorage = ref.watch(authStorageProvider);
  return AuthService(dioClient, authStorage);
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});
