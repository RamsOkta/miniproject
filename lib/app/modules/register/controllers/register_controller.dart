import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController(); // Added phoneController
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;

  Future<void> register() async {
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    isLoading.value = true;

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Update user profile with name
      await userCredential.user?.updateDisplayName(nameController.text);

      // Save additional user info to Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text, // Save phone number
      });

      Get.snackbar('Success', 'Registration successful');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Registration failed');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose(); // Dispose phoneController
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
