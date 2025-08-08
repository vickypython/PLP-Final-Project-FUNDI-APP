class FundiProfileSetup extends StatefulWidget {
  const FundiProfileSetup({super.key});

  @override
  _FundiProfileSetupState createState() => _FundiProfileSetupState();
}

class _FundiProfileSetupState extends State<FundiProfileSetup> {
  final _fullnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _skillsController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _profileImage;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "role": "fundi",
          "fullname": _fullnameController.text.trim(),
          "email": _emailController.text.trim(),
          "phone": _phoneController.text.trim(),
          "location": _locationController.text.trim(),
          "experience": _experienceController.text.trim(),
          "skills": _skillsController.text.split(",").map((s) => s.trim()).toList(),
          "hourlyRate": _hourlyRateController.text.trim(),
          "verified": false,
          "available": true,
        }, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Fundi profile created successfully")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      }
    }
  }

  Widget _buildInput(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.blue.shade900;
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Fundi Profile"),
        backgroundColor: Colors.blue.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage:
                      _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? Icon(Icons.camera_alt, size: 32)
                      : null,
                ),
              ),
              SizedBox(height: 20),
              _buildInput("Full Name", _fullnameController),
              _buildInput("Email", _emailController, type: TextInputType.emailAddress),
              _buildInput("Phone Number", _phoneController, type: TextInputType.phone),
              _buildInput("Location", _locationController),
              _buildInput("Experience (years)", _experienceController),
              _buildInput("Skills (comma separated)", _skillsController),
              _buildInput("Hourly Rate", _hourlyRateController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text("Save Fundi Profile"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
