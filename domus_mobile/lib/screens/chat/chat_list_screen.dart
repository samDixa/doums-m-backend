import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discussions')),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => ListTile(
          leading: const CircleAvatar(child: Icon(Icons.group)),
          title: Text('Subject Group ${index + 1}'),
          subtitle: const Text('Last message: Hello everyone!'),
          onTap: () {},
        ),
      ),
    );
  }
}
