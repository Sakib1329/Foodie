import 'package:http/http.dart' as http;
import 'dart:io';

Future<void> uploadImage(File imageFile) async {
  var uri = Uri.parse("https://yourapi.com/upload");
  
  var request = http.MultipartRequest('POST', uri);
  request.headers['Authorization'] = 'Bearer your_token_here'; // Optional
  request.files.add(
    await http.MultipartFile.fromPath(
      'photo',               // field name expected by the server
      imageFile.path,
    ),
  );

  var response = await request.send();

  if (response.statusCode == 200) {
    print("Upload successful!");
  } else {
    print("Upload failed: ${response.statusCode}");
  }
}
