import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/service/bottom_nav_Controller.dart';
import '../../service/authController.dart';
import '../screens/user_verificationScreen/edit_profile_screen.dart';
import '../screens/user_verificationScreen/login_screen.dart';

class ProfileSummaryCard extends StatefulWidget {
  const ProfileSummaryCard({Key? key, this.isEditScreen = false})
      : super(key: key);
  final bool isEditScreen;

  @override
  State<ProfileSummaryCard> createState() => _ProfileSummaryCardState();
}

class _ProfileSummaryCardState extends State<ProfileSummaryCard> {
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (controller) {
      return ListTile(
        onTap: () {
          if (widget.isEditScreen == false) {
            Get.to(const EditProfileScreen());
          }
        },
        leading: controller.user?.photo == null
            ? const CircleAvatar(
                child: Icon(Icons.person),
              )
            : Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black87, // Set your desired border color here
                    width: .5, // Set the border width
                  ),
                ),
                child: ClipOval(
                  child: _buildUserImage(controller.user?.photo ?? ''),
                ),
              ),
        title: Text(
          '${controller.user?.firstName ?? 'null'} ${controller.user?.lastName ?? 'null'}',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          controller.user?.email ?? 'null',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        trailing: IconButton(
          onPressed: () async {
            Get.find<BottomNavController>().ChangeScreen(0);
            AuthController.clearAuthCache();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          icon: const Icon(
            Icons.logout,
            color: Colors.black87,
          ),
        ),
        tileColor: Colors.amber.shade200,
      );
    });
  }
}

//error handling on photo
Widget _buildUserImage(String? imageBytes) {
  try {
    if (imageBytes != null) {
      Uint8List imageBytess = const Base64Decoder()
          .convert(imageBytes.replaceAll('data:image/png;base64,', ''));
      return Image.memory(
        imageBytess,
        height: 45,
        width: 45,
        fit: BoxFit.cover,
      );
    }
  } catch (e) {
    log('Error loading user image: $e');
  }
  // Return a default image or placeholder if an error occurs
  return const CircleAvatar(
    child: Icon(Icons.error),
  );
}
