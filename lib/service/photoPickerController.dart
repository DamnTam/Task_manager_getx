import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class PhotoPickerController extends GetxController{
  XFile? photo;
  void showPhotoOptionsSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.white,
          content: Column(
            children: [
              Text(
                'Choose Photo From',
                style: Theme.of(context).textTheme.titleLarge,
              ),
             const  SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 70),
                    child: SnackBarAction(
                      label: 'Gallery',
                      onPressed: () async {
                        // Navigator.pop(context);
                        XFile? image = await ImagePicker().pickImage(
                            source: ImageSource.gallery, imageQuality: 50);
                        if (image != null) {
                          photo = image;
                          update();
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 100),
                    child: SnackBarAction(
                      label: 'Camera',
                      onPressed: () async {
                        // Navigator.pop(context);
                        XFile? image = await ImagePicker().pickImage(
                            source: ImageSource.camera, imageQuality: 50);
                        if (image != null) {
                          photo = image;
                          update();
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}