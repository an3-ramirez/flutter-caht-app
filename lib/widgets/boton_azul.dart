import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String textBtn;
  final VoidCallback? onPressed;

  const BotonAzul({
    Key? key,
    this.textBtn = 'Ingresar',
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(
            textBtn,
            style: const TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: const BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
