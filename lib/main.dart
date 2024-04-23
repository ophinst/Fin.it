import 'package:capstone_project/pages/found_item_list.dart';
import 'package:capstone_project/pages/home_screen.dart';
import 'package:capstone_project/pages/login_page.dart';
import 'package:capstone_project/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/pages/lost_item_list.dart';
import 'package:capstone_project/pages/form_lost.dart';
import 'package:capstone_project/pages/form_found.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'models/user_provider.dart';
import 'package:capstone_project/pages/finish_transaction.dart';

// import 'package:capstone_project/components/list_item_lost.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        title: 'Lost and Found',
        theme: ThemeData(
          fontFamily: 'josefinSans',
        ),
        debugShowCheckedModeBanner: false,
        // home: LoginPage(),
        home: FinishTransaction(),
        initialRoute: '/',
        routes: {
          '/home': (context) => HomeScreen(),
          '/register': (context) => RegisterPage(),
          '/login': (context) => LoginPage(),
          '/lost': (context) => LostItemList(),
          '/found': (context) => FoundItemList(),
          '/add-lost': (context) => FormLost(),
          '/add-found': (context) => FormFound(),
        },
      ),
    );
  }
}
