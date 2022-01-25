import 'package:flutter/material.dart';

showAlert(BuildContext context, String titulo, String subtitulo) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(titulo),
      content: Text(subtitulo),
      actions: [
        MaterialButton(
          child: const Text('Ok'),
          elevation: 5,
          textColor: Colors.blue,
          onPressed: () => Navigator.pop(context),
        )
      ],
    ),
  );
}

showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
