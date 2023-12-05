import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_project/models/user_model.dart';
import 'package:task_manager_project/network/network_caller.dart';
import 'package:task_manager_project/network/urls.dart';
import 'package:task_manager_project/service/authController.dart';
import 'package:task_manager_project/ui/screens/bottom_nav_screen.dart';
import 'package:task_manager_project/ui/widgets/profileSummaryCard.dart';
import 'package:task_manager_project/ui/widgets/snackBar.dart';
import '../widgets/body_background.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  bool updateInProgress = false;
  XFile? photo;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            Expanded(
              child: BodyBackground(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 80,
                            ),
                            Text(
                              'Update Profile!',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleLarge,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //Photo picker Field
                            photoPickerField(),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _emailTEController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: "Email",
                              ),
                              validator: (String? value) {
                                // todo - validate the email address with regex
                                if (value
                                    ?.trim()
                                    .isEmpty ?? true) {
                                  return 'Enter your valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _firstNameTEController,
                              decoration: const InputDecoration(
                                hintText: "First Name",
                              ),
                              validator: (String? value) {
                                // todo - validate the email address with regex
                                if (value
                                    ?.trim()
                                    .isEmpty ?? true) {
                                  return 'Enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _lastNameTEController,
                              decoration: const InputDecoration(
                                hintText: "Last Name",
                              ),
                              validator: (String? value) {
                                // todo - validate the email address with regex
                                if (value
                                    ?.trim()
                                    .isEmpty ?? true) {
                                  return 'Enter your last name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _mobileTEController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: "Mobile",
                              ),
                              validator: (String? value) {
                                // todo - validate the email address with regex
                                if (value
                                    ?.trim()
                                    .isEmpty ?? true) {
                                  return 'Enter your mobile';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: _passwordTEController,
                              decoration: const InputDecoration(
                                hintText: "Password/(Optional)",
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Visibility(
                              visible: updateInProgress == false,
                              replacement: const Center(
                                child: CircularProgressIndicator(),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: updateProfile,
                                  child: const Icon(
                                      Icons.arrow_circle_right_outlined),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateProfile() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> inputData = {
        "email": _emailTEController.text,
        "firstName": _firstNameTEController.text,
        "lastName": _lastNameTEController.text,
        "mobile": _mobileTEController.text,
      };
      if (_passwordTEController.text.isNotEmpty) {
        inputData["password"] = _passwordTEController.text;
      }
      updateInProgress = true;
      if (mounted) {
        setState(() {});
      }
      String? imageBase64;
      if (photo != null) {
        List<int> imageBytes = await photo!.readAsBytes();
        imageBase64 = base64Encode(imageBytes);
        //log(imageBase64.toString());
        inputData['photo'] = imageBase64;
      }
      final response = await NetworkCaller()
          .postRequest(Urls.profileUpdateUrl, body: inputData);

      if (response.isSuccess) {
        AuthController.updateUserInfo(UserModel(
            email: _emailTEController.text,
            firstName: _firstNameTEController.text,
            lastName: _lastNameTEController.text,
            mobile: _mobileTEController.text,
            photo: imageBase64 ?? AuthController.user.value?.photo ?? ''));
        if (mounted) {
          showSnackBar(context, 'Profile Updated Successfully');
        }

        _clearTextFields();
      } else if (response.isSuccess == false) {
        if (mounted) {
          showSnackBar(context, 'error occurred', true);
        }
      }

      updateInProgress = false;
      if (mounted) {
        await Future.delayed(const Duration(seconds: 1)).whenComplete(() =>
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const BottomNavScreen()),
                    (route) => false));

        setState(() {});
      }
      log(response.statusCode.toString());
    }
  }

  void _clearTextFields() {
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }

  SizedBox photoPickerField() {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10))),
              alignment: Alignment.center,
              child: const Text('Photo'),
            ),
          ),
          Expanded(
            flex: 6,
            child: GestureDetector(
              onTap: () {
                showPhotoOptionsSnackBar(context);
              },
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(left: 15),
                alignment: Alignment.centerLeft,
                child: Visibility(
                  visible: photo == null,
                  replacement: Text(photo?.name ?? ''),
                  child: const Text(
                    'Empty',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showPhotoOptionsSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Column(
          children: [
            Text('Choose Photo From',style: Theme.of(context).textTheme.titleLarge,),
           SizedBox(height: 20,),
           Row(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               Padding(
                 padding: const EdgeInsets.only(left: 70),
                 child: SnackBarAction(
                   label: 'Gallery',
                   onPressed: () async {
                    // Navigator.pop(context);
                     XFile? image = await ImagePicker()
                         .pickImage(source: ImageSource.gallery, imageQuality: 50);
                     processImage(image);
                   },
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.only(left: 100),
                 child: SnackBarAction(
                   label: 'Camera',
                   onPressed: () async {
                    // Navigator.pop(context);
                     XFile? image = await ImagePicker()
                         .pickImage(source: ImageSource.camera, imageQuality: 50);
                     processImage(image);
                   },
                 ),
               ),
             ],
           )
          ],
        )
      ),
    );
  }

  void processImage(XFile? image) {
    if (image != null) {
      photo = image;
      if (mounted) {
        setState(() {});
      }
    }
  }

}

