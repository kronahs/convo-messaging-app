import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final  _fullNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ConfPasswordController = TextEditingController();


  void signUp() async{
    String fullname = _fullNameController.text;
    String username = _userNameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String ConfirmPassword = _ConfPasswordController.text;
    String defaultProfilePic = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";
    
    final _authService = Provider.of<AuthServiceProvider>(context,listen: false);
    try{
      if(password != ConfirmPassword){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password Doesnt Match")));
      }else{
        await _authService.signUpWithEmailAndPassword(fullname, email, username, password, ConfirmPassword,defaultProfilePic);
      }
    }
    catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60,),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Image.asset('assets/applogo.png', width: 100, height: 100),
              ),
              // Centered card containing the signup form
              Card(
                margin: EdgeInsets.all(20),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Welcome to ChatPach', style: Theme.of(context).textTheme.titleMedium,),
                      SizedBox(height: 30,),
                       TextField(
                        controller: _fullNameController,
                        decoration: InputDecoration(
                          labelText: 'Fullname',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                       TextField(
                         controller: _userNameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
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
                      TextField(
                        controller: _ConfPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          signUp();
                        },
                        child: Text('Sign Up'),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to the login page when the text is tapped
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogInPage()));
                        },
                        child: Text(
                          'Already have an account? Login'
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
