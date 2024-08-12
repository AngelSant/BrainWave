import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
      return null;
    } catch (e) {
      return 'Login failed: ${e.toString()}';
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data.name!,
        password: data.password!,
      );
      return null;
    } catch (e) {
      return 'Signup failed: ${e.toString()}';
    }
  }

  Future<String?> _recoverPassword(String name) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: name);
      return null;
    } catch (e) {
      return 'Password recovery failed: ${e.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'BrainWave',
      logo: const AssetImage('assets/images/logo.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ));
      },
      onRecoverPassword: _recoverPassword,
      messages: LoginMessages(
        userHint: 'Correo electronico',
        passwordHint: 'Contraseña',
        confirmPasswordHint: 'Confirmar contraseña',
        loginButton: 'Iniciar Sesion',
        signupButton: 'Registrarse',
        forgotPasswordButton: '¿Olvidaste tu contraseña?',
        recoverPasswordButton: 'Recuperar',
        goBackButton: 'Atras',
        confirmPasswordError: 'Las contraseñas no coinciden',
        recoverPasswordDescription:
        'Se enviara un correo electronico para restablecer tu contraseña',
        recoverPasswordSuccess: 'Correo enviado con exito',
      ),
    );
  }
}
