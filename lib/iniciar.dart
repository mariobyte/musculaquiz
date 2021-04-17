import 'package:flutter/material.dart';

import 'package:musculaquiz/app/model/Usuario.dart';

import 'Home.dart';
import 'package:musculaquiz/app/components/default_background_conteiner.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'app/model/Usuario.dart';
//mport 'app/model/partida.dart';
import 'app/utils/config.dart';

import 'package:musculaquiz/Login.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

String _email = '';
String _userId = '';

class Partida {
  String vidas;
  String idPartida;
}

final dataPartida = Partida();

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
    setState(() {
      _email = this.dataUsuario.email;
      _userId = this.dataUsuario.userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //title: Text("Classificação"),
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
                      child: RaisedButton(
                        child: Text(
                          "Iniciar",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        color: Color(0xff006C5D),
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
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
        APP_URL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "metodo": "getpartida",
          "id_usuario": "$pUserId",
          "id_categoria": "$pIdCategoria"
        }),
      );
      print('fim -json 1');
      var jsonData = json.decode(dataJSon.body)['partida'];
      print('jsondata: ');
      print(jsonData);

      //    int x = 0;
      var _vidasGame = '';
      var _idPartida = '';
/*
      for (var u in jsonData) {
        print('id_partida: abaixo:');
        print(u['id_partida']);
        print(u['vidas']);
        _vidasGame = u['vidas'];
        _idPartida = u['id_partida'];
        print('143 -iniciar - vidas : $_vidasGame');
        print('144 -oficial - _idPartida : $_idPartida');
        print('fim');
      } */
      _vidasGame = '2';
      _idPartida = '380';

      dataUsuario.vidas = _vidasGame;
      dataUsuario.idPartida = _idPartida;
      print('Go Home - iniciar: _vidas: $_vidasGame');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  // iniciar o jogo
                  Home(dataUsuario: dataUsuario)));

      print('vidas: $_vidasGame');
    } catch (e) {
      return null;
    }
  }

  _logout() {
    _deleteFile();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
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
