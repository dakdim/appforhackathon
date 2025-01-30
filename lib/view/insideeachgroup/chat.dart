import 'dart:io';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final File? profileImage; // Receive profile image from HomePage

  const ChatPage({super.key, this.profileImage});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  List<String> _messages = [];
  ScrollController _scrollController = ScrollController();
  FocusNode _focusNode = FocusNode(); // FocusNode for the TextField

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(_messageController.text);
      });
      _messageController.clear();
      _scrollToBottom(); // Scroll to bottom after sending the message
      _focusNode.requestFocus(); // Keep focus on the text field
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                  leading: CircleAvatar(
                    backgroundImage: widget.profileImage != null
                        ? FileImage(widget.profileImage!)
                        : AssetImage('assets/default_profile.png')
                            as ImageProvider, // Fallback image
                    radius: 20,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    focusNode: _focusNode, // Attach FocusNode here
                    decoration: const InputDecoration(
                      hintText: "Enter message",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
