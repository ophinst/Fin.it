import 'package:capstone_project/components/loading_HUD.dart';
import 'package:capstone_project/components/my_button.dart';
import 'package:capstone_project/components/my_formfield.dart';
import 'package:capstone_project/models/registerModel.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:capstone_project/models/user_provider.dart';

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
  void signUserIn(BuildContext context, String name, String token, String uid) {
    // Navigate to the HomePage
    Navigator.pushNamed(context, '/home', arguments: name);
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
    return ProgressHUD(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      child: _uiSetup(context),
    );
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
              SvgPicture.asset(
                'assets/images/register.svg',
                width: 150,
              ),
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
                      onSaved: (input) => requestModel.confirmPassword = input,
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
                        const snackBar =
                            SnackBar(content: Text("Register Successful"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        // Get the UserProvider instance
                        final userProvider =
                            Provider.of<UserProvider>(context, listen: false);
                        // Update the user's data in the provider
                        userProvider.updateUserData(
                            value.uid!, value.name!, value.token!);
                        userProvider.saveUserData();
                        signUserIn(
                            context, value.name!, value.token!, value.uid!);
                        //if not, return value below
                      } else if (value.message != null) {
                        final snackBar =
                            SnackBar(content: Text(value.message!));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        const snackBar =
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

              //Sign in texts
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontFamily: 'josefinSans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  TextButton(
                    onPressed: () {
                      goLoginPage(context);
                    },
                    child: const Text(
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
