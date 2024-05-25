import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gambar latar belakang
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/home.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: controller.userData['profileImage'] !=
                                null
                            ? NetworkImage(controller.userData['profileImage'])
                            : const NetworkImage(
                                'https://via.placeholder.com/150'),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Nama: ${controller.userData['name'] ?? 'N/A'}',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Email: ${controller.userData['email'] ?? 'N/A'}',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Telepon: ${controller.userData['phone'] ?? 'N/A'}',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          controller.pickProfileImage();
                        },
                        child: const Text('Perbarui Gambar Profil'),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
