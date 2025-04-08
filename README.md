import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController {
  var username = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var imageBase64 = ''.obs;

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await File(picked.path).readAsBytes();
      imageBase64.value = base64Encode(bytes);
    }
  }

  Future<void> signUp() async {
    final url = Uri.parse('https://yourapi.com/signup');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username.value,
        'email': email.value,
        'password': password.value,
        'profile_pic': imageBase64.value,
      }),
    );

    if (response.statusCode == 200) {
      Get.snackbar('Success', 'Signed up successfully!');
    } else {
      Get.snackbar('Error', 'Signup failed!');
    }
  }
}
