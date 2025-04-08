import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class SignUpScreen extends StatelessWidget {
  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Obx(() => GestureDetector(
              onTap: controller.pickImage,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[300],
                child: controller.imageBase64.isEmpty
                    ? Icon(Icons.add_a_photo)
                    : Icon(Icons.check, color: Colors.green),
              ),
            )),
            TextField(
              decoration: InputDecoration(labelText: 'Username'),
              onChanged: (val) => controller.username.value = val,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (val) => controller.email.value = val,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (val) => controller.password.value = val,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.signUp,
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
