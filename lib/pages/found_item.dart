import 'package:flutter/material.dart';

class FoundItemPage extends StatelessWidget {
  const FoundItemPage({super.key});

  void tagButton() {}
  void chatButton() {}

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Colors.white;
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        backgroundColor: primaryColor,
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Center(
              child: Text(
                'FOUND ITEM',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 25,
          ),
          Center(
            child: Image.asset(
              'assets/images/google.png',
              height: 200,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 1,
            height: 532,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nama barang:',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'JosefinSans',
                      color: Color.fromRGBO(43, 52, 153, 1),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Text(
                    'NAMA ITEM',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JosefinSans',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Nama penemu:',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'JosefinSans',
                      color: Color.fromRGBO(43, 52, 153, 1),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Text(
                    'SIAMANG',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JosefinSans',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Color.fromRGBO(43, 52, 153, 1),
                        size: 35,
                      ),
                      Text(
                        'Nanti ini tanggalnya',
                        style:
                            TextStyle(fontFamily: 'JosefinSans', fontSize: 15),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Icon(
                        Icons.timer_sharp,
                        color: Color.fromRGBO(43, 52, 153, 1),
                        size: 35,
                      ),
                      Text(
                        'Nanti ini jamnya',
                        style:
                            TextStyle(fontFamily: 'JosefinSans', fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Center(
                    child: Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 160,
                              right: 160,
                              bottom: 30,
                              top: 30,
                            ),
                            child: Text(
                              'Map',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: Color.fromRGBO(43, 52, 153, 1),
                              ),
                              Text('Ini nanti nama lokasinya'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    'Deskripsi :',
                    style: TextStyle(
                      fontFamily: 'JosefinSans',
                      color: Color.fromRGBO(
                        43,
                        52,
                        153,
                        1,
                      ),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    minLines: 3,
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Enter a description here',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: tagButton,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(43, 52, 153, 1),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(
                            top: 10.0,
                            bottom: 10.0,
                            left: 20.0,
                            right: 20.0,
                          ),
                          child: Text('TAG'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: chatButton,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(43, 52, 153, 1),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(
                            top: 10.0,
                            bottom: 10.0,
                            left: 18.0,
                            right: 18.0,
                          ),
                          child: Text('CHAT'),
                        ),
                      ),
                    ],
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
