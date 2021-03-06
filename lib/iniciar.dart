import 'package:flutter/material.dart';

import 'package:musculaquiz/app/model/Usuario.dart';

import 'Home.dart';
import 'package:musculaquiz/app/components/default_background_conteiner.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'app/model/Usuario.dart';
import 'app/utils/config.dart';

import 'package:musculaquiz/Login.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

String _userId = '';

class Partida {
  Partida({this.idpartida, this.idusuario, this.vidas});

  final String idpartida;
  final String idusuario;
  final String vidas;

  factory Partida.fromJson(Map<String, dynamic> json) => Partida(
      idpartida: json["id_partida"],
      idusuario: json["id_usuario"],
      vidas: json["vidas"]);
}

class Iniciar extends StatefulWidget {
  final Usuario dataUsuario;

  Iniciar({this.dataUsuario});

  @override
  _IniciarState createState() => _IniciarState(dataUsuario: dataUsuario);
}

class _IniciarState extends State<Iniciar> {
  final Usuario dataUsuario;

  _IniciarState({this.dataUsuario});

  void initState() {
    super.initState();
    if (this.mounted) {
      setState(() {
        //_email = this.dataUsuario.email;
        _userId = this.dataUsuario.userId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Muscula Quiz"),
          backgroundColor: Color(0xff00A191),
          actions: [
            IconButton(icon: Icon(Icons.logout), onPressed: this._logout),
          ],
        ),
        body: Container(
          child: DefaultBackgroundContainer(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Image.asset(
                        "imagens/logo.png",
                        width: 300,
                        height: 150,
                      ),
                    ),
                    // Espacamento
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(bottom: 9),
                        ),
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 10),
/*                      child: RaisedButton(
                        child: Text(
                          "Iniciar",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        color: Color(0xff006C5D),
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)), */
                      child: ElevatedButton(
                        child: Text(
                          "Iniciar",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          onPrimary: Color(0xff006C5D),
                          primary: Color(0xff006C5D),
                          onSurface: Color(0xff006C5D),
                          // side: BorderSide(color: Colors.black, width: 1),
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),

                          minimumSize: Size(250, 50),
                        ),
                        onPressed: () {
                          CircularProgressIndicator();
                          _iniciaPartida(_userId, '1');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void _iniciaPartida(String pUserId, String pIdCategoria) async {
    print('_iniciaPartida - pIdCategoria : $pIdCategoria');
    try {
      print('pIdCategoria: $pIdCategoria');
      var dataJSon = await http.post(
        Uri.parse(APP_URL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "metodo": "getpartida",
          "id_usuario": "$pUserId",
          "id_categoria": "$pIdCategoria"
        }),
      );
      final jsonMap = jsonDecode(dataJSon.body);
      List<Partida> retPartida;
      retPartida = (jsonMap["partida"] as List)
          .map((partida) => Partida.fromJson(partida))
          .toList();

      final _idPartida = retPartida[0].idpartida;
      final _vidasGame = retPartida[0].vidas;
      dataUsuario.vidas = _vidasGame;
      dataUsuario.idPartida = _idPartida;

/*      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  // iniciar o jogo
                  Home(dataUsuario: dataUsuario))); */
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => Home(dataUsuario: dataUsuario)),
          (Route<dynamic> route) => false);
    } catch (e) {
      return null;
    }
  }

  void _logout() {
    _deleteFile();
    // Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
        (Route<dynamic> route) => false);
  }

  Future<File> _deleteFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File("${directory.path}/MusculaQuiz.json");
      print('apaga arquivo : $file');
      file.delete();
    } catch (e) {
      return null;
    }
  }
}
