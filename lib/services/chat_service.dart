import 'package:chat_app/models/mensajes_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/global/environment.dart';

/** Services */
import 'package:chat_app/services/auth_service.dart';

class ChatService with ChangeNotifier {
  late Usuario usuarioFrom;

  Future getChat(String usuarioID) async {
    var url = Uri.parse('${Environment.apiUrl}/mensajes/$usuarioID');
    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken() ?? '',
    });

    final mensajesResp = mensajesResponseFromJson(resp.body);

    return mensajesResp.mensajes;
  }
}
