import 'package:capstone_project/models/userVoucher_model.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/models/voucher_model.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:capstone_project/models/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:capstone_project/components/myvoucher_card.dart';
import 'package:flutter/foundation.dart';

class MyVoucher extends StatefulWidget {
  const MyVoucher({super.key});

  @override
  State<MyVoucher> createState() => _MyVoucherState();
}

class _MyVoucherState extends State<MyVoucher> {
  List<Voucher> myVoucher = [];

  ScrollController _scrollController = new ScrollController();
  bool isLoading = false;
  final RemoteService _remoteService = RemoteService();

  void getUserVoucher() async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    isLoading = true;
    try {
      final response = await _remoteService.getMyVoucher(token);
      if (response['data'] != null) {
        // Access the 'voucher' key within the 'data' map
        if (response['data']['voucher'] is List) {
          List<dynamic> data = response['data']['voucher'];
          setState(() {
            myVoucher = data.map((item) => Voucher.fromJson(item)).toList();
          });
        } else {
          print(
              'Error: Expected a list for response[\'data\'][\'voucher\'], but got a different type instead.');
        }
      } else {
        print('API returned null or empty data');
      }
    } catch (error) {
      print('Error fetching near items: $error');
    } finally {
      isLoading = false;
    }
  }

  @override
  void initState() {
    super.initState();
    getUserVoucher();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Text(
              'Voucher',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'JosefinSans',
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 25,
                  top: 25,
                ),
                child: Text(
                  'My Voucher',
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
            height: 10,
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : myVoucher.isNotEmpty
                    ? ListView.builder(
                        controller: _scrollController,
                        itemCount: myVoucher.length,
                        itemBuilder: (context, index) {
                          return MyVoucherCard(
                            userVoucher: myVoucher[index],
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'No Voucher Available',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(43, 52, 153, 1),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
