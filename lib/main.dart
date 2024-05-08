import 'package:capstone_project/pages/chat/chat_page.dart';
import 'package:capstone_project/pages/found_item_list.dart';
import 'package:capstone_project/pages/home_page.dart';
import 'package:capstone_project/pages/home_screen.dart';
import 'package:capstone_project/pages/login_page.dart';
import 'package:capstone_project/pages/myvoucher.dart';
import 'package:capstone_project/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/pages/lost_item_list.dart';
import 'package:capstone_project/pages/form_lost.dart';
import 'package:capstone_project/pages/form_found.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'models/user_provider.dart';

// import 'package:capstone_project/components/list_item_lost.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  // SocketService().initializeSocket();
  final userProvider = UserProvider();
  await userProvider.loadUserData();
  runApp(ChangeNotifierProvider(
    create: (_) => userProvider,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return MaterialApp(
      title: 'Lost and Found',
      theme: ThemeData(
        fontFamily: 'josefinSans',
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: userProvider.loadUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Check if the user is logged in
            if (userProvider.uid!.isNotEmpty &&
                userProvider.name!.isNotEmpty &&
                userProvider.token!.isNotEmpty) {
              // User is logged in, navigate to the home screen or appropriate page
              return HomeScreen();
            } else {
              // User is not logged in, show the login page
              return LoginPage();
            }
          } else {
            // Show a loading screen while waiting for the future to complete
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
      initialRoute: '/',
      routes: {
        '/home': (context) => HomeScreen(),
        '/homepage': (context) => HomePage(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/lost': (context) => LostItemList(),
        '/found': (context) => FoundItemList(),
        '/add-lost': (context) => FormLost(),
        '/add-found': (context) => FormFound(),
        '/chat': (context) => ChatPage(),
        '/my-voucher': (context) => MyVoucher(),
      },
    );
  }
}
