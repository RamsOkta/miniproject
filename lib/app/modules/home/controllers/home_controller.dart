import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomeController extends GetxController {
  var user = FirebaseAuth.instance.currentUser;
  var userData = {}.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  void fetchUserData() async {
    isLoading.value = true;
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (doc.exists) {
        userData.value = doc.data() as Map<String, dynamic>;
      } else {
        Get.snackbar('Error', 'User data not found');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user data: $e');
    }
    isLoading.value = false;
  }

  Future<void> pickProfileImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      try {
        isLoading.value = true;
        print('Image Path: ${file.path}');
        print('Image Size: ${file.length} bytes');

        // Upload to Firebase Storage
        var storageRef = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child(user!.uid + '.jpg');
        await storageRef.putFile(file).then((taskSnapshot) async {
          // Get download URL
          String downloadURL = await taskSnapshot.ref.getDownloadURL();

          // Update Firestore with the download URL
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .update({'profileImage': downloadURL});

          // Update local userData
          userData['profileImage'] = downloadURL;

          Get.snackbar('Success', 'Profile image updated');
        }).catchError((e) {
          Get.snackbar('Error', 'Failed to upload image: $e');
        }).whenComplete(() {
          isLoading.value = false;
        });
      } catch (e) {
        Get.snackbar('Error', 'Failed to upload image: $e');
      }
    } else {
      Get.snackbar('Error', 'No image selected');
    }
  }
}
