import 'package:flutter/material.dart';

class CustomLabels extends StatelessWidget {
  final String textOne;
  final String textTwo;
  final String routeTwo;
  final double heightEspacing;

  const CustomLabels({
    Key? key,
    this.textOne = '¿No tienes cuenta?',
    this.textTwo = 'Crea una ahora!',
    required this.routeTwo,
    this.heightEspacing = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          textOne,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(height: heightEspacing),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, routeTwo);
            print('tap');
          },
          child: Text(
            textTwo,
            style: TextStyle(
              color: Colors.blue[600],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
