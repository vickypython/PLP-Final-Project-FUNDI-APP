import 'package:flutter/material.dart';
import 'package:fundi/screens/home_page.dart';

class PostProject extends StatefulWidget {
  const PostProject({super.key});

  @override
  _PostProjectState createState() => _PostProjectState();
}

class _PostProjectState extends State<PostProject> {
  final _formKey = GlobalKey<FormState>();

  var _projecttitleController;

  var _descriptionController;

  var _timelineController;

  var _budgetController;

  var _locationController;
  final List<String> urgencies = [
    'low priority',
    'Medium priority',
    'High priority',
  ];
  final List<String> categories = [
    'Selected category',
    'Masonary and Foundation',
    'Plumbing',
    'Interior Finishing',
    'Electrial Work'
        'Roofing and carpentry',
  ];
  String? _selectedurgency = "low priority";
  String? _selectedcategory = "Selected category";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        elevation: 0,
        title: const Text(
          "Post New Project ",
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
                  controller: _projecttitleController,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    labelText: 'Project Title*',
                    hintText: 'e.g.,3-Bedroom House Construction',
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
                      return "please enter your cateqory";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                //there is field for cateqory here
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Category*",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  value: _selectedcategory,
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedcategory = value!;
                    });
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? "Please enter category"
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    labelText: "Description*",
                    hintText:
                        'Describe your project requirements material needed and any specific details...',
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
                      return "please enter the project description";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      controller: _budgetController,
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        labelText: 'Budget Range*',
                        hintText: 'e.g.,KSH 100,000-2,000,000',
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
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter your Budget range";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _timelineController,
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        labelText: 'Timeline',
                        hintText: 'e.g.,2-3 weeks',
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
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter your timeline";
                        }

                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                    const SizedBox(width: 12),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Urgency",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      value: _selectedurgency,
                      items: urgencies.map((String urgency) {
                        return DropdownMenuItem<String>(
                          value: urgency,
                          child: Text(urgency),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedurgency = value!;
                        });
                      },
                      validator: (value) => value == null || value.isEmpty
                          ? "Please enter urgency"
                          : null,
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
