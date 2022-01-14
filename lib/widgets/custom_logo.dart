import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  final String title;
  final double heightBox;

  const CustomLogo({
    Key? key,
    this.title = 'Messenger',
    this.heightBox = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(top: 40),
        child: Column(
          children: <Widget>[
            const Image(
              image: AssetImage('assets/logo-replikat-innovacion.png'),
            ),
            SizedBox(height: heightBox),
            Text(
              title,
              style: const TextStyle(fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}
