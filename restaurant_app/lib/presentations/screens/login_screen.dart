import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core_services/app_routes.dart';
import '../../data/repositories/auth_repository.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../../data/models/user_profile.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _name = TextEditingController(); // For signup
  bool loginMode = true;

  @override
  Widget build(BuildContext context) {
    final authRepo = RepositoryProvider.of<AuthRepository>(context);

    return BlocProvider(
      create: (_) => AuthBloc(authRepo)..add(AuthStarted()),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (ctx, state) {
          if (state is AuthAuthenticated) {
            // Navigate to HomeScreen and pass UserProfile
            Navigator.pushReplacementNamed(
              context,
              AppRouter.home,
              arguments: state.profile,
            );
          }

          if (state is AuthError) {
            ScaffoldMessenger.of(
              ctx,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (ctx, state) {
          return Scaffold(
            appBar: AppBar(title: Text(loginMode ? 'Login' : 'Sign Up')),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (!loginMode)
                    TextField(
                      controller: _name,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                    ),
                  TextField(
                    controller: _email,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _pass,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: 16),
                  if (state is AuthLoading) const CircularProgressIndicator(),
                  if (state is! AuthLoading)
                    ElevatedButton(
                      onPressed: () {
                        final email = _email.text.trim();
                        final pass = _pass.text.trim();

                        if (loginMode) {
                          ctx.read<AuthBloc>().add(
                            SignInRequested(email, pass),
                          );
                        } else {
                          final name = _name.text.trim();
                          ctx.read<AuthBloc>().add(
                            SignUpRequested(
                              email,
                              pass,
                              name,
                              'restaurant', // default role
                            ),
                          );
                        }
                      },
                      child: Text(loginMode ? 'Login' : 'Create Account'),
                    ),
                  TextButton(
                    onPressed: () => setState(() => loginMode = !loginMode),
                    child: Text(
                      loginMode
                          ? 'Create an account'
                          : 'Have an account? Login',
                    ),
                  ),
                  if (state is AuthUnauthenticated && state.message != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        state.message!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
