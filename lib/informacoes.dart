import 'package:flutter/material.dart';
import 'package:musculaquiz/app/model/Usuario.dart';

import 'package:musculaquiz/app/components/default_background_conteiner.dart';
import 'package:musculaquiz/classificacao.dart';

import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class Informacoes extends StatefulWidget {
  final Usuario dataUsuario;

  Informacoes({this.dataUsuario});

  @override
  _InformacoesState createState() =>
      _InformacoesState(dataUsuario: dataUsuario);
}

class _InformacoesState extends State<Informacoes> {
  final Usuario dataUsuario;

  _InformacoesState({this.dataUsuario});

  var _programa = '';
  var _email = '';
  var _userId = '';
  var _nome = '';
  var _nome_usuario = '';
  bool _mostraNovamente = false;

  List _acessoUserList = [];

  void initState() {
    super.initState();
    if (this.mounted) {
      setState(() {
        _email = this.dataUsuario.email;
        _userId = this.dataUsuario.userId;
        _nome = this.dataUsuario.nome;
        _programa = this.dataUsuario.programa;
        print('Informacoes - getAnalise - _email: $_email');
        print('Informacoes - getAnalise - _userId: $_userId');
        print('Informacoes - getAnalise - _nome_usuario: $_nome_usuario');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Regras do MusculaQuiz'),
          backgroundColor: Color(0xff00A191)),
      body: Container(
        child: DefaultBackgroundContainer(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(children: <Widget>[
                  textSection,
                ]),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _mostraNovamente,
                      onChanged: (bool value) {
                        setState(() {
                          _mostraNovamente = value;
                        });
                      },
                    ),
                    Text("Não mostrar novamente")
                  ],
                ),
                Column(children: <Widget>[_continuar(_mostraNovamente)])
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textSection = Container(
      padding: const EdgeInsets.all(8),
      child: Column(children: <Widget>[
        Text(
            '1) Por uma questão de responsabilidade social, o tempo máximo de uso deste App, por dia, foi fixado em 2h.',
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.justify,
            softWrap: true),
        Text(''),
        Text(
            '2) Você inicia o jogo com 2 vidas e a cada 20 acertos você ganha 1 nova vida. Da mesma maneira, a cada erro você perde 1 vida.',
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.justify,
            softWrap: true),
        Text(''),
        Text(
            '3) O tempo para as respostas é definido conforme o nível de dificuldade e número de caracteres das perguntas e respostas.',
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.justify,
            softWrap: true),
        Text(''),
        Text(
            '4) Um alarme é disparado sempre que faltar 30% do tempo para concluir as respostas.',
            style: TextStyle(color: Colors.white, fontSize: 14),
            softWrap: true,
            textAlign: TextAlign.justify),
        Text(''),
        Text(
            '5) A definição dos pontos de cada pergunta baseia-se no nível de dificuldade e no tempo para resposta. Assim, quanto menos tempo você levar para responder corretamente cada pergunta, mais pontos você marcará.',
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.justify,
            softWrap: true),
        Text(''),
        Text(
            '6) Ao final de cada game, você terá acesso ao seu desempenho individual (o seu último resultado comparado ao seu melhor resultado no App) e seu desempenho diante dos outros jogadores (seu melhor resultado comparado ao melhor resultado, entre todos os usuários do App).',
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.justify,
            softWrap: true),
        Text(''),
        Text(
            '7) O App divulga a lista dos “Top 10”, ou seja, os 10 melhores desempenhos no histórico do aplicativo.',
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.justify,
            softWrap: true),
      ]));

  Widget _continuar(bool pMostrarNovamente) {
    if (pMostrarNovamente) {
      Map<String, dynamic> newUser = Map();
      newUser["login"] = _email;
      newUser["idUser"] = _userId;
      newUser["nome"] = _nome;
      newUser["showMensagem"] = 'N';
      _acessoUserList.add(newUser);
      _saveData();
    }
    return Padding(
      padding: EdgeInsets.only(top: 2, bottom: 5),
      child: ElevatedButton(
        child: Text(
          'Continuar',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          onPrimary: Color(0xff006C5D),
          primary: Color(0xff006C5D),
          onSurface: Color(0xff006C5D),
          elevation: 20,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          minimumSize: Size(250, 50),
        ),
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      Classificacao(dataUsuario: dataUsuario)),
              (Route<dynamic> route) => false);
        },
      ),
    );
  }

  Future<File> _getFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      print("${directory.path}/MusculaQuiz.json");
      return File("${directory.path}/MusculaQuiz.json");
    } catch (e) {
      return null;
    }
  }

  Future<File> _saveData() async {
    try {
      String data = json.encode(_acessoUserList);
      final file = await _getFile();
      print('_saveData - Arquivo Salvo : $file');
      return file.writeAsString(data);
    } catch (e) {
      return null;
    }
  }

  Future<File> _deleteData() async {
    try {
      final file = await _getFile();
      return file.delete();
    } catch (e) {
      return null;
    }
  }
}
