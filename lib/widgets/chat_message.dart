import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:chat_app/services/auth_service.dart';

class ChatMessage extends StatelessWidget {
  final String uid;
  final String texto;
  final DateTime dateTime;
  final AnimationController animationController;

  const ChatMessage({
    Key? key,
    required this.uid,
    required this.texto,
    required this.dateTime,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child:
              uid == authService.usuario.uid ? _myMessage() : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    String timeMessage = DateFormat('hh:mm a').format(dateTime);
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(
          bottom: 5,
          right: 5,
          left: 50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(texto, style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 5),
            Text(
              timeMessage,
              style: const TextStyle(color: Colors.black45, fontSize: 10),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.yellow[50],
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _notMyMessage() {
    String timeMessage = DateFormat('hh:mm a').format(dateTime);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(
          bottom: 5,
          right: 50,
          left: 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(texto, style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 5),
            Text(
              timeMessage,
              style: const TextStyle(color: Colors.black45, fontSize: 10),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
