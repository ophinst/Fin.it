import 'package:capstone_project/components/my_listtitle.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/models/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:capstone_project/pages/login_page.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  // final void Function()? onSignOut;

  const MyDrawer({
    super.key,
    required this.onProfileTap,
    // required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(children: [
        //header
        const DrawerHeader(
          child: Icon(
            Icons.person,
            color: Colors.black,
            size: 64,
          ),
        ),

        //profile list view
        MyListTitle(
          icon: Icons.person,
          text: 'P R O F I L E',
          onTap: onProfileTap,
        ),

        MyListTitle(
          icon: Icons.logout,
          text: 'L O G O U T',
          onTap: () async {
            // Check if the token is available
            if (Provider.of<UserProvider>(context, listen: false).token !=
                    null &&
                Provider.of<UserProvider>(context, listen: false)
                    .token!
                    .isNotEmpty) {
              // Show a snackbar message
              const snackBar = SnackBar(content: Text("Logout Successful"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              // Get the UserProvider instance
              final userProvider =
                  Provider.of<UserProvider>(context, listen: false);

              // Clear the user's data in the provider
              userProvider.logout();

              // navigate to the login screen or show a message
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            } else {
              // show a message if the token is not available
              const snackBar =
                  SnackBar(content: Text("No active session found."));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
        ),

        //logout
      ]),
    );
  }
}
