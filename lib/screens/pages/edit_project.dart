import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProjectScreen extends StatefulWidget {
  final String projectId; // Firestore document ID
  final Map<String, dynamic> projectData; // Existing project data

  const EditProjectScreen({
    Key? key,
    required this.projectId,
    required this.projectData,
  }) : super(key: key);

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _projectTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timelineController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Prefill the fields with existing project data
    _projectTitleController.text = widget.projectData['title'] ?? '';
    _descriptionController.text = widget.projectData['description'] ?? '';
    _timelineController.text = widget.projectData['timeline'] ?? '';
    _budgetController.text = widget.projectData['budget'] ?? '';
    _locationController.text = widget.projectData['location'] ?? '';
  }

  @override
  void dispose() {
    _projectTitleController.dispose();
    _descriptionController.dispose();
    _timelineController.dispose();
    _budgetController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _updateProject() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .update({
        'title': _projectTitleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'timeline': _timelineController.text.trim(),
        'budget': _budgetController.text.trim(),
        'location': _locationController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project updated successfully')),
      );

      Navigator.pop(context); // Go back to previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating project: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = MediaQuery.of(context).size.width * 0.05;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Project"),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenPadding),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                label: "Project Title",
                controller: _projectTitleController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Description",
                controller: _descriptionController,
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter a description'
                    : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Timeline",
                controller: _timelineController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a timeline' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Budget",
                controller: _budgetController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a budget' : null,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Location",
                controller: _locationController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a location' : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _updateProject,
                      child: const Text("Save Changes"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
