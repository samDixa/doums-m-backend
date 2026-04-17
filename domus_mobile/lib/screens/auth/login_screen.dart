import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domus_mobile/viewmodels/auth/auth_notifier.dart';
import 'package:domus_mobile/screens/auth/profile_setup_screen.dart';
import 'package:domus_mobile/screens/main_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _mobileController = TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
  // bool _isOtpSent = false; // Removed to derive from state
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        final mobile = ref.read(authNotifierProvider).tempMobile;
        if (mobile != null && _mobileController.text.isEmpty) {
          _mobileController.text = mobile;
        }
      }
    });
  }

  @override
  void dispose() {
    _mobileController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _otpControllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authState = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
      }
      if (next.latestOtp != null && previous?.latestOtp != next.latestOtp) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Your Test OTP is: ${next.latestOtp}'),
            duration: const Duration(seconds: 10),
            backgroundColor: const Color(0xFF021B3A),
            action: SnackBarAction(
              label: 'FILL',
              textColor: Colors.white,
              onPressed: () {
                final otpChars = next.latestOtp!.split('');
                for (int i = 0; i < otpChars.length && i < 6; i++) {
                  _otpControllers[i].text = otpChars[i];
                }
              },
            ),
          ),
        );
      }

      // Manual navigation for immediate transition
      if (next.user != null && !next.isNewUser && (previous?.user == null || previous?.isNewUser == true)) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false,
        );
      } else if (next.isNewUser && previous?.isNewUser != true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
        );
      }
    });

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            // Gradient Background
            Container(
              height: size.height * 0.4,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF031E44), Color(0xFF021B3A)],
                ),
              ),
              child: SafeArea(
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 200,
                  ),
                ),
              ),
            ),

            // White Container
            Column(
              children: [
                SizedBox(height: size.height * 0.3),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 50,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Center(
                            child: Text(
                              "Welcome Back",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF021B3A),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Center(
                            child: Text(
                              "Enter your mobile to get OTP code",
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Mobile Input
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Image.network(
                                  'https://upload.wikimedia.org/wikipedia/en/thumb/4/41/Flag_of_India.svg/20px-Flag_of_India.svg.png',
                                  width: 24,
                                ),
                                const SizedBox(width: 8),
                                const Text("+91", style: TextStyle(fontSize: 16)),
                                const SizedBox(width: 8),
                                Container(
                                  width: 1,
                                  height: 24,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: TextField(
                                      controller: _mobileController,
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      decoration: const InputDecoration(
                                        hintText: "Phone number",
                                        border: InputBorder.none,
                                        counterText: "",
                                      ),
                                      maxLength: 10,
                                      enabled: authState.latestOtp == null,
                                    ),
                                ),
                              ],
                            ),
                          ),

                          if (authState.latestOtp == null) ...[
                            const SizedBox(height: 30),
                            Center(
                              child: SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: authState.isLoading
                                      ? null
                                      : () {
                                          if (_mobileController.text.length == 10) {
                                            ref
                                                .read(authNotifierProvider.notifier)
                                                .sendOTP(_mobileController.text);
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Enter a valid 10-digit number"),
                                              ),
                                            );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF021B3A),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: authState.isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Text(
                                          "Get OTP",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],

                          if (authState.latestOtp != null) ...[
                            const SizedBox(height: 30),
                            const Text(
                              "Enter the 6-digit OTP code",
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(6, (index) {
                                return SizedBox(
                                  width: 45,
                                  child: TextField(
                                    controller: _otpControllers[index],
                                    focusNode: _otpFocusNodes[index],
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    maxLength: 1,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF021B3A),
                                    ),
                                    decoration: InputDecoration(
                                      counterText: "",
                                      filled: true,
                                      fillColor: Colors.grey[100],
                                      contentPadding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF021B3A)),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      if (value.length == 1) {
                                        if (index < 5) {
                                          _otpFocusNodes[index + 1].requestFocus();
                                        } else {
                                          _otpFocusNodes[index].unfocus();
                                        }
                                      } else if (value.isEmpty) {
                                        if (index > 0) {
                                          _otpFocusNodes[index - 1].requestFocus();
                                        }
                                      }
                                    },
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    ref.read(authNotifierProvider.notifier).logout(); // Clear state to reset
                                    for (var c in _otpControllers) {
                                      c.clear();
                                    }
                                  },
                                  child: const Text(
                                    "Change Number",
                                    style: TextStyle(
                                        color: Color(0xFF021B3A),
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    ref
                                        .read(authNotifierProvider.notifier)
                                        .sendOTP(_mobileController.text);
                                  },
                                  child: const Text(
                                    "Resend OTP",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF021B3A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Checkbox(
                                  value: _agreeToTerms,
                                  onChanged: (val) {
                                    setState(() => _agreeToTerms = val ?? false);
                                  },
                                  activeColor: const Color(0xFF021B3A),
                                ),
                                const Expanded(
                                  child: Text(
                                    "I agree to the Terms & Conditions and Privacy Policy",
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: (!_agreeToTerms ||
                                        _otpCode.length < 6 ||
                                        authState.isLoading)
                                    ? null
                                    : () {
                                        ref
                                            .read(authNotifierProvider.notifier)
                                            .verifyOTP(_otpCode);
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF021B3A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: authState.isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text(
                                        "VERIFY",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                ),
                            ),
                          ],
                          const SizedBox(height: 30),
                          const Center(
                            child: Text(
                              "By continuing, you acknowledge that you have read and understood our Terms & Conditions and Privacy Policy.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
