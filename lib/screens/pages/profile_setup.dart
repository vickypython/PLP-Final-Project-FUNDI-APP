// All your imports remain the same
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fundi/screens/home_page.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key});

  @override
  _ProfileSetupState createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  final _fullnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phonenumberController = TextEditingController();
  final _locationController = TextEditingController();
  final _bioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isEditMode = false;
  bool _isLoading = true;
  bool _profileExists = false;
  File? _profileImage;
  double _completionPercent = 0.0;

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Load data at startup
  }

  Future<void> _loadProfileData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        _fullnameController.text = data['fullname'] ?? '';
        _emailController.text = data['email'] ?? '';
        _phonenumberController.text = data['phone'] ?? '';
        _locationController.text = data['location'] ?? '';
        _bioController.text = data['bio'] ?? '';
        _profileExists = true;
        _isEditMode = false;
      } else {
        _isEditMode = true;
      }
      _calculateCompletion();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _calculateCompletion() {
    int filled = 0;
    if (_fullnameController.text.isNotEmpty) filled++;
    if (_emailController.text.isNotEmpty) filled++;
    if (_phonenumberController.text.isNotEmpty) filled++;
    if (_locationController.text.isNotEmpty) filled++;
    if (_bioController.text.isNotEmpty) filled++;
    setState(() {
      _completionPercent = filled / 5;
    });
  }

  Future<void> _pickProfileImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.blue.shade900;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        elevation: 0,
        title: Text(
          _isEditMode ? "Edit Profile" : "Your Profile",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_profileExists)
            IconButton(
              icon: Icon(_isEditMode ? Icons.remove_red_eye : Icons.edit),
              tooltip: _isEditMode ? 'View Mode' : 'Edit Mode',
              onPressed: () => setState(() => _isEditMode = !_isEditMode),
            ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        onChanged: _calculateCompletion,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: _isEditMode ? _pickProfileImage : null,
                              child: CircleAvatar(
                                radius: 45,
                                backgroundImage: _profileImage != null
                                    ? FileImage(_profileImage!)
                                    : null,
                                child: _profileImage == null
                                    ? const Icon(Icons.camera_alt, size: 32)
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Profile Completion Indicator
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Profile Completion"),
                                const SizedBox(height: 5),
                                LinearProgressIndicator(
                                  value: _completionPercent,
                                  backgroundColor: Colors.grey.shade300,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _completionPercent < 1.0
                                        ? Colors.orange
                                        : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            _buildInputField(
                              controller: _fullnameController,
                              label: 'Full Name*',
                              hint: 'Enter your full name',
                              keyboardType: TextInputType.name,
                              validatorMsg: 'Please enter your name',
                            ),
                            _buildInputField(
                              controller: _emailController,
                              label: 'Email*',
                              hint: 'your.email@example.com',
                              keyboardType: TextInputType.emailAddress,
                              validatorMsg: 'Please enter a valid email',
                              emailValidation: true,
                            ),
                            _buildInputField(
                              controller: _phonenumberController,
                              label: 'Phone Number*',
                              hint: '+254 700 000 000',
                              keyboardType: TextInputType.phone,
                              validatorMsg: 'Please enter your phone number',
                            ),
                            _buildInputField(
                              controller: _locationController,
                              label: 'Location*',
                              hint: 'e.g. Nairobi',
                              keyboardType: TextInputType.text,
                              validatorMsg: 'Please enter your location',
                            ),
                            _buildInputField(
                              controller: _bioController,
                              label: 'Bio*',
                              hint: 'Tell us a bit about yourself...',
                              keyboardType: TextInputType.multiline,
                              validatorMsg: 'Please enter a short bio',
                              maxLines: 3,
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                                    );
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: themeColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 24),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    _isEditMode ? "Update Profile" : "Save Profile",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required TextInputType keyboardType,
    required String validatorMsg,
    bool emailValidation = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(color: _isEditMode ? Colors.black87 : Colors.grey),
        // readOnly: !_isEditMode,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black45),
          labelStyle: const TextStyle(color: Colors.black87),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade200),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) return validatorMsg;
          if (emailValidation &&
              !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
            return "Enter a valid email address";
          }
          return null;
        },
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = _auth.currentUser;
        if (user != null) {
          await _firestore.collection("users").doc(user.uid).set({
            "fullname": _fullnameController.text.trim(),
            "email": _emailController.text.trim(),
            "phone": _phonenumberController.text.trim(),
            "location": _locationController.text.trim(),
            "bio": _bioController.text.trim(),
          });
    setState(() {
          _fullnameController.clear();
          _emailController.clear();
           _phonenumberController.clear();
          _locationController.clear();
          _bioController.clear();
         
        });
        
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    _isEditMode ? "Profile updated successfully" : "Profile created"),
              ),
            );
            Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
           
        }
      } catch (e) {
        debugPrint("Error saving profile: $e");
       
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Something went wrong")),
          );
        
      }
    }
  }
}
