import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fundi/screens/home_page.dart';
import 'package:fundi/screens/pages/signup.dart';

//initializng the root comp
class LogIn extends StatelessWidget {
  //initailize the constructor
  LogIn({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        elevation: 0,
        title: const Text(
          "Log in",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Enter Email',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.purple),
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
                const SizedBox(height: 2),
                TextFormField(
                  controller: passwordController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter password";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await _auth.signInWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      } on FirebaseAuthException catch (e) {
                        String errorMessage;
                        if (e.code == "User not found") {
                          errorMessage = "User for that Email not found";
                        } else if (e.code == "password Error") {
                          errorMessage = "Invalid password";
                        } else {
                          errorMessage = "incorrect credetial try again later";
                        }
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(errorMessage)));
                      }
                    }
                  },
                  style:ElevatedButton.styleFrom(
                    backgroundColor:Colors.orangeAccent,
                    shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11)
                    ),
                  padding: const EdgeInsets.symmetric(vertical: 1.4)
                    
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Signup()),
                    );
                  },
                  child: const Text("Don't have an Account? Sign up",
                  style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
