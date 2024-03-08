import 'package:capstone_project/components/my_button.dart';
import 'package:capstone_project/components/my_formfield.dart';
import 'package:capstone_project/components/my_textfield.dart';
import 'package:capstone_project/components/square_tile.dart';
import 'package:capstone_project/models/registerModel.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'dart:convert'; // Import the dart:convert librarys
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text editing controller
  final emailController = TextEditingController();

  final nameController = TextEditingController();

  final passwordController = TextEditingController();

  final vpasswordController = TextEditingController();

  // sign user up method
  void signUserIn(BuildContext context) {
    Navigator.pushNamed(context, '/home');
  }

  void goLoginPage(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }

  //register model
  late RegisterRequestModel requestModel;
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  @override
  void initState() {
    super.initState();
    requestModel = RegisterRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldMessengerKey,
      backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            controller: ScrollController(),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 50),

              // new here?
              const Text(
                'New Here?',
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
                'Let\'s get you set up',
                style: TextStyle(
                  fontFamily: 'JosefinSans',
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(61, 61, 61, 1),
                ),
              ),
              const SizedBox(height: 25),

              //text
              Form(
                key: globalFormKey,
                child: Column(
                  children: [
                    MyFormField(
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (input) => requestModel.email = input,
                      controller: emailController,
                      hintText: 'email',
                      obscureText: false,
                      prefixIcon: Icons.alternate_email,
                    ),
                    const SizedBox(height: 15),
                    MyFormField(
                      keyboardType: TextInputType.name,
                      onSaved: (input) => requestModel.name = input,
                      controller: nameController,
                      hintText: 'full name',
                      obscureText: false,
                      prefixIcon: Icons.person,
                    ),
                    const SizedBox(height: 15),
                    MyFormField(
                      keyboardType: TextInputType.text,
                      onSaved: (input) => requestModel.password = input,
                      controller: passwordController,
                      hintText: 'password',
                      obscureText: true,
                      prefixIcon: Icons.lock,
                    ),
                    const SizedBox(height: 15),
                    MyFormField(
                      keyboardType: TextInputType.text,
                      onSaved: (input) => requestModel.vpassword = input,
                      controller: vpasswordController,
                      hintText: 'verify password',
                      obscureText: true,
                      prefixIcon: Icons.lock,
                    ),
                    const SizedBox(height: 35),
                  ],
                ),
              ),

              // sign up button
              MyButton(
                buttonText: 'Register',
                onTap: () {
                  if (validateAndSave()) {
                    debugPrint(jsonEncode(requestModel.toJson()));

                    setState(() {
                      isApiCallProcess = true;
                    });
                    //handle API process
                    RemoteService remoteService = RemoteService();
                    remoteService.register(requestModel).then((value) {
                      setState(() {
                        isApiCallProcess = false;
                      });
                      //check token available or not
                      if (value.token != null && value.token!.isNotEmpty) {
                        final snackBar =
                            SnackBar(content: Text("Login Successful"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        signUserIn(context);
                        //if not, return value below
                      } else if (value.message != null) {
                        final snackBar =
                            SnackBar(content: Text(value.message!));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        final snackBar =
                            SnackBar(content: Text("Register Failed"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }).catchError((message) {
                      setState(() {
                        isApiCallProcess = false;
                      });
                      final snackBar =
                          SnackBar(content: Text("Error: $message"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontFamily: 'josefinSans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  TextButton(
                    onPressed: () {
                      goLoginPage(context);
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
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
