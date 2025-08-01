import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final FirebaseFirestore _firestore=FirebaseFirestore.instance
  //dispose the controller to avoid memory leaks
  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _phonenumberController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        elevation: 0,
        title: const Text(
          "Create Your Profile ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            icon: const Icon(Icons.close),
          ),
        ],
        centerTitle: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _fullnameController,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    labelText: 'Fullname*',
                    hintText: 'Enter your fullname',
                    labelStyle: const TextStyle(color: Colors.white38),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade200),
                    ),
                  ),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter your name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    labelText: 'Email*',
                    hintText: 'your.email@example.com',
                    labelStyle: const TextStyle(color: Colors.white38),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade200),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter the email";
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                TextFormField(
                  controller: _phonenumberController,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    labelText: 'Phone Number*',
                    hintText: '+254 700,000,000',
                    labelStyle: TextStyle(color: Colors.white38),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade200),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your phone Number";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _locationController,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    labelText: 'Location',
                    hintText: 'e.g,Nairobi',
                    labelStyle: const TextStyle(color: Colors.white38),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade200),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter your location";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _bioController,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    labelText: "Bio",
                    hintText: 'Tell us a bit about yourself',
                    labelStyle: const TextStyle(color: Colors.white38),
                    hintMaxLines: 5,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade200),
                    ),
                  ),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter your name";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black38),
                      ),
                    ),
                    const SizedBox(width: 4),
                    ElevatedButton(
                      onPressed: () async {
                        
                  if (_formKey.currentState!.validate()) {
                          try {
                            final user=_auth.currentUser;
                            if(user!=null){
                        await _firestore.collection("users").doc(user.iud).set({
                          "fullname": _fullnameController.text.trim(),
                          "email": _emailController.text.trim(),
                         "phone": _phonenumberController.text.trim(),
                         "location": _locationController.text.trim(),
                         "bio": _bioController.text.trim(),
                        // "createdAt": FieldValue.serverTimestamp(),
                        });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Profile created successfully"),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                            }
                            
                          }  catch (e) {
                          print("Error saving profile: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Something went wrong")),
                           );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 1.4),
                      ),
                      child: const Text(
                        "Create Profile",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
}
