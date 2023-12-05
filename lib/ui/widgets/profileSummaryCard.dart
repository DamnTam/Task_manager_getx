import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../service/authController.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/login_screen.dart';

class ProfileSummaryCard extends StatefulWidget {
  const ProfileSummaryCard({Key? key}) : super(key: key);

  @override
  State<ProfileSummaryCard> createState() => _ProfileSummaryCardState();
}

class _ProfileSummaryCardState extends State<ProfileSummaryCard> {


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AuthController.user,
        builder: (BuildContext context, UserModel? value, Widget? child) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditProfileScreen()),
              );
            },
            leading: AuthController.user.value?.photo == null
                ? const CircleAvatar(
                    child: Icon(Icons.person),
                  )
                : ClipOval(
                  child: _buildUserImage(AuthController.user.value?.photo),
            ),
            title: Text('${value?.firstName ?? ''} ${value?.lastName ?? ' '}'),
            subtitle: Text(value?.email ?? 'null'),
            trailing: IconButton(
              onPressed: () async {
                AuthController.clearAuthCache();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.logout),
            ),
            tileColor: Colors.green,
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
