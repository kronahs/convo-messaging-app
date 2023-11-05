import 'package:chat_app/screens/auth/signup_screen.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void onLogin() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    final authService = Provider.of<AuthServiceProvider>(context, listen: false);

    try{
      await authService.signInWithEmailAndPassword(email, password);
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo at the top center outside the card
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Image.asset('assets/applogo.png', width: 100, height: 100),
            ),
            // Centered card containing the login form
            Card(
              margin: EdgeInsets.all(20),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        onLogin();
                      },
                      child: Text('Log In'),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the login page when the text is tapped
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                      },
                      child: Text(
                          'Create account, Signup'
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
