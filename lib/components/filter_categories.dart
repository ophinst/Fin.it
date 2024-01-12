import 'package:flutter/material.dart';

List<String> items = [
  'item1',
  'item2',
  'item3',
];

class FilterCategories extends StatefulWidget {
  const FilterCategories({super.key});

  @override
  State<FilterCategories> createState() => _FilterCategoriesState();
}

class _FilterCategoriesState extends State<FilterCategories> {
  String? selectedItem;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 230, right: 20),
      child: Container(
        alignment: Alignment.topLeft,
        height: 40,
        // color: Colors.amber,
        decoration: BoxDecoration(
          color: Color.fromRGBO(217, 217, 217, 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: DropdownButton<String>(
          style: TextStyle(
              color: Color.fromRGBO(43, 52, 153, 1),
              fontFamily: 'JosefinSans',
              fontWeight: FontWeight.w500),
          padding: EdgeInsets.only(left: 10),
          borderRadius: BorderRadius.circular(15),
          iconSize: 30,
          hint: Text("Choose Categories"),
          value: selectedItem,
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 24),
                    ),
                  ))
              .toList(),
          onChanged: (item) => setState(() => selectedItem = item),
        ),
      ),
    );
  }
}
