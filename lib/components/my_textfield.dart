import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final IconData prefixIcon;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.prefixIcon,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                height: 50,
                child: TextField(
                  controller: controller,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color.fromRGBO(131, 162, 255, 0.3)),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      fontFamily: 'JosefinSans',
                      color: Color.fromRGBO(43, 52, 153, 1), // Change the color to your desired color
                    ),
                    prefixIcon: Icon(
                      prefixIcon, // You can replace this with the desired icon
                      color: const Color.fromRGBO(43, 52, 153, 1),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            );
  }
}