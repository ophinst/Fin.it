import 'package:flutter/material.dart';

Widget buildCompose() => AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
      width: 50,
      height: 50,
      child: FloatingActionButton.extended(
        backgroundColor: Color.fromRGBO(43, 52, 153, 1),
        onPressed: () {},
        icon: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ),
        label: SizedBox(),
      ),
    );
