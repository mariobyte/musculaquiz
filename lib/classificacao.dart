import 'package:flutter/material.dart';

import 'package:musculaquiz/app/model/Usuario.dart';

import 'Home.dart';
import 'package:musculaquiz/app/components/default_background_conteiner.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'app/model/Usuario.dart';

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

  String _atividades = '230';
  String _acertos = '210';
  String _erros = '20';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Classificação"),
          backgroundColor: Color(0xff00A191),
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
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 10),
                      child: RaisedButton(
                        child: Text(
                          "Nova rodada",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        color: Color(0xff006C5D),
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        onPressed: () {
                          //Navigator.pushReplacement(
                          //context,
                          //   MaterialPageRoute(
                          //       builder: (context) =>
                          //           Home(dataUsuario: dataUsuario)));
                          Navigator.pushReplacementNamed(context, "/");
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
}

class UsuarioRet {
  final String usu_id;
  final String usu_nome;
  UsuarioRet(this.usu_id, this.usu_nome);
}
