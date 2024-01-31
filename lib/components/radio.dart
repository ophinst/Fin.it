import 'package:flutter/material.dart';

enum UserChoose { yes, no }

class RadioBtn extends StatefulWidget {
  const RadioBtn({super.key});

  @override
  State<RadioBtn> createState() => _RadioBtnState();
}

class _RadioBtnState extends State<RadioBtn> {
  UserChoose? _character = UserChoose.yes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Yes'),
          leading: Radio<UserChoose>(
            value: UserChoose.yes,
            groupValue: _character,
            onChanged: (UserChoose? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('No'),
          leading: Radio<UserChoose>(
            value: UserChoose.no,
            groupValue: _character,
            onChanged: (UserChoose? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
