import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/auth_bloc.dart';
import '../../core/utils/validators.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
          AuthSignInRequested(
            email: _emailCtrl.text.trim(),
            password: _passCtrl.text,
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
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFFF44336),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (ctx, state) {
          final isLoading = state is AuthActionLoading;

          return Row(
            children: [
              // ── Left panel (hero) — desktop only ─────────────────────────
              if (MediaQuery.of(context).size.width >= 900)
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1FAF5A), Color(0xFF158045)],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            size: 40,
                            color: Color(0xFF1FAF5A),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'BEST SOLO',
                          style: GoogleFonts.poppins(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Boutique Fashion for the\nmodern woman',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.85),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // ── Right panel (form) ────────────────────────────────────────
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(40),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Mobile logo
                            if (MediaQuery.of(context).size.width < 900)
                              Center(
                                child: Column(children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1FAF5A),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(Icons.shopping_bag_outlined,
                                        size: 28, color: Colors.white),
                                  ),
                                  const SizedBox(height: 12),
                                  Text('BEST SOLO',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1FAF5A),
                                        letterSpacing: 3,
                                      )),
                                  const SizedBox(height: 32),
                                ]),
                              ),

                            Text(
                              'Welcome back',
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF000000),
                              ),
                            ).animate().fadeIn(duration: 400.ms),

                            const SizedBox(height: 4),

                            Text(
                              'Sign in to your account',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: const Color(0xFF666666),
                              ),
                            ).animate(delay: 100.ms).fadeIn(duration: 400.ms),

                            const SizedBox(height: 36),

                            AppTextField(
                              label: 'Email address',
                              hint: 'you@example.com',
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              validator: AppValidators.email,
                              prefixIcon: const Icon(Icons.email_outlined,
                                  size: 20, color: Color(0xFF666666)),
                              textInputAction: TextInputAction.next,
                            ).animate(delay: 150.ms).fadeIn(duration: 400.ms),

                            const SizedBox(height: 16),

                            AppTextField(
                              label: 'Password',
                              hint: 'Enter your password',
                              controller: _passCtrl,
                              isPassword: true,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Password is required' : null,
                              prefixIcon: const Icon(Icons.lock_outlined,
                                  size: 20, color: Color(0xFF666666)),
                              textInputAction: TextInputAction.done,
                              onEditingComplete: _submit,
                            ).animate(delay: 200.ms).fadeIn(duration: 400.ms),

                            const SizedBox(height: 12),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () =>
                                    context.goNamed('forgot-password'),
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF1FAF5A),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(
                                  'Forgot password?',
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ).animate(delay: 250.ms).fadeIn(duration: 400.ms),

                            const SizedBox(height: 24),

                            AppButton(
                              label: 'Sign In',
                              onPressed: _submit,
                              isLoading: isLoading,
                              width: double.infinity,
                            ).animate(delay: 300.ms).fadeIn(duration: 400.ms),

                            const SizedBox(height: 32),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: const Color(0xFF666666)),
                                ),
                                GestureDetector(
                                  onTap: () => context.goNamed('register'),
                                  child: Text(
                                    'Sign up',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1FAF5A),
                                    ),
                                  ),
                                ),
                              ],
                            ).animate(delay: 350.ms).fadeIn(duration: 400.ms),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
