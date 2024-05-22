import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:capstone_project/models/category.dart';
import 'package:capstone_project/models/place.dart';
import 'package:capstone_project/components/my_button.dart';
import 'package:capstone_project/components/search_loc.dart';
import 'package:intl/intl.dart';
import 'package:capstone_project/models/found_model.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:capstone_project/components/widgets/location_input.dart';
import 'package:provider/provider.dart';
import 'package:capstone_project/models/user_provider.dart';

class FormFound extends StatefulWidget {
  const FormFound({super.key});

  @override
  State<FormFound> createState() => _FormFoundState();
}

class _FormFoundState extends State<FormFound> {
  List<String> getCategories() {
    return Categories.values.map((e) => e.toString().split('.').last).toList();
  }

  final success = 'assets/images/success.png';
  final failed = 'assets/images/fail.png';

  void _showDialog(bool status, String image, String text) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(image),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  text,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();
  var _itemName = '';
  var _itemDescription = '';
  var _foundDate = DateTime.now();
  var _foundTime = DateTime.now();
  var _category = Categories.Phone.toString().split('.').last;
  PlaceLocation? _placeLocation;

  void _saveItem() async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (_formKey.currentState!.validate() && token != null) {
      _formKey.currentState!.save();
      String formattedDate = DateFormat('yyyy-MM-dd').format(_foundDate);
      String formattedTime = DateFormat('HH:mm:ss').format(_foundTime);
      FoundModel foundItem = FoundModel(
        itemName: _itemName,
        itemDescription: _itemDescription,
        foundDate: formattedDate,
        foundTime: formattedTime.toString(),
        category: _category,
        placeLocation: _placeLocation!,
      );
      bool status = await RemoteService().saveFoundItem(token, foundItem);

      if (status) {
        _showDialog(status, success, 'Success!');
      } else {
        _showDialog(status, failed, 'Failed to upload!');
      }
    } else {
      print('token is null');
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
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 20,
          ),
        ),
        title: const Text(
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
                  const Text(
                    "Item Name",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: "Input Item Name Here",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
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
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
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
                        borderSide:
                            const BorderSide(color: Colors.black, width: 3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(43, 52, 153, 1), width: 3),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 1 ||
                          value.trim().length > 256) {
                        return 'Must be between 1 and 256 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _itemDescription = value!;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "Date",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Center(
                    child: CupertinoButton(
                      child: Text(
                        "${_foundDate.day}-${_foundDate.month}-${_foundDate.year}",
                        style: const TextStyle(fontSize: 22),
                      ),
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.4,
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
                                      initialDateTime: _foundDate,
                                      onDateTimeChanged: (DateTime newTime) {
                                        setState(() => _foundDate = newTime);
                                      },
                                      use24hFormat: true,
                                      mode: CupertinoDatePickerMode.date,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const Text(
                    "Time",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Center(
                    child: CupertinoButton(
                      child: Text(
                        "${_foundTime.hour}:${_foundTime.minute}",
                        style: const TextStyle(fontSize: 22),
                      ),
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.4,
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
                                      initialDateTime: _foundDate,
                                      onDateTimeChanged: (DateTime newTime) {
                                        setState(() => _foundTime = newTime);
                                      },
                                      use24hFormat: true,
                                      mode: CupertinoDatePickerMode.time,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Categories",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  DropdownButtonFormField<String>(
                    value: _category,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    onChanged: (String? newValue) {
                      setState(() {
                        _category = newValue!;
                      });
                    },
                    items: getCategories()
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Last Location",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 10,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 10,
                              color: Color(0x33000000),
                              offset: Offset(0, 0),
                            )
                          ],
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Column(
                          children: [
                            LocationInput(
                              onSelectLocation: (location) {
                                _placeLocation = location;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SrcLoc(),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
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
