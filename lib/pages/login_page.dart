import 'package:capstone_project/components/my_button.dart';
import 'package:capstone_project/components/my_formfield.dart';
import 'package:capstone_project/components/my_textfield.dart';
import 'package:capstone_project/components/square_tile.dart';
import 'package:capstone_project/models/loginModel.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:flutter/foundation.dart';
// import 'package:capstone_project/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // Import the dart:convert library
import 'package:capstone_project/components/loading_HUD.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:multiple_result/multiple_result.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text editing controller
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final vpasswordController = TextEditingController();

  //Login model
  late LoginRequestModel requestModel;
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  bool isApiCallProcess = false;
  @override
  void initState() {
    super.initState();
    requestModel = new LoginRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      child: _uiSetup(context),
    );
  }

  // sign user in method
  void signUserIn(BuildContext context) {
    // Navigate to the HomePage
    Navigator.pushNamed(context, '/home');
  }

  // sign user to registration
  void signUserReg(BuildContext context) {
    // navigate to register page
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      key: scaffoldMessengerKey,
      backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            controller: ScrollController(),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(
                'assets/images/google.png',
                width: 180,
              ),
              const SizedBox(height: 25),
              // new here?
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontFamily: 'josefinSans',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),

              //let's get you set up
              const Text(
                'Please login with your account',
                style: TextStyle(
                  fontFamily: 'JosefinSans',
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(61, 61, 61, 1),
                ),
              ),
              const SizedBox(height: 25),

              //email text field
              // MyTextField(
              //   controller: emailController,
              //   hintText: 'email',
              //   obscureText: false,
              //   prefixIcon: Icons.alternate_email,
              // ),
              Form(
                key: globalFormKey,
                child: Column(children: [
                  MyFormField(
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (input) => requestModel.email = input,
                      controller: emailController,
                      hintText: 'email',
                      obscureText: false,
                      prefixIcon: Icons.alternate_email),
                  const SizedBox(height: 25),
                  // MyTextField(
                  //   controller: passwordController,
                  //   hintText: 'password',
                  //   obscureText: true,
                  //   prefixIcon: Icons.lock,
                  // ),
                  MyFormField(
                      keyboardType: TextInputType.text,
                      onSaved: (input) => requestModel.password = input,
                      controller: passwordController,
                      hintText: 'password',
                      obscureText: true,
                      prefixIcon: Icons.lock),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(
                      right: 29.0,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontFamily: 'JosefinSans',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // sign up button
                  MyButton(
                    buttonText: 'Login',
                    onTap: () {
                      if (validateAndSave()) {
                        debugPrint(jsonEncode(requestModel.toJson()));

                        setState(() {
                          isApiCallProcess = true;
                        });

                        RemoteService remoteService = RemoteService();
                        remoteService.login(requestModel).then((value) {
                          setState(() {
                            isApiCallProcess = false;
                          });

                          if (value.token!.isNotEmpty) {
                            const snackBar =
                                SnackBar(content: Text("Login Successful"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            signUserIn(context);
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 15),

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
                  const SizedBox(
                    height: 25,
                  ),

                  // sign up methods
                  const Row(
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
                  const SizedBox(
                    height: 35,
                  ),

                  //Sign in texts
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Dont\'n have an account?',
                        style: TextStyle(
                          fontFamily: 'josefinSans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      // MyButton(
                      //   buttonText: 'Login',
                      //   onTap: () {
                      //     signUserIn(context);
                      //   },
                      // ),
                      const SizedBox(height: 15),
                      // Text(
                      //   'Sign up',
                      //   style: TextStyle(
                      //       fontFamily: 'josefinSans',
                      //       color: Color.fromRGBO(43, 52, 153, 1),
                      //       fontWeight: FontWeight.bold),
                      // ),
                    ],
                  )
                ]),
              )
            ]),
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
