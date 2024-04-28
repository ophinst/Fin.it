import 'package:flutter/material.dart';

class MyExtendedCompose extends StatelessWidget {
  final Function()? onTap;
  const MyExtendedCompose({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
      width: 130,
      height: 50,
      child: FloatingActionButton.extended(
        backgroundColor: const Color.fromRGBO(43, 52, 153, 1),
        onPressed: onTap,
        icon: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
        label: const Center(
          child: Text(
            "New Data",
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
