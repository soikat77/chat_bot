import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'chat_messae.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _chatController = TextEditingController();
  final List<ChatMessage> _messages = [];
  ChatGPT? chatGPT;

  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    chatGPT = ChatGPT.instance;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _sendMessage() {
    ChatMessage message =
        ChatMessage(text: _chatController.text, sender: "user");
    setState(() {
      _messages.insert(0, message);
    });

    _chatController.clear();

    final request = CompleteReq(
      prompt: message.text,
      model: kTranslateModelV3,
      max_tokens: 200,
    );
    _subscription = chatGPT!
        .builder('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')
        .onCompleteStream(request: request)
        .listen((response) {
      ChatMessage botMessage =
          ChatMessage(text: response?.choices[0].text ?? " ", sender: 'Bot');

      setState(() {
        _messages.insert(0, botMessage);
      });
    });
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _chatController,
            onSubmitted: (value) => _sendMessage(),
            decoration:
                const InputDecoration.collapsed(hintText: "Send a message"),
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
      body: SafeArea(
        child: Column(children: [
          Flexible(
            child: ListView.builder(
              reverse: true,
              padding: Vx.m8,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
                // return Container(
                //   height: 50,
                //   color: Colors.red,
                // ).p12();
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: context.cardColor,
            ),
            child: _buildTextComposer(),
          )
        ]),
      ),
    );
  }
}
