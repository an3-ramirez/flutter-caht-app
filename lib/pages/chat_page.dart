import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

/** Models */
import 'package:chat_app/models/mensajes_response.dart';

/** Services */
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';

/** Custom widgets */
import 'package:chat_app/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  final List<ChatMessage> _messages = [];

  bool _estaEscribiendo = false;
  bool emojiShowing = false;

  @override
  void initState() {
    super.initState();

    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', _escucharMensaje);
    _cargarHistorial(chatService.usuarioFrom.uid);
  }

  void _cargarHistorial(String usuarioID) async {
    List<Mensaje> chat = await chatService.getChat(usuarioID);

    final history = chat.map(
      (m) => ChatMessage(
        uid: m.de,
        texto: m.mensaje,
        dateTime: m.createdAt,
        animationController: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 0),
        )..forward(),
      ),
    );

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic data) {
    ChatMessage message = ChatMessage(
      uid: data['de'],
      texto: data['mensaje'],
      dateTime: data['createdAt'],
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  _onEmojiSelected(Emoji emoji) {
    _textController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
  }

  _onBackspacePressed() {
    _textController
      ..text = _textController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
  }

  @override
  Widget build(BuildContext context) {
    final usuarioFrom = chatService.usuarioFrom;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff128C7E),
        centerTitle: false,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              //minRadius: 40.0,
              child: Text(
                usuarioFrom.nombre.substring(0, 2),
                style: const TextStyle(fontSize: 15),
              ),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            const SizedBox(width: 8),
            Text(
              usuarioFrom.nombre,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            )
          ],
        ),
        elevation: 1,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/whatsAppBackgroundImg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
                reverse: true,
              ),
            ),
            Container(
              color: Colors.transparent,
              child: _inputChat(),
            ),
            _emojiPicker(),
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            Flexible(
              child: Container(
                  margin: const EdgeInsets.all(3),
                  //padding: const EdgeInsets.all(15),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Stack(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              emojiShowing = !emojiShowing;
                            });
                          },
                          icon: Icon(
                            emojiShowing
                                ? Icons.keyboard
                                : Icons.emoji_emotions,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 15,
                          bottom: 15,
                          left: 45,
                          right: 15,
                        ),
                        child: TextField(
                          controller: _textController,
                          onSubmitted: _handleSubmit,
                          onChanged: (String texto) {
                            setState(() {
                              if (texto.trim().isNotEmpty) {
                                _estaEscribiendo = true;
                              } else {
                                _estaEscribiendo = false;
                              }
                            });
                          },
                          decoration: const InputDecoration.collapsed(
                              hintText: 'Mensaje'),
                          focusNode: _focusNode,
                        ),
                      ),
                    ],
                  )),
            ),
            _btnSend(),
          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto) {
    if (texto.isEmpty) return;

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      uid: authService.usuario.uid,
      texto: texto,
      dateTime: DateTime.now(),
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
    });
    socketService.emit('mensaje-personal', {
      'de': authService.usuario.uid,
      'para': chatService.usuarioFrom.uid,
      'mensaje': texto
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }

  Widget _emojiPicker() {
    return Offstage(
      offstage: !emojiShowing,
      child: SizedBox(
        height: 250,
        child: EmojiPicker(
          onEmojiSelected: (Category category, Emoji emoji) {
            _onEmojiSelected(emoji);
          },
          onBackspacePressed: _onBackspacePressed,
          config: Config(
              columns: 7,
              // Issue: https://github.com/flutter/flutter/issues/28894
              emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
              verticalSpacing: 0,
              horizontalSpacing: 0,
              initCategory: Category.RECENT,
              bgColor: const Color(0xFFF2F2F2),
              indicatorColor: Colors.blue,
              iconColor: Colors.grey,
              iconColorSelected: Colors.blue,
              progressIndicatorColor: Colors.blue,
              backspaceColor: Colors.blue,
              skinToneDialogBgColor: Colors.white,
              skinToneIndicatorColor: Colors.grey,
              enableSkinTones: true,
              showRecentsTab: true,
              recentsLimit: 28,
              noRecentsText: 'No Recents',
              noRecentsStyle:
                  const TextStyle(fontSize: 20, color: Colors.black26),
              tabIndicatorAnimDuration: kTabScrollDuration,
              categoryIcons: const CategoryIcons(),
              buttonMode: ButtonMode.MATERIAL),
        ),
      ),
    );
  }

  Widget _btnSend() {
    return //Boton enviar
        Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: const Color(0xff128C7E),
        borderRadius: BorderRadius.circular(50),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Platform.isIOS
          ? CupertinoButton(
              child: const Text('Enviar'),
              onPressed: _estaEscribiendo
                  ? () => _handleSubmit(_textController.text.trim())
                  : null,
            )
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconTheme(
                data: IconThemeData(color: Colors.blue[400]),
                child: IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _estaEscribiendo
                      ? () => _handleSubmit(_textController.text.trim())
                      : null,
                ),
              ),
            ),
    );
  }
}
