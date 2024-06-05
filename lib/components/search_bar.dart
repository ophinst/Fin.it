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

class SrcBar extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;
  final double size;

  const SrcBar({
    required this.searchController,
    required this.onSearch,
    required this.size,
    super.key
  });

  @override
  State<SrcBar> createState() => _SrcBarState();
}

class _SrcBarState extends State<SrcBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10,
      ),
      width: widget.size,
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
        controller: widget.searchController,
        onChanged: (value) {
          if (value.length >= 3 || value.isEmpty) {
            widget.onSearch(value);
          }
        },
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

