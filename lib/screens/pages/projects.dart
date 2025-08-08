import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShowProjects extends StatelessWidget {
  const ShowProjects({super.key});

  Future<void> _deleteProject(BuildContext context, String projectId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Project"),
        content: const Text("Are you sure you want to delete this project?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance.collection('projects').doc(projectId).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Projects"),
        backgroundColor: Colors.blue.shade200,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('projects')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No projects found"));
          }

          final projects = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final doc = projects[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and category
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              data['title'] ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Chip(
                            label: Text(
                              data['category'] ?? '',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white),
                            ),
                            backgroundColor: Colors.blueAccent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data['description'] ?? '',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          Chip(
                            label: Text("Budget: ${data['budget'] ?? ''}"),
                            backgroundColor: Colors.green.shade100,
                          ),
                          Chip(
                            label: Text("Timeline: ${data['timeline'] ?? ''}"),
                            backgroundColor: Colors.orange.shade100,
                          ),
                          Chip(
                            label: Text("Urgency: ${data['urgency'] ?? ''}"),
                            backgroundColor: Colors.red.shade100,
                          ),
                          Chip(
                            label: Text("Location: ${data['location'] ?? ''}"),
                            backgroundColor: Colors.purple.shade100,
                          ),
                        ],
                      ),

                      // Edit/Delete for owner
                      if (currentUser != null && currentUser.uid == data['ownerId'])
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              label: const Text("Edit", style: TextStyle(color: Colors.blue)),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/editProject',
                                  arguments: doc.id,
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              label: const Text("Delete", style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                _deleteProject(context, doc.id);
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
