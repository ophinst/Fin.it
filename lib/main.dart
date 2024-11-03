import 'package:capstone_project/pages/admin/admin_page.dart';
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
import 'services/socket_service.dart';

// import 'package:capstone_project/components/list_item_lost.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  final userProvider = UserProvider();
  await userProvider.loadUserData();
  final socketService = SocketService(); // Initialize SocketService
  runApp(ChangeNotifierProvider(
    create: (_) => userProvider,
    child: MyApp(socketService: socketService),
  ));
}

class MyApp extends StatelessWidget {
  final SocketService socketService;

  const MyApp({super.key, required this.socketService});

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
                userProvider.token!.isNotEmpty &&
                userProvider.role! == 'user') {
              // User is logged in, navigate to the home screen or appropriate page
              return const HomeScreen();
            } else if(userProvider.uid!.isNotEmpty &&
                userProvider.name!.isNotEmpty &&
                userProvider.token!.isNotEmpty &&
                userProvider.role! == 'admin'){
                  return const AdminPage();
                }
            else {
              // User is not logged in, show the login page
              return const LoginPage();
            }
          } else {
            // Show a loading screen while waiting for the future to complete
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
      initialRoute: '/',
      routes: {
        '/admin': (context) => const AdminPage(),
        '/home': (context) => const HomeScreen(),
        '/homepage': (context) => const HomePage(),
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/lost': (context) => const LostItemList(),
        '/found': (context) => const FoundItemList(),
        '/add-lost': (context) => const FormLost(),
        '/add-found': (context) => const FormFound(),
        '/chat': (context) => ChatPage(socketService: socketService), // Pass socketService here as well
        '/my-voucher': (context) => const MyVoucher(),
      },
    );
  }
}
