import 'package:capstone_project/components/my_listtitle.dart';
import 'package:flutter/material.dart';

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
          onTap: onProfileTap,
        ),

        //logout
      ]),
    );
  }
}
