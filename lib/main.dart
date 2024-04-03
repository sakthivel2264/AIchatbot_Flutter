import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(ChatbotApp());
}

class ChatbotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final List<String> _messages = [];

  late GenerativeModel _model;

  @override
  void initState() {
    super.initState();
    _initializeGenerativeModel();
  }

  Future<void> _initializeGenerativeModel() async {
    final apiKey = "AIzaSyDKx8QSMBfSKXqK4XijmLMX6h1jDyBgPRg";
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      return;
    }
    _model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  }

  void _sendMessage(String message) async {
    if (message.isNotEmpty) {
      setState(() {
        _messages.add('You: $message');
      });

      final content = [Content.text(message)];
      final response = await _model.generateContent(content);

      setState(() {
        _messages.add('Chatbot: ${response.text}');
      });

      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
