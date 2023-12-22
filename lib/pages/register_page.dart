import 'package:capstone_project/components/my_button.dart';
import 'package:capstone_project/components/my_textfield.dart';
import 'package:capstone_project/components/square_tile.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  //text editing controller
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final vpasswordController = TextEditingController();

  // sign user up method
  void signUserUp() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            controller: ScrollController(),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(height: 50),

              // new here?
              Text(
                'New Here?',
                style: TextStyle(
                  fontFamily: 'josefinSans',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 2),

              //let's get you set up
              Text(
                'Let\'s get you set up',
                style: TextStyle(
                  fontFamily: 'JosefinSans',
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(61, 61, 61, 1),
                ),
              ),
              SizedBox(height: 25),

              //text fields
              MyTextField(
                controller: emailController,
                hintText: 'email',
                obscureText: false,
                prefixIcon: Icons.alternate_email,
              ),
              SizedBox(height: 15),
              MyTextField(
                controller: nameController,
                hintText: 'full name',
                obscureText: false,
                prefixIcon: Icons.person,
              ),
              SizedBox(height: 15),
              MyTextField(
                controller: passwordController,
                hintText: 'password',
                obscureText: true,
                prefixIcon: Icons.lock,
              ),
              SizedBox(height: 15),
              MyTextField(
                controller: vpasswordController,
                hintText: 'verify password',
                obscureText: true,
                prefixIcon: Icons.lock,
              ),
              SizedBox(height: 35),

              // sign up button
              MyButton(
                onTap: signUserUp,
              ),
              SizedBox(height: 15),

              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(
                          fontFamily: 'josefinSans',
                          color: Colors.grey[700],
                          fontSize: 12,
                          ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),

              // sign up methods
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(imagePath: 'assets/images/google.png'),
                  SizedBox(
                    width: 30,
                  ),
                  SquareTile(imagePath: 'assets/images/apple.png'),
                  SizedBox(
                    width: 30,
                  ),
                  SquareTile(imagePath: 'assets/images/fb.png'),
                ],
              ),
              SizedBox(
                height: 35,
              ),

              //Sign in texts
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?',
                  style: TextStyle(
                    fontFamily: 'josefinSans',
                    fontWeight: FontWeight.w500,
                  ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Sign in',
                    style: TextStyle(
                      fontFamily: 'josefinSans',
                      color: Color.fromRGBO(43, 52, 153, 1),
                      fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
