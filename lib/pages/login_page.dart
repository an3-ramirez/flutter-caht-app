import 'package:chat_app/utils/show_alert.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

/** Services */
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';

/** Custom Widgets */
import 'package:chat_app/widgets/boton_azul.dart';
import 'package:chat_app/widgets/custom_logo.dart';
import 'package:chat_app/widgets/custom_labels.dart';
import 'package:chat_app/widgets/custom_input.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                CustomLogo(),
                _Form(),
                CustomLabels(routeTwo: 'register'),
                Padding(
                  padding: EdgeInsets.only(bottom: 25),
                  child: Text(
                    'Terminos y condiciones de uso',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),

          // TODO: Crear oton
          BotonAzul(
            onPressed: authService.autenticando
                ? null
                : () async {
                    FocusScope.of(context).unfocus();

                    final loginOk = await authService.login(
                        emailCtrl.text.trim(), passCtrl.text.trim());
                    if (loginOk) {
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      // Mostrar alerta
                      showSnackBar(
                          context, 'Las credenciales no son correctas');
                    }
                  },
          )
        ],
      ),
    );
  }
}
