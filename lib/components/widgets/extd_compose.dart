import 'package:flutter/material.dart';

Widget buildExtendedCompose(context) => AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
      width: 130,
      height: 50,
      child: FloatingActionButton.extended(
        backgroundColor: Color.fromRGBO(43, 52, 153, 1),
        onPressed: () {
          Navigator.pushNamed(context, '/add-lost');
        },
        icon: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        label: Center(
          child: Text(
            "New Data",
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      ),
    );
