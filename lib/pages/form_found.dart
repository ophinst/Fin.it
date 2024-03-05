import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:capstone_project/components/form_categories.dart';
import 'package:capstone_project/components/my_button.dart';
import 'package:capstone_project/components/search_loc.dart';
import 'package:capstone_project/components/radio.dart';
import 'package:http/http.dart' as http;

class FormFound extends StatefulWidget {
  const FormFound({super.key});

  @override
  State<FormFound> createState() => _FormFoundState();
}

class _FormFoundState extends State<FormFound> {
  final _formKey = GlobalKey<FormState>();
  var _itemName = '';
  var _itemDescription = '';
  var _foundDate = "2024-01-29";
  var _foundTime = "12:30:00";
  var _category = 'Phone';
  var _latitude = '3.6125771940756817';
  var _longitude = '98.6750036157047';
  var _locationDetail = 'Manggarai';
  DateTime dateTime = DateTime.now();

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
        'finit-api-ahawuso3sq-et.a.run.app',
        '/api/found',
      );
      http.post(
        url,
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiJmaW4tSDh4ZHVTZ29oNiIsIm5hbWUiOiJmaW4iLCJpYXQiOjE3MDY1Mzk0MDYsImV4cCI6MTcwNjYyNTgwNn0.hN-2755rsnAYNwxn5Qll_MmT8irT6_oFwTTIdn6wwU4',
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'itemName': _itemName,
            'itemDescription': _itemDescription,
            'foundDate': _foundDate,
            'foundTime': _foundTime,
            'category': _category,
            'latitude': _latitude,
            'longitude': _longitude,
            'locationDetail': _locationDetail
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 20,
          ),
        ),
        title: Text(
          'Back',
          style: TextStyle(),
        ),
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: "Input Name Here",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.black, width: 3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                            color: Color.fromRGBO(43, 52, 153, 1), width: 3),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Item Name",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: "Input Item Name Here",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.black, width: 3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                            color: Color.fromRGBO(43, 52, 153, 1), width: 3),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 1 ||
                          value.trim().length > 50) {
                        return 'Must be between 1 and 50 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _itemName = value!;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Broadcast Massages",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  TextFormField(
                    minLines: 3,
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: "Massages...",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.black, width: 3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                            color: Color.fromRGBO(43, 52, 153, 1), width: 3),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 1 ||
                          value.trim().length > 150) {
                        return 'Must be between 1 and 150 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _itemDescription = value!;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Date",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Center(
                    child: CupertinoButton(
                      child: Text(
                        "${dateTime.day}-${dateTime.month}-${dateTime.year}",
                        style: TextStyle(fontSize: 22),
                      ),
                      onPressed: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Done",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 15),
                                      ),
                                    ),
                                    Expanded(
                                      child: CupertinoDatePicker(
                                        backgroundColor: Colors.white,
                                        initialDateTime: dateTime,
                                        onDateTimeChanged: (DateTime newTime) {
                                          setState(() => dateTime = newTime);
                                        },
                                        use24hFormat: true,
                                        mode: CupertinoDatePickerMode.date,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Categories",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  FilterCategories(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Last Location",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 10,
                        height: MediaQuery.of(context).size.height * 0.224,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              color: Color(0x33000000),
                              offset: Offset(0, 0),
                            )
                          ],
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Column(children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.87,
                            height: MediaQuery.of(context).size.height * 0.12,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Center(
                              child: Text(
                                'NANTI INI MAP',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SrcLoc(),
                          SizedBox(
                            height: 10,
                          ),
                        ]),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyButton(
                    buttonText: 'UPLOAD',
                    onTap: _saveItem,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
