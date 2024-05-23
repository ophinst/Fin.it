import 'package:capstone_project/components/activity_card.dart';
import 'package:capstone_project/models/recentact_model.dart';
import 'package:provider/provider.dart';
import 'package:capstone_project/models/user_provider.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:flutter/material.dart';

class ActivityList extends StatefulWidget {
  const ActivityList({super.key});

  @override
  State<ActivityList> createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  List<LostAct> allLost = [];
  List<FoundAct> allFound = [];
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  bool isDeleting = false;
  final RemoteService _remoteService = RemoteService();

  void getRecentActivity() async {
    setState(() {
      isLoading = true;
    });

    final token = Provider.of<UserProvider>(context, listen: false).token;
    try {
      final response = await _remoteService.getRecentAct(token);
      if (response['data'] != null) {
        List<dynamic> data = response['data'];
        setState(() {
          allFound = data
              .where((item) => item.containsKey('foundId'))
              .map((item) => FoundAct.fromJson(item))
              .toList();
          allLost = data
              .where((item) => item.containsKey('lostId'))
              .map((item) => LostAct.fromJson(item))
              .toList();
        });
      } else {
        print('API returned null or empty data');
      }
    } catch (error) {
      print('Error fetching near items: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void setDeleting(bool deleting) {
    setState(() {
      isDeleting = deleting;
    });
  }

  Future<void> _refreshPage() async {
    getRecentActivity();
  }

  @override
  void initState() {
    super.initState();
    getRecentActivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Text(
              'Activity List',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'JosefinSans',
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: Column(
          children: [
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 25,
                    top: 25,
                  ),
                  child: Text(
                    'Recent Activity',
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
                  : isDeleting
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : allFound.isNotEmpty || allLost.isNotEmpty
                          ? ListView.builder(
                              controller: _scrollController,
                              itemCount: allFound.length + allLost.length,
                              itemBuilder: (context, index) {
                                List<dynamic> combinedItems = [
                                  ...allFound,
                                  ...allLost,
                                ];
                                combinedItems.shuffle();
                                return ActivityCard(
                                  lostAct: combinedItems[index] is LostAct
                                      ? combinedItems[index] as LostAct
                                      : null,
                                  foundAct: combinedItems[index] is FoundAct
                                      ? combinedItems[index] as FoundAct
                                      : null,
                                  onDelete: getRecentActivity,
                                  setDeleting: setDeleting,
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                'No Recent Activity',
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
      ),
    );
  }
}
