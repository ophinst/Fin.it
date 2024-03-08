import 'package:flutter/material.dart';

List<String> items = [
  'All',
  'Wallet',
  'electronics',
  'misc',
];

class FilterCategories extends StatefulWidget {
  final Function(String?) onCategoryChanged;

  const FilterCategories({Key? key, required this.onCategoryChanged})
      : super(key: key);

  @override
  State<FilterCategories> createState() => _FilterCategoriesState();
}

class _FilterCategoriesState extends State<FilterCategories> {
  String? selectedItem;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
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
          onChanged: (item) {
            setState(() {
            selectedItem = item;
            });
            widget.onCategoryChanged(item); 
          } 
        ),
      ),
    );
  }
}
