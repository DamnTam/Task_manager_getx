import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:task_manager_project/service/photoPickerController.dart';
import 'package:task_manager_project/service/updateProfileController.dart';
import 'package:task_manager_project/ui/screens/task_screens/bottom_nav_screen.dart';
import 'package:task_manager_project/ui/widgets/profileSummaryCard.dart';
import 'package:task_manager_project/ui/widgets/snackBar.dart';
import '../../widgets/body_background.dart';

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
  UpdateProfileController updateProfileController = Get.find<UpdateProfileController>();
  PhotoPickerController photoPickerController=Get.find<PhotoPickerController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const  ProfileSummaryCard(isEditScreen: true,),
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
                              style: Theme.of(context).textTheme.titleLarge,
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
                                if (value?.trim().isEmpty ?? true) {
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
                                if (value?.trim().isEmpty ?? true) {
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
                                if (value?.trim().isEmpty ?? true) {
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
                                if (value?.trim().isEmpty ?? true) {
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
                            GetBuilder<UpdateProfileController>(
                              builder: (updateProfileController) {
                                return Visibility(
                                  visible: updateProfileController.updateInProgress == false,
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
                                );
                              }
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
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final response = await updateProfileController.updateProfile(
        _emailTEController.text,
        _firstNameTEController.text,
        _lastNameTEController.text,
        _mobileTEController.text,
        _passwordTEController.text,
        photoPickerController.photo
    );
    if(response){
      _clearTextFields();
      if(mounted){
        showSnackBar(context, updateProfileController.snackMessage);
        await Future.delayed(const Duration(seconds: 1))
            .whenComplete(() => Get.offAll(const BottomNavScreen()));
      }
    }
    else {
      if(mounted){
        showSnackBar(context, updateProfileController.snackMessage, true);
      }
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
              decoration: const  BoxDecoration(
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
                photoPickerController.showPhotoOptionsSnackBar(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                padding: const EdgeInsets.only(left: 15),
                alignment: Alignment.centerLeft,
                child: GetBuilder<PhotoPickerController>(
                  builder: (photoController) {
                    return Visibility(
                      visible: photoController.photo == null,
                      replacement: Text(photoController.photo?.name ?? ''),
                      child: const Text(
                        'Select a Photo',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

