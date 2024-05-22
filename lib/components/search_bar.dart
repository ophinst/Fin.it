import 'package:flutter/material.dart';

// DUMMY SEARCH BAR
class AnotherSearchBar extends StatelessWidget {
  final TextEditingController searchController;

  const AnotherSearchBar({
    required this.searchController,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10,
      ),
      width: 127,
      height: 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.transparent, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ]),
      child: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search...",
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.5),
            ),
            prefixIcon: const Icon(
              Icons.search,
              size: 25,
            )),
      ),
    );
  }
}

class SrcBar extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;

  const SrcBar({
    required this.searchController, required this.onSearch
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10,
      ),
      width: 127,
      height: 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.transparent, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ]),
      child: TextFormField(
        controller: searchController,
        onChanged: onSearch, // Call the onSearch function when text changes
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search...",
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.5),
            ),
            prefixIcon: const Icon(
              Icons.search,
              size: 25,
            )),
      ),
    );
  }
}
