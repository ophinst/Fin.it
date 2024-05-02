import 'package:capstone_project/pages/voucher_detail.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:capstone_project/models/voucher_model.dart';

class VoucherList extends StatefulWidget {
  const VoucherList({super.key});

  @override
  State<VoucherList> createState() => _VoucherListState();
}

class _VoucherListState extends State<VoucherList> {
  List<GetVoucherModel> allVoucher = []; // Store all the fetched data
  final RemoteService _remoteService = RemoteService();

  var isLoaded = false;
  final ScrollController _scrollController = ScrollController();
  bool isExtend = false;

  void getData() async {
    var data = await RemoteService().getVoucherList();
    if (mounted) {
      setState(() {
        isLoaded = true;
        allVoucher = data;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
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
              'LOST & FOUND',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'JosefinSans',
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: ListView(
        controller: _scrollController,
        children: <Widget>[
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  left: 25,
                  top: 25,
                ),
                child: Text(
                  'Redeem Point',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'JosefinSans',
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              //show search bar component
            ],
          ),
          //underline
          Container(
            margin: const EdgeInsets.only(left: 25, top: 10, right: 25),
            height: 2,
            color: Colors.black,
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Visibility(
              visible: isLoaded,
              child: GridView.builder(
                itemCount: allVoucher.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemBuilder: (context, index) {
                  if (allVoucher.isEmpty) {
                    return CircularProgressIndicator();
                  } else {
                    final rewardId = allVoucher[index].rewardId;
                    final vouchers = allVoucher[index];
                    return InkWell(
                      onTap: () {
                        // Redirect to the LostItemPage passing the voucherId
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VoucherDetail(
                              rewardId: rewardId, vouchers: vouchers,
                              // Pass the voucherId to voucherdetailpage
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                color: Color(0x33000000),
                                offset: Offset(0, 0),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: Column(
                          children: [
                            Container(
                              child: Image.network(
                                allVoucher![index].rewardImage,
                                width: 100,
                                height: 100,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  }
                                },
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Text('Failed to load image');
                                },
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              allVoucher![index].rewardName,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 1),
                            Container(
                              width: 113,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Color(0xFF2B3499),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '${allVoucher![index].rewardPrice} Points',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
