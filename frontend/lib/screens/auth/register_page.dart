import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/auth_bloc.dart';
import '../../core/utils/validators.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
          AuthSignUpRequested(
            fullName: _nameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            password: _passCtrl.text,
            phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (ctx, state) {
          if (state is AuthFailureState) {
            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFFF44336),
              behavior: SnackBarBehavior.floating,
            ));
          }
          if (state is AuthRegistered) {
            showDialog(
              context: ctx,
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: const Text('Check your email'),
                content: Text(
                    'We sent a verification link to ${_emailCtrl.text.trim()}. '
                    'Please verify your email to continue.',
                    style: GoogleFonts.inter(fontSize: 14, height: 1.6)),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.goNamed('login');
                    },
                    child: const Text('Go to Login'),
                  ),
                ],
              ),
            );
          }
        },
        builder: (ctx, state) {
          final isLoading = state is AuthActionLoading;
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back
                      GestureDetector(
                        onTap: () => context.goNamed('login'),
                        child: Row(children: [
                          const Icon(Icons.arrow_back, size: 20, color: Color(0xFF666666)),
                          const SizedBox(width: 4),
                          Text('Back to login',
                              style: GoogleFonts.inter(
                                  fontSize: 13, color: const Color(0xFF666666))),
                        ]),
                      ),
                      const SizedBox(height: 32),

                      Text('Create account',
                          style: GoogleFonts.poppins(
                              fontSize: 28, fontWeight: FontWeight.w600))
                          .animate().fadeIn(duration: 400.ms),
                      const SizedBox(height: 4),
                      Text('Join thousands of fashion lovers',
                          style: GoogleFonts.inter(
                              fontSize: 15, color: const Color(0xFF666666)))
                          .animate(delay: 80.ms).fadeIn(duration: 400.ms),

                      const SizedBox(height: 32),

                      AppTextField(
                        label: 'Full name',
                        hint: 'First and last name',
                        controller: _nameCtrl,
                        validator: AppValidators.fullName,
                        prefixIcon: const Icon(Icons.person_outline,
                            size: 20, color: Color(0xFF666666)),
                      ).animate(delay: 120.ms).fadeIn(duration: 400.ms),

                      const SizedBox(height: 14),

                      AppTextField(
                        label: 'Email address',
                        hint: 'you@example.com',
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidators.email,
                        prefixIcon: const Icon(Icons.email_outlined,
                            size: 20, color: Color(0xFF666666)),
                      ).animate(delay: 160.ms).fadeIn(duration: 400.ms),

                      const SizedBox(height: 14),

                      AppTextField(
                        label: 'Phone number (optional)',
                        hint: '08012345678',
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? null : AppValidators.phone(v),
                        prefixIcon: const Icon(Icons.phone_outlined,
                            size: 20, color: Color(0xFF666666)),
                      ).animate(delay: 200.ms).fadeIn(duration: 400.ms),

                      const SizedBox(height: 14),

                      AppTextField(
                        label: 'Password',
                        hint: 'Min 8 chars, 1 uppercase, 1 number',
                        controller: _passCtrl,
                        isPassword: true,
                        validator: AppValidators.password,
                        prefixIcon: const Icon(Icons.lock_outlined,
                            size: 20, color: Color(0xFF666666)),
                      ).animate(delay: 240.ms).fadeIn(duration: 400.ms),

                      const SizedBox(height: 14),

                      AppTextField(
                        label: 'Confirm password',
                        hint: 'Repeat your password',
                        controller: _confirmCtrl,
                        isPassword: true,
                        validator: AppValidators.confirmPassword(_passCtrl.text),
                        prefixIcon: const Icon(Icons.lock_outlined,
                            size: 20, color: Color(0xFF666666)),
                        textInputAction: TextInputAction.done,
                        onEditingComplete: _submit,
                      ).animate(delay: 280.ms).fadeIn(duration: 400.ms),

                      const SizedBox(height: 28),

                      AppButton(
                        label: 'Create Account',
                        onPressed: _submit,
                        isLoading: isLoading,
                        width: double.infinity,
                      ).animate(delay: 320.ms).fadeIn(duration: 400.ms),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account? ',
                              style: GoogleFonts.inter(
                                  fontSize: 14, color: const Color(0xFF666666))),
                          GestureDetector(
                            onTap: () => context.goNamed('login'),
                            child: Text('Sign in',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1FAF5A),
                                )),
                          ),
                        ],
                      ).animate(delay: 360.ms).fadeIn(duration: 400.ms),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
