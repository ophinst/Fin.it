import 'package:capstone_project/components/widgets/image_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:capstone_project/components/widgets/location_input.dart';
import 'package:capstone_project/components/my_button.dart';
import 'package:capstone_project/models/place.dart';
import 'package:intl/intl.dart';
import 'package:capstone_project/models/category.dart';
import 'package:capstone_project/models/lost_model.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:provider/provider.dart';
import 'package:capstone_project/models/user_provider.dart';

class FormLost extends StatefulWidget {
  const FormLost({super.key});

  @override
  State<FormLost> createState() => _FormLostState();
}

class _FormLostState extends State<FormLost> {
  List<String> getCategories() {
    return Categories.values.map((e) => e.toString().split('.').last).toList();
  }

  final _formKey = GlobalKey<FormState>();
  var _image = '';
  var _itemName = '';
  var _itemDescription = '';
  var _lostDate = DateTime.now();
  var _lostTime = DateTime.now();
  var _category = Categories.Phone.toString().split('.').last;
  PlaceLocation? _placeLocation;
  bool _isLoading = false;
  final success = 'assets/images/success.png';
  final failed = 'assets/images/fail.png';

  void _saveItem() async {
    setState(() {
      _isLoading = true;
    });

    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (_formKey.currentState!.validate() && token != null) {
      _formKey.currentState!.save();

      String formattedDate = DateFormat('yyyy-MM-dd').format(_lostDate);
      String formattedTime = DateFormat('HH:mm:ss').format(_lostTime);

      LostModel lostItem = LostModel(
        image: _image,
        itemName: _itemName,
        itemDescription: _itemDescription,
        lostDate: formattedDate,
        lostTime: formattedTime.toString(),
        category: _category,
        placeLocation: _placeLocation!,
      );
      bool status = await RemoteService().saveLostItem(token, lostItem);

      setState(() {
        _isLoading = false;
      });

      if (status) {
        _showDialog(status, success, 'Your lost item has been uploaded.');
      } else {
        _showDialog(status, failed, 'Failed to upload your lost item.');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print('token is null');
    }
  }

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
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold,),
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Item Name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
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
                                color: Color.fromRGBO(43, 52, 153, 1),
                                width: 3),
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
                      //Image Input
                      ImageInput(
                        onPickImage: (image) {
                          _image = image;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Item Detail",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
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
                                color: Color.fromRGBO(43, 52, 153, 1),
                                width: 3),
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Center(
                        child: CupertinoButton(
                          child: Text(
                            "${_lostDate.day}-${_lostDate.month}-${_lostDate.year}",
                            style: const TextStyle(fontSize: 22),
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
                                          initialDateTime: _lostDate,
                                          onDateTimeChanged:
                                              (DateTime newTime) {
                                            setState(() => _lostDate = newTime);
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
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Time",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Center(
                        child: CupertinoButton(
                          child: Text(
                            "${_lostTime.hour}:${_lostTime.minute}",
                            style: const TextStyle(fontSize: 22),
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
                                          initialDateTime: _lostDate,
                                          onDateTimeChanged:
                                              (DateTime newTime) {
                                            setState(() => _lostTime = newTime);
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
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
                                    setState(() {
                                      _placeLocation = location;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  _placeLocation?.locationDetail ??
                                      'Location Detail',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyButton(buttonText: 'UPLOAD', onTap: _saveItem),
                      const SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
