import 'package:capstone_project/components/my_button.dart';
import 'package:capstone_project/components/my_formfield.dart';
import 'package:capstone_project/models/loginModel.dart';
import 'package:capstone_project/models/user_provider.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:capstone_project/components/loading_HUD.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
    requestModel = LoginRequestModel();
  }

  //Create build loading hud
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      child: _uiSetup(context),
    );
  }

  // sign user in method
  void signUserIn(BuildContext context, String name, String uid, String token) {
    // Navigate to the HomePage
    Navigator.pushNamed(context, '/home', arguments: name);
  }

  void signUserUp(BuildContext context) {
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
              SvgPicture.asset(
                'assets/images/login2.svg',
                width: 250,
              ),

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

              //form for input user data
              Form(
                key: globalFormKey,
                child: Column(children: [
                  //email
                  MyFormField(
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (input) => requestModel.email = input,
                      validator: (input) => !input.contains('@')
                          ? "Email ID should be valid"
                          : null,
                      controller: emailController,
                      hintText: 'email',
                      obscureText: false,
                      prefixIcon: Icons.alternate_email),

                  const SizedBox(height: 25),
                  //password
                  MyFormField(
                      keyboardType: TextInputType.text,
                      onSaved: (input) => requestModel.password = input,
                      validator: (input) => input.length < 3
                          ? "Password should be more than 3 characters"
                          : null,
                      controller: passwordController,
                      hintText: 'password',
                      obscureText: true,
                      prefixIcon: Icons.lock),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(
                      right: 29.0,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // sign up button
                  MyButton(
                    buttonText: 'Login',
                    onTap: () {
                      if (validateAndSave()) {
                        // debugPrint(jsonEncode(requestModel.toJson()));

                        setState(() {
                          isApiCallProcess = true;
                        });
                        //handle API process
                        RemoteService remoteService = RemoteService();
                        remoteService.login(requestModel).then((value) {
                          setState(() {
                            isApiCallProcess = false;
                          });
                          //check token available or not
                          if (value.token != null && value.token!.isNotEmpty) {
                            const snackBar =
                                SnackBar(content: Text("Login Successful"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            // Get the UserProvider instance
                            final userProvider = Provider.of<UserProvider>(
                                context,
                                listen: false);
                            // Update the user's data in the provider
                            userProvider.updateUserData(
                                value.uid!, value.name!, value.token!);
                            signUserIn(
                                context, value.name!, value.uid!, value.token!);

                            //if not, return value below
                          } else if (value.error != null) {
                            final snackBar =
                                SnackBar(content: Text(value.error!));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            const snackBar =
                                SnackBar(content: Text("Login Failed"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }).catchError((error) {
                          setState(() {
                            isApiCallProcess = false;
                          });
                          final snackBar =
                              SnackBar(content: Text("Error: $error"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 15),

                  const SizedBox(
                    height: 25,
                  ),

                  //Sign in texts
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Dont\'n have an account?',
                        style: TextStyle(
                          fontFamily: 'josefinSans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          signUserUp(context);
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
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
