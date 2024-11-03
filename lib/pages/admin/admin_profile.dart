import 'package:capstone_project/models/user_model.dart';
import 'package:capstone_project/models/user_provider.dart';
import 'package:capstone_project/pages/profile/profile_preview.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:capstone_project/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class AdminProfile extends StatefulWidget {
  final User user;

  const AdminProfile({super.key, required this.user});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey();

  String? userImage =
      'https://storage.googleapis.com/ember-finit/lostImage/fin-H8xduSgoh6/93419946.jpeg';
  final ImagePicker _picker = ImagePicker();
  final RemoteService remoteService = RemoteService();
  var ktpImage = '';
  bool _imageSelected = true;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneNumberController =
        TextEditingController(text: widget.user.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token ?? '';

    final String name = _nameController.text;
    final String phoneNumber = _phoneNumberController.text;

    try {
      await remoteService.updateUserData(token, name, phoneNumber);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save profile: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Function to show confirmation dialog
  Future<void> _showConfirmationDialog(String image, String text) async {
    return showDialog<void>(
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
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.of(context).pop();
                        // final token =
                        //     Provider.of<UserProvider>(context, listen: false)
                        //             .token ??
                        //         '';
                        // finishTransaction(token);
                        
                      },
                      child: const Text('Yes'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('No'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Method to navigate to ImagePreviewPage and handle the result
  Future<void> _previewImage(String imageUrl) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePreview(
          imageUrl: userImage ?? '',
        ),
      ),
    );
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
            size: 35,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _previewImage(userImage!);
                      },
                      child: CircleAvatar(
                        backgroundImage: widget.user.image != null
                            ? NetworkImage(widget.user.image!)
                            : NetworkImage(userImage!),
                        radius: 50,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                Text('Name'),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    readOnly: true,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                Text('Email'),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    readOnly: true,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                Text('Phone Number'),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                      hintText: 'No Phone Number',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    readOnly: true,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                Text('KTP Image'),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: null,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: widget.user.idCard == null
                          ? const Center(child: Text('No KTP Image'))
                          : Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.network(
                                    widget.user.idCard ?? '',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            // InkWell(
            //   onTap: null,
            //   child: Container(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            //     decoration: BoxDecoration(
            //       color: primaryColor,
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     child: const Text(
            //       'Verify User',
            //       style: TextStyle(
            //           color: Colors.white, fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 350,
        child: FloatingActionButton(
          onPressed: () {
            _showConfirmationDialog('assets/images/tandatanya.png',
                'Are you sure you want to verify this user?');
          },
          backgroundColor: const Color.fromRGBO(43, 52, 153, 1),
          child: const Text(
            'Verify User',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
