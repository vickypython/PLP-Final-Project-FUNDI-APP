import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String fundiId;
  final String fundiName;

  const ChatScreen({
    super.key,
    required this.fundiId,
    required this.fundiName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _projectTypeController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _timelineController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final chatId = _generateChatId(currentUser.uid, widget.fundiId);

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': currentUser.uid,
      'receiverId': widget.fundiId,
      'message': _messageController.text.trim(),
      'projectType': _projectTypeController.text.trim(),
      'budget': _budgetController.text.trim(),
      'timeline': _timelineController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
    _projectTypeController.clear();
    _budgetController.clear();
    _timelineController.clear();
  }

  String _generateChatId(String userId, String fundiId) {
    return userId.hashCode <= fundiId.hashCode
        ? '$userId-$fundiId'
        : '$fundiId-$userId';
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;
    final chatId = _generateChatId(currentUser!.uid, widget.fundiId);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fundiName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg['senderId'] == currentUser.uid;

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isMe
                              ? Colors.blue[200]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(msg['message'] ?? ''),
                            if (msg['projectType'] != null &&
                                msg['projectType'].isNotEmpty)
                              Text("Type: ${msg['projectType']}"),
                            if (msg['budget'] != null &&
                                msg['budget'].isNotEmpty)
                              Text("Budget: ${msg['budget']}"),
                            if (msg['timeline'] != null &&
                                msg['timeline'].isNotEmpty)
                              Text("Timeline: ${msg['timeline']}"),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Work Request Form
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: "Your Message *",
                    hintText:
                        "Hi! I'm interested in your services for my project...",
                  ),
                ),
                TextField(
                  controller: _projectTypeController,
                  decoration: const InputDecoration(
                    labelText: "Project Type",
                    hintText: "e.g., House construction, Kitchen renovation",
                  ),
                ),
                TextField(
                  controller: _budgetController,
                  decoration: const InputDecoration(
                    labelText: "Budget Range",
                    hintText: "e.g., KSH 100,000 - 200,000",
                  ),
                ),
                TextField(
                  controller: _timelineController,
                  decoration: const InputDecoration(
                    labelText: "Timeline",
                    hintText: "e.g., 2-3 weeks",
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "What happens next?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text("• Your message will be sent to the fundi"),
                const Text("• They typically respond within 2 hours"),
                const Text(
                    "• You can discuss project details and schedule a site visit"),
                const Text(
                    "• Negotiate final terms before starting work"),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _sendMessage,
                        child: const Text("Send Work Request"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
