import 'dart:io';

import 'package:flutter/material.dart';

class ProfilePreview extends StatelessWidget {
  final String imageUrl;
  final Function(String)? onSave;

  const ProfilePreview({
    Key? key,
    required this.imageUrl,
    this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Preview'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: onSave != null
                  ? Image.file(
                      File(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          if (onSave != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Save the image URL
                  onSave!(imageUrl);
                  // Navigate back
                  Navigator.pop(context);
                },
                child: const Text('Save Image'),
              ),
            ),
        ],
      ),
    );
  }
}


