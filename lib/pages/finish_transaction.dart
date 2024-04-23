import 'package:flutter/material.dart';

class FinishTransaction extends StatelessWidget {
  const FinishTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Colors.white;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: primaryColor,
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Center(
              child: Text(
                'LOST ITEM',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'JosefinSans',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 17, right: 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 25,
                      top: 25,
                    ),
                    child: Text(
                      'Finish Transaction',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'JosefinSans',
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 25, top: 10, right: 25),
                height: 2,
                color: Colors.black,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'NAMA ITEM',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'JosefinSans',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Date',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'JosefinSans',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Rating User',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'JosefinSans',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                minLines: 3,
                maxLines: 10,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: "Input Feedback....",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.black, width: 3),
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
                      value.trim().length > 150) {
                    return 'Must be between 1 and 150 characters';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
