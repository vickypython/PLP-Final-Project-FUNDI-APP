import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fundi/screens/home_page.dart';

class PostProject extends StatefulWidget {
  const PostProject({super.key});

  @override
  State<PostProject> createState() => _PostProjectState();
}

class _PostProjectState extends State<PostProject> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _projectTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timelineController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final List<String> urgencies = [
    'Low Priority',
    'Medium Priority',
    'High Priority',
  ];

  final List<String> categories = [
    'Masonry and Foundation',
    'Plumbing',
    'Interior Finishing',
    'Electrical Work',
    'Roofing and Carpentry',
  ];

  String? _selectedUrgency;
  String? _selectedCategory;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final currentUser = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance.collection('projects').add({
          'title': _projectTitleController.text.trim(),
          'description': _descriptionController.text.trim(),
          'budget': _budgetController.text.trim(),
          'timeline': _timelineController.text.trim(),
          'location': _locationController.text.trim(),
          'urgency': _selectedUrgency,
          'category': _selectedCategory,
          'ownerId': currentUser?.uid, // save ownerId
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project posted successfully')),
        );

        _formKey.currentState!.reset();

        setState(() {
          _projectTitleController.clear();
          _descriptionController.clear();
          _budgetController.clear();
          _timelineController.clear();
          _locationController.clear();
          _selectedUrgency = null;
          _selectedCategory = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error posting project: $e')));
      }
    }
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      labelStyle: const TextStyle(color: Colors.black87),
      hintStyle: const TextStyle(color: Colors.black45),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post New Project"),
        backgroundColor: Colors.blue.shade200,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _projectTitleController,
                decoration: _inputDecoration(
                  'Project Title*',
                  'e.g., 3-Bedroom House',
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the project title'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: _inputDecoration('Category*', 'Select category'),
                value: _selectedCategory,
                items: categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: _inputDecoration(
                  'Description*',
                  'Describe your project...',
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a description'
                    : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _budgetController,
                      decoration: _inputDecoration(
                        'Budget Range*',
                        'e.g., KSH 100,000',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter budget range'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _timelineController,
                      decoration: _inputDecoration(
                        'Timeline*',
                        'e.g., 2-3 weeks',
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter timeline'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _locationController,
                      decoration: _inputDecoration(
                        'Location*',
                        'e.g., Nairobi',
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter your location'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: _inputDecoration(
                        'Urgency*',
                        'Select urgency',
                      ),
                      value: _selectedUrgency,
                      items: urgencies.map((urg) {
                        return DropdownMenuItem(value: urg, child: Text(urg));
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _selectedUrgency = val),
                      validator: (value) =>
                          value == null ? 'Please select urgency' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Post Project',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
