import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  Widget _buildTextComposer() {
    return Row(
      children: [
        const Expanded(
          child: TextField(
            decoration: InputDecoration.collapsed(hintText: "Send a message"),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.send),
        ),
      ],
    ).px16();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Bot'),
      ),
      body: Column(children: [
        Container(
          decoration: BoxDecoration(
            color: context.cardColor,
          ),
          child: _buildTextComposer(),
        )
      ]),
    );
  }
}
