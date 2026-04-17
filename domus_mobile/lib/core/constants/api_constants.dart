class ApiConstants {
  static const String baseUrl = 'https://doums-m-backend-production.up.railway.app';

  static const String apiPrefix = '/api/v1';

  // Auth Endpoints
  static const String sendOtp = '$apiPrefix/auth/send-otp';
  static const String verifyOtp = '$apiPrefix/auth/verify-otp';
  static const String register = '$apiPrefix/auth/register';
  static const String login = '$apiPrefix/auth/login';
  static const String signup = '$apiPrefix/auth/signup';
  static const String forgotPassword = '$apiPrefix/auth/forgot-password';
  static const String googleLogin = '$apiPrefix/auth/google-login';

  // Course Endpoints
  static const String courses = '$apiPrefix/courses';
  static const String courseDetails = '$apiPrefix/courses/'; // + id

  // Mock Test Endpoints
  static const String mockTests = '$apiPrefix/tests';
  static const String testDetails = '$apiPrefix/tests/'; // + id
  static const String submitTest = '$apiPrefix/submit';

  // MCQ Endpoints
  static const String mcqOfDay = '$apiPrefix/feed/mcq-of-the-day';
  static const String practiceMcq = '$apiPrefix/mcq/practice';

  // User Endpoints
  static const String profile = '$apiPrefix/profile/me';
  static const String updateProfile = '$apiPrefix/profile/';
  static const String uploadPhoto = '$apiPrefix/profile/upload-photo';
  static const String testHistory = '$apiPrefix/profile/test-history';
  // Home Endpoints
  static const String featuredBatches = '$apiPrefix/home/featured-batches';
}
