import 'package:flutter/material.dart';

import 'package:musculaquiz/app/model/Usuario.dart';
//import 'package:musculaquiz/app/utils/resources.dart';

import 'Home.dart';
import 'package:musculaquiz/app/components/default_background_conteiner.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'app/model/Usuario.dart';
import 'app/model/Categorias.dart';
import 'app/utils/config.dart';

import 'package:musculaquiz/Login.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class API {
  static Future getCategorias(String pUserId) async {
    try {
      var dataCategoria = await http.post(
        APP_URL,
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
  var _total_respondidas = '';
  var _total_corretas = '';
  var _total_erradas = '';
  var _percAcertos = '';
  var _percErro = '';
  var _t101_id_usuario = '';
  var _t101_nome = '';
  var _t101_pontos = '';
  var _t102_id_usuario = '';
  var _t102_nome = '';
  var _t102_pontos = '';
  var _t103_id_usuario = '';
  var _t103_nome = '';
  var _t103_pontos = '';
  String _itemCategoria;

  var _categorias = new List<Categorias>();

  void initState() {
    super.initState();
    setState(() {
      _email = this.dataUsuario.email;
      _userId = this.dataUsuario.userId;
      _getAnalise(_userId);
      print('categoria - _email: $_email');
      print('categoria - _userId: $_userId');
      _getCategorias();
      print('teste _categorias : $_categorias');
    });
  }

  String dropDownStringItem = 'Fisiologia';
  String _atividades = '230';
  String _acertos = '210';
  String _erros = '20';

  List<Analise> analiseData;

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
                            'Questões Responditas:  ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _total_respondidas,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      // Acertos
                      Row(
                        children: <Widget>[
                          Text(
                            'Respostas Certas:  ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _total_corretas,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Respostas Erradas:  ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _total_erradas,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '% Acertos :  ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _percAcertos,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '% Erros :  ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _percAcertos,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      Row(
                        children: <Widget>[
                          Text(
                            'Classificação ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ]),
                    Row(
                      children: <Widget>[
                        Text(
                          _t101_pontos + ' - ' + _t101_nome,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          _t102_pontos + ' - ' + _t102_nome,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          _t103_pontos + ' - ' + _t103_nome,
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
                    Row(
                      children: <Widget>[
                        Text(
                          'Categoria:  ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                            hint: new Text("Fisiologia"),
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
                          "Iniciar",
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

  Future<List<Analise>> _getAnalise(String pUserId) async {
    try {
      print('getAnalise');
      var dataAnalise = await http.post(
        APP_URL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "metodo": "getanalise",
          "id_usuario": "$_userId",
        }),
      );
      var jsonMap = json.decode(dataAnalise.body);
      print(jsonMap);
      analiseData = (jsonMap["analise"] as List)
          .map((conteudo) => Analise.fromJson(conteudo))
          .toList();

      _total_respondidas = analiseData[0].total_respondidas;
      _total_corretas = analiseData[0].total_corretas;
      _total_erradas = analiseData[0].total_erradas;
      _percAcertos = analiseData[0].percAcertos;
      _percErro = analiseData[0].percErro;
      _t101_id_usuario = analiseData[0].top10[0].id_usuario;
      _t101_nome = analiseData[0].top10[0].nome;
      _t101_pontos = analiseData[0].top10[0].pontos;
      _t102_id_usuario = analiseData[0].top10[1].id_usuario;
      _t102_nome = analiseData[0].top10[1].nome;
      _t102_pontos = analiseData[0].top10[1].pontos;
      _t103_id_usuario = analiseData[0].top10[2].id_usuario;
      _t103_nome = analiseData[0].top10[2].nome;
      _t103_pontos = analiseData[0].top10[2].pontos;
    } catch (e) {
      print('Erro leitura json - analise');
    }
  }

  _iniciaPartida(String pUserId, String pIdCategoria) async {
    print('_iniciaPartida - pIdCategoria : $pIdCategoria');
    try {
      var dataPartida = await http.post(
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

class Top10 {
  Top10({this.id_usuario, this.nome, this.pontos});

  final String id_usuario;
  final String nome;
  final String pontos;

  factory Top10.fromJson(Map<String, dynamic> json) => Top10(
      id_usuario: json["id_usuario"],
      nome: json["nome"],
      pontos: json["pontos"]);
}

class Analise {
  Analise(
      {this.total_respondidas,
      this.total_corretas,
      this.total_erradas,
      this.percAcertos,
      this.percErro,
      this.top10});

  final String total_respondidas;
  final String total_corretas;
  final String total_erradas;
  final String percAcertos;
  final String percErro;
  final List<Top10> top10;

  factory Analise.fromJson(Map<String, dynamic> json) => Analise(
      total_respondidas: json["total_respondidas"],
      total_corretas: json["total_corretas"],
      total_erradas: json["total_erradas"],
      percAcertos: json["percAcertos"],
      percErro: json["percErro"],
      top10: (json["top10"] as List)
          .map((conteudo) => Top10.fromJson(conteudo))
          .toList());
}

class UsuarioRet {
  final String usu_id;
  final String usu_nome;
  UsuarioRet(this.usu_id, this.usu_nome);
}
