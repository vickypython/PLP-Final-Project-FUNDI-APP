import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fundi/screens/pages/chat_screen.dart';

class FundiListScreen extends StatelessWidget {
  const FundiListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Available Fundis")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'fundi')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No fundis available"));
          }

          final fundis = snapshot.data!.docs;

          return ListView.builder(
            itemCount: fundis.length,
            itemBuilder: (context, index) {
              return FundiCard(
                fundi: fundis[index].data() as Map<String, dynamic>,
                fundiId: fundis[index].id,
              );
            },
          );
        },
      ),
    );
  }
}

class FundiCard extends StatelessWidget {
  final Map<String, dynamic> fundi;
  final String fundiId;

  const FundiCard({super.key, required this.fundi, required this.fundiId});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: fundi['profileImage'] != null
                  ? NetworkImage(fundi['profileImage'])
                  : const AssetImage('assets/images/default1.jpg')
                        as ImageProvider,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fundi['fullname'] ?? 'Unnamed',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Location: ${fundi['location'] ?? 'N/A'}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    "Experience: ${fundi['experience'] ?? '0'} years",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    "Skills: ${(fundi['skills'] as List<dynamic>?)?.join(', ') ?? 'N/A'}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    "Rate: ${fundi['hourlyRate'] ?? 'N/A'}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      if (fundi['verified'] == true)
                        const Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 18,
                        ),
                      if (fundi['available'] == true)
                        const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 18,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.message, color: Colors.blue),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          fundiId: fundiId,
                          fundiName: fundi['fullname'],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
