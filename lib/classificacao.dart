import 'package:flutter/material.dart';

import 'package:musculaquiz/app/model/Usuario.dart';
import 'package:musculaquiz/app/utils/resources.dart';

import 'Home.dart';
import 'package:musculaquiz/app/components/default_background_conteiner.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'app/model/Usuario.dart';
import 'app/model/Categorias.dart';

import 'package:musculaquiz/Login.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class API {
  static Future getCategorias(String pUserId) async {
    try {
      var dataCategoria = await http.post(
        'https://cortexvendas.com.br/apiquiz/apiquiz.php',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "metodo": "getcategorias",
          "id_usuario": "$pUserId"
        }),
      );
      return dataCategoria;
    } catch (e) {
      return null;
    }
  }
}

class Classificacao extends StatefulWidget {
  final Usuario dataUsuario;

  Classificacao({this.dataUsuario});

  @override
  _ClassificacaoState createState() =>
      _ClassificacaoState(dataUsuario: dataUsuario);
}

class _ClassificacaoState extends State<Classificacao> {
  final Usuario dataUsuario;

  _ClassificacaoState({this.dataUsuario});

  var _email = '';
  var _userId = '';
  String _itemCategoria;

  var _categorias = new List<Categorias>();

  void initState() {
    super.initState();
    setState(() {
      _email = this.dataUsuario.email;
      _userId = this.dataUsuario.userId;
      print('categoria - _email: $_email');
      print('categoria - _userId: $_userId');
      _getCategorias();
      print('teste _categorias : $_categorias');
    });
  }

//  var _categorias = new List<ListCategoria>();

  String dropDownStringItem = 'Musculação';
  String _atividades = '230';
  String _acertos = '210';
  String _erros = '20';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //title: Text("Classificação"),
          title: Text("Analise"),
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
                    Column(children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'Atividades:  ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _atividades,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(bottom: 30),
                          ),
                        ],
                      ),
                      // Centro de Custo
                      Row(
                        children: <Widget>[
                          Text(
                            'Acertos:  ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _acertos,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Erros:  ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _erros,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ]),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(bottom: 30),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Categoria:  ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                            hint: new Text("Musculação"),
                            isDense: true,
                            items: _categorias.map((Categorias map) {
                              return new DropdownMenuItem<String>(
                                value: map.id_categoria, //+map.cat_descricao,
                                child: new Text(map.cat_descricao,
                                    style: new TextStyle(
                                        fontSize: 16, color: Colors.black)),
                              );
                            }).toList(),
                            onChanged: (String newValue) {
                              setState(() {
                                _itemCategoria = newValue;
                              });
                            },
                            value: _itemCategoria,
                          ),
                        ),
                      ],
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
                          "Vamos treinar?",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        color: Color(0xff006C5D),
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        onPressed: () {
                          print('_itemCategoria: $_itemCategoria');
                          if (_itemCategoria == null) {
                            _itemCategoria = '1';
                          }
                          _iniciaPartida(_userId, _itemCategoria);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Home(dataUsuario: dataUsuario)));
                          //                         Navigator.pushReplacementNamed(context, "/");
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

  _getCategorias() async {
    try {
      API.getCategorias(_userId).then((response) {
        setState(() {
          Iterable list = json.decode(response.body)['categorias'];
          _categorias =
              list.map((model) => Categorias.fromJson(model)).toList();
        });
      });
    } catch (e) {
      return null;
    }
  }

  _iniciaPartida(String pUserId, String pIdCategoria) async {
    print('_iniciaPartida - pIdCategoria : $pIdCategoria');
    try {
      var dataPartida = await http.post(
        'https://cortexvendas.com.br/apiquiz/apiquiz.php',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "metodo": "getpartida",
          "id_usuario": "$pUserId",
          "id_categoria": "$pIdCategoria"
        }),
      );
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

class UsuarioRet {
  final String usu_id;
  final String usu_nome;
  UsuarioRet(this.usu_id, this.usu_nome);
}
