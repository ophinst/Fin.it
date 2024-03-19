import 'package:flutter/material.dart';

Widget buildCompose(context) => AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
      width: 50,
      height: 50,
      child: FloatingActionButton.extended(
        backgroundColor: const Color.fromRGBO(43, 52, 153, 1),
        onPressed: () {
          Navigator.pushNamed(context, '/add-lost');
        },
        icon: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ),
        label: const SizedBox(),
      ),
    );
