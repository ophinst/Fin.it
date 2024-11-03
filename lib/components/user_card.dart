import 'package:capstone_project/models/user_model.dart';
import 'package:capstone_project/pages/admin/admin_profile.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminProfile(user: user),
            ),
          );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(43, 52, 153, 1),
                                  fontSize: 30),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              user.email,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              user.phoneNumber ?? 'No Phone Number',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 14),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'ID/KTP: ' + (user.idCard != null ? 'Yes' : 'No'),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Status',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: user.verified == true
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
