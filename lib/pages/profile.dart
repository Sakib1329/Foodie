import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodie/pages/login.dart';
import 'package:foodie/servics/auth.dart';
import 'package:foodie/servics/sr.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? name, profile, email;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  bool isLoading = false; // New variable to track loading state

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {
      uploadItem();
    });
  }

  uploadItem() async {
    if (selectedImage != null) {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
      FirebaseStorage.instance.ref().child("blogImages").child(addId);
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadUrl = await (await task).ref.getDownloadURL();
      await SharedPreferenceHelper().saveUserProfile(downloadUrl);
      setState(() {});
    }
  }

  getthesharedpref() async {
    profile = await SharedPreferenceHelper().getUserProfile();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  onthisload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    onthisload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Loading state
          : name == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 45.0, left: 20.0, right: 20.0),
                height: MediaQuery.of(context).size.height / 4.3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(
                            MediaQuery.of(context).size.width,
                            105.0))),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 6.5),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(60),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: selectedImage == null
                          ? GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: profile == null
                              ? Image.asset("images/food.jpg",
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover)
                              : Image.network(
                            profile!,
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ))
                          : Image.file(
                        selectedImage!,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppin'),
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 30.0),
          buildProfileInfoRow(Icons.person, "Name", name!),
          const SizedBox(height: 30.0),
          buildProfileInfoRow(Icons.email, "Email", email!),
          const SizedBox(height: 30.0),
          buildProfileInfoRow(
              Icons.description, "Terms and Conditions", "Read and Accept"),
          const SizedBox(height: 30.0),
          buildActionRow(Icons.delete, "Delete Account", () async {
            bool? confirm = await _showDeleteConfirmation();
            if (confirm == true) {
              setState(() {
                isLoading = true; // Start loading
              });
              try {
                await AuthMethods().deleteuser();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LogIn())); // Navigate to login screen
              } catch (e) {
                print("Error deleting account: $e");
              } finally {
                setState(() {
                  isLoading = false; // Stop loading
                });
              }
            }
          }),
          const SizedBox(height: 30.0),
          buildActionRow(Icons.logout, "Logout", () async {
            setState(() {
              isLoading = true;
            });
            await AuthMethods().SignOut();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const LogIn())); // Navigate to login screen
          }),
        ],
      ),
    );
  }

  Widget buildProfileInfoRow(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        elevation: 2.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Center items horizontally
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 20.0),
              Expanded( // Allows text to take up available space
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      value,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildActionRow(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          elevation: 2.0,
          child: Container(
            padding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
            child: Row(
              children: [
                Icon(icon, color: Colors.black),
                const SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: const Text(
              "Are you sure you want to delete your account? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
