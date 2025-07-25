import 'package:flutter/material.dart';
import 'package:mechanic_services/services/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/input_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: Image(
                      image: AssetImage('assets/images/vehicule.jpg'),
                      fit: BoxFit.cover,
                    )),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 50,
                      child:
                          Image(image: AssetImage('assets/images/arrow1.png'))),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "LOGIN",
                    style: Theme.of(context).textTheme.headlineMedium,
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 35),
              padding: EdgeInsets.only(bottom: 20),
              child: Form(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InputField(
                    controller: usernameController,
                    hintText: "Username",
                    icon: Icons.person,
                  ),
                  SizedBox(height: 20),
                  InputField(
                    controller: passwordController,
                    inputType: TextInputType.text, // Password input
                    obscureText: true, // Hides input
                    hintText: "Password",
                    icon: Icons.lock,
                  ),
                ],
              )),
            ),
            Container(
                margin: EdgeInsets.only(bottom: 20, left: 45),
                width: MediaQuery.of(context).size.width,
                child: Text("forgot password?",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.left)),
            Container(
              margin: EdgeInsets.only(bottom: 20, left: 30, right: 30),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () async {
                  if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter both username and password'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }

                  try {
                    final user = await AuthService().signIn(
                      usernameController.text.trim(),
                      passwordController.text.trim(),
                    );
                    
                    if (user != null) {
                      Navigator.of(context).pushNamed('/home');
                    }
                  } on FirebaseAuthException catch (e) {
                    String errorMessage;
                    switch (e.code) {
                      case 'user-not-found':
                        errorMessage = 'No user found with this username';
                        break;
                      case 'wrong-password':
                        errorMessage = 'Incorrect password';
                        break;
                      case 'invalid-email':
                        errorMessage = 'Invalid email format';
                        break;
                      case 'user-disabled':
                        errorMessage = 'This account has been disabled';
                        break;
                      case 'too-many-requests':
                        errorMessage = 'Too many attempts. Please try again later';
                        break;
                      case 'network-request-failed':
                        errorMessage = 'Network error. Please check your connection';
                        break;
                      default:
                        errorMessage = 'Authentication failed: ${e.message}';
                    }
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMessage),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('An unexpected error occurred: ${e.toString()}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Text("Login",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Text(
                    "Don\'t have an account?",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/sign_up');
                        },
                        child: Text('Sign Up',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18))),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
