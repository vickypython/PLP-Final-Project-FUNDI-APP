class RoleSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.blue.shade900;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        title: Text("Choose Your Role"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "How do you want to use the app?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () => _saveRole(context, "client"),
              child: Text("I want to hire (Client)"),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () => _saveRole(context, "fundi"),
              child: Text("I want to work (Fundi)"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveRole(BuildContext context, String role) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "role": role,
      }, SetOptions(merge: true));

      if (role == "client") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ProfileSetup()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => FundiProfileSetup()),
        );
      }
    }
  }
}
