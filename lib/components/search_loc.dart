import 'package:flutter/material.dart';

class SearchLoc extends StatelessWidget {
  const SearchLoc({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(9.0),
      child: SrcLoc(),
    );
  }
}

class SrcLoc extends StatelessWidget {
  const SrcLoc({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(214, 214, 214, 1),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Colors.transparent, width: 1),
      ),
      child: TextFormField(
        decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Search Location",
            hintStyle: TextStyle(
              color: Colors.black,
            ),
            prefixIcon: Icon(
              Icons.location_pin,
              size: 25,
              color: Color.fromRGBO(43, 52, 153, 1),
            )),
      ),
    );
  }
}
