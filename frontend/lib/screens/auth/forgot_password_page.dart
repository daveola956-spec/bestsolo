import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/auth_bloc.dart';
import '../../core/utils/validators.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
          AuthPasswordResetRequested(_emailCtrl.text.trim()),
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
        },
        builder: (ctx, state) {
          final isLoading = state is AuthActionLoading;
          final isSent = state is AuthPasswordResetSent;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: isSent
                    ? _buildSuccessView(state.email)
                    : Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => context.goNamed('login'),
                              child: Row(children: [
                                const Icon(Icons.arrow_back,
                                    size: 20, color: Color(0xFF666666)),
                                const SizedBox(width: 4),
                                Text('Back to login',
                                    style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: const Color(0xFF666666))),
                              ]),
                            ),
                            const SizedBox(height: 32),

                            const Icon(Icons.lock_reset_outlined,
                                size: 48, color: Color(0xFF1FAF5A))
                                .animate().scale(duration: 400.ms, curve: Curves.elasticOut),

                            const SizedBox(height: 20),

                            Text('Reset password',
                                style: GoogleFonts.poppins(
                                    fontSize: 26, fontWeight: FontWeight.w600))
                                .animate(delay: 100.ms).fadeIn(duration: 400.ms),
                            const SizedBox(height: 6),
                            Text(
                                "Enter your email and we'll send you a link to reset your password.",
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: const Color(0xFF666666),
                                    height: 1.6))
                                .animate(delay: 150.ms).fadeIn(duration: 400.ms),

                            const SizedBox(height: 32),

                            AppTextField(
                              label: 'Email address',
                              hint: 'you@example.com',
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              validator: AppValidators.email,
                              prefixIcon: const Icon(Icons.email_outlined,
                                  size: 20, color: Color(0xFF666666)),
                              textInputAction: TextInputAction.done,
                              onEditingComplete: _submit,
                            ).animate(delay: 200.ms).fadeIn(duration: 400.ms),

                            const SizedBox(height: 24),

                            AppButton(
                              label: 'Send Reset Link',
                              onPressed: _submit,
                              isLoading: isLoading,
                              width: double.infinity,
                            ).animate(delay: 250.ms).fadeIn(duration: 400.ms),
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

  Widget _buildSuccessView(String email) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5EA),
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(Icons.mark_email_read_outlined,
              size: 40, color: Color(0xFF1FAF5A)),
        ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),

        const SizedBox(height: 24),

        Text('Check your inbox!',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 24, fontWeight: FontWeight.w600))
            .animate(delay: 200.ms).fadeIn(duration: 400.ms),

        const SizedBox(height: 12),

        Text('We sent a password reset link to\n$email',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                fontSize: 14, color: const Color(0xFF666666), height: 1.6))
            .animate(delay: 300.ms).fadeIn(duration: 400.ms),

        const SizedBox(height: 40),

        AppButton(
          label: 'Back to Login',
          onPressed: () => context.goNamed('login'),
          width: double.infinity,
        ).animate(delay: 400.ms).fadeIn(duration: 400.ms),
      ],
    );
  }
}
