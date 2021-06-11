import 'package:flutter/material.dart';
import 'package:musculaquiz/app/model/Usuario.dart';
import 'Home.dart';
import 'package:musculaquiz/app/components/default_background_conteiner.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'app/model/Usuario.dart';
import 'app/model/Categorias.dart';
//import 'app/utils/config.dart';

import 'package:musculaquiz/Login.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

class API {
  static Future getCategorias(String pUserId) async {
    try {
      var dataCategoria = await http.post(
        Uri.parse('https://www.cortexvendas.com.br/apiquiz/apiquiz.php'),
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

List<Top10> _top10List = [];

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

  var _programa = '';
  var _email = '';
  var _userId = '';
  var _nome = '';
  var _nome_usuario = '';
  var _total_respondidas = '';
  var _total_corretas = '';
  var _total_erradas = '';
  var _pontos_partida = '';
  var _percAcertos = '';
  double _percAcertoRecord = 0;
  double _percGeralRecord = 0;
  var _percAcertoRecordText = '';
  var _percGeralRecordText = '';
  var _percErro = '';
  var _recorde_usuario = '';
  double _recorde_usuarioI = 0;
  var _data_recorde = '';
  var _recorde_anterior = '';
  var _bateu_recorde = '';
  var _perc_bater_seu_recorde = '';
  var _recorde_geral = '';
  double _recorde_geralI = 0;
  var _perc_bater_recorde_geral = '';
  var _t101_classificacao = '';
  var _t101_id_usuario = '';
  var _t101_nome = '';
  var _t101_pontos = '';
  var _t102_classificacao = '';
  var _t102_id_usuario = '';
  var _t102_nome = '';
  var _t102_pontos = '';
  var _t103_classificacao = '';
  var _t103_id_usuario = '';
  var _t103_nome = '';
  var _t103_pontos = '';
  var _t104_classificacao = '';
  var _t104_id_usuario = '';
  var _t104_nome = '';
  var _t104_pontos = '';
  var _t105_classificacao = '';
  var _t105_id_usuario = '';
  var _t105_nome = '';
  var _t105_pontos = '';
  var _t106_classificacao = '';
  var _t106_nome = '';
  var _t106_pontos = '';
  var _t106_id_usuario = '';
  var _t107_classificacao = '';
  var _t107_id_usuario = '';
  var _t107_nome = '';
  var _t107_pontos = '';
  var _t108_classificacao = '';
  var _t108_id_usuario = '';
  var _t108_nome = '';
  var _t108_pontos = '';
  var _t109_classificacao = '';
  var _t109_id_usuario = '';
  var _t109_nome = '';
  var _t109_pontos = '';
  var _t1010_classificacao = '';
  var _t1010_id_usuario = '';
  var _t1010_nome = '';
  var _t1010_pontos = '';
  int _tmNome = 14;
  String _titulo = "Análise";
  String _tituloBotao = "Nova Partida";
  String _itemCategoria;
  bool _visible1 = true;
  String _mensagem = '';
  String _vidasGame = '2';

  List<Categorias> _categorias;

  void initState() {
    super.initState();
    if (this.mounted) {
      setState(() {
        _email = this.dataUsuario.email;
        _userId = this.dataUsuario.userId;
        _nome = this.dataUsuario.nome;
        _programa = this.dataUsuario.programa;
        _getAnalise(_userId);
        print('classificacao - getAnalise - _email: $_email');
        print('classificacao - getAnalise - _userId: $_userId');
        print('classificacao - getAnalise - _nome_usuario: $_nome_usuario');
        _nome = _nome_usuario;
        //   _getCategorias();
        //  print('teste _categorias : $_categorias');
        print('classificacao - programa: $_programa');
        if (_programa == 'iniciar') {
          _titulo = "Muscula Quiz";
          _tituloBotao = "Iniciar";
          _visible1 = false;
        }
      });
    }
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
        title: Text(_titulo),
        backgroundColor: Color(0xff00A191),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: this._logout),
        ],
      ),
      body: Container(
        child: DefaultBackgroundContainer(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: _seuDesempenho(_visible1),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: _voceRecordGeral(_visible1),
                  ),
                  Visibility(
                      visible: _visible1 == false ? true : false,
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Text('Bem vindo $_nome_usuario!',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal)))),
                  Align(
                    alignment: Alignment.topCenter,
                    child: _patrocinio(),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: _novaPartida(),
                  ),

                  //  Align(alignment: Alignment.topCenter, child: _listTop10())
                  _cabTop10(),
                  _listTop10Card(_t101_classificacao, _t101_pontos, _t101_nome),
                  _listTop10Card(_t102_classificacao, _t102_pontos, _t102_nome),
                  _listTop10Card(_t103_classificacao, _t103_pontos, _t103_nome),
                  _listTop10Card(_t104_classificacao, _t104_pontos, _t104_nome),
                  _listTop10Card(_t105_classificacao, _t105_pontos, _t105_nome),
                  _listTop10Card(_t106_classificacao, _t106_pontos, _t106_nome),
                  _listTop10Card(_t107_classificacao, _t107_pontos, _t107_nome),
                  _listTop10Card(_t108_classificacao, _t108_pontos, _t108_nome),
                  _listTop10Card(_t109_classificacao, _t109_pontos, _t109_nome),
                  _listTop10Card(
                      _t1010_classificacao, _t1010_pontos, _t1010_nome),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cabTop10() {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          "Top 10",
          style: TextStyle(fontSize: 25),
        )),
      ),
      Row(
        children: <Widget>[
          Container(padding: EdgeInsets.only(left: 0.0, top: 1.0))
        ],
      ),
      // Cabeçalho
      Row(children: <Widget>[
        Container(
          width: 30,
        ),
        Container(
          width: 45,
          alignment: Alignment.bottomCenter,
          child: Text(
            'Pontos',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        VerticalDivider(
          width: 5,
          thickness: 5,
        ),
        Container(
          width: 220,
          child: Text(
            'Jogador',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ])
    ]);
  }

  Widget _listTop10Card(String pClassificacao, String pPontos, String pNome) {
    return Center(
        child: Card(
            elevation: 5,
            color: Colors.transparent,
            child: Row(children: <Widget>[
              Container(
                width: 30,
                child: Text(
                  pClassificacao,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ),
              ),
              Container(
                width: 45,
                alignment: Alignment.bottomCenter,
                child: Text(
                  pPontos,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ),
              ),
              VerticalDivider(
                width: 5,
                thickness: 5,
              ),
              Container(
                width: 210,
                child: Text(
                  pNome,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ])));
  }

  Widget _seuDesempenho(bool pVisible) {
    if (pVisible) {
      return Visibility(
          visible: pVisible,
          child: Column(children: [
            Row(
              children: <Widget>[
                Text('Seu desempenho $_nome_usuario',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            ),
            Row(children: [
              LinearPercentIndicator(
                width: MediaQuery.of(context).size.width - 50,
                animation: true,
                lineHeight: 25.0,
                animationDuration: 2000,
                percent: _percAcertoRecord,
                center: Text(_percAcertoRecordText + '%'),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Colors.greenAccent,
              ),
              Row(children: [Text(' ' + _recorde_usuarioI.toStringAsFixed(0))]),
            ]),
            Row(
              children: <Widget>[
                Text(
                  'em ' + _data_recorde,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
          ]));
    } else {
      return Padding(
        padding: EdgeInsets.only(bottom: 0),
        child: Image.asset(
          "imagens/logo.png",
          width: 200,
          height: 100,
        ),
      );
    }
  }

  Widget _voceRecordGeral(bool pVisible) {
    if (pVisible) {
      return Visibility(
          visible: pVisible,
          child: Column(children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  //'Você x Recorde geral',
                  '$_nome_usuario x Recorde geral',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            ),
            //     ),
            Row(children: [
              LinearPercentIndicator(
                width: MediaQuery.of(context).size.width - 50,
                animation: true,
                lineHeight: 25.0,
                animationDuration: 2000,
                percent: _percGeralRecord,
                center: Text(_percGeralRecordText + '%'),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Colors.greenAccent,
              ),
              Row(children: [Text(' ' + _recorde_geralI.toStringAsFixed(0))]),
            ]),
            Row(
              children: <Widget>[
                Container(padding: EdgeInsets.only(left: 0.0, top: 1.0))
              ],
            ),
          ]));
    }
  }

  Widget _novaPartida() {
    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 10),
      child: ElevatedButton(
        child: Text(
          _tituloBotao,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          onPrimary: Color(0xff006C5D),
          primary: Color(0xff006C5D),
          onSurface: Color(0xff006C5D),
          // side: BorderSide(color: Colors.black, width: 1),
          elevation: 20,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),

          minimumSize: Size(250, 50),
        ),
        onPressed: () {
          if (_itemCategoria == null) {
            _itemCategoria = '1';
          }
          _iniciaPartida(_userId, _itemCategoria);
        },
      ),
    );
  }

  Widget _listTop10() {
    return CustomScrollView(
      shrinkWrap: true,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    "Top 10",
                    style: TextStyle(fontSize: 25),
                  )),
                ),
                Row(
                  children: <Widget>[
                    Container(padding: EdgeInsets.only(left: 0.0, top: 1.0))
                  ],
                ),
                // Cabeçalho
                Row(children: <Widget>[
                  Container(
                    width: 30,
                  ),
                  Container(
                    width: 45,
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Pontos',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  VerticalDivider(
                    width: 5,
                    thickness: 5,
                  ),
                  Container(
                    width: 220,
                    child: Text(
                      'Jogador',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),

                // Linha 1
                Row(children: <Widget>[
                  Container(
                    width: 30,
                    child: Text(_t101_classificacao),
                  ),
                  Container(
                    width: 45,
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      _t101_pontos,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ),
                  VerticalDivider(
                    width: 5,
                    thickness: 5,
                  ),
                  Container(
                    width: 210,
                    child: Text(
                      _t101_nome,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ),
                ]),
                // Linha 2
                Row(children: <Widget>[
                  Container(
                    width: 30,
                    child: Text(_t102_classificacao),
                  ),
                  Container(
                    width: 45,
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      _t102_pontos,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ),
                  VerticalDivider(
                    width: 5,
                    thickness: 5,
                  ),
                  Container(
                    width: 210,
                    child: Text(
                      _t102_nome,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ),
                ]),
                // Linha 3
                Row(children: <Widget>[
                  Container(
                    width: 30,
                    child: Text(_t103_classificacao),
                  ),
                  Container(
                    width: 45,
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      _t103_pontos,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ),
                  VerticalDivider(
                    width: 5,
                    thickness: 5,
                  ),
                  Container(
                    width: 210,
                    child: Text(
                      _t103_nome,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ),
                ]),
                // Linha 4
                Row(children: <Widget>[
                  Container(
                    width: 30,
                    child: Text(_t104_classificacao),
                  ),
                  Container(
                    width: 45,
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      _t104_pontos,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ),
                  VerticalDivider(
                    width: 5,
                    thickness: 5,
                  ),
                  Container(
                    width: 210,
                    child: Text(
                      _t104_nome,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ),
                ]),
                // Linha 5
                Row(children: <Widget>[
                  Container(
                    width: 30,
                    child: Text(_t105_classificacao),
                  ),
                  Container(
                    width: 45,
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      _t105_pontos,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ),
                  VerticalDivider(
                    width: 5,
                    thickness: 5,
                  ),
                  Container(
                    width: 210,
                    child: Text(
                      _t105_nome,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ),
                ]),
                // Linha 6
                Row(children: <Widget>[
                  Container(
                    width: 30,
                    child: Text(_t106_classificacao),
                  ),
                  Container(
                    width: 45,
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      _t106_pontos,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ),
                  VerticalDivider(
                    width: 5,
                    thickness: 5,
                  ),
                  Container(
                    width: 210,
                    child: Text(
                      _t106_nome,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ),
                ]),
                // Linha 7
                Row(children: <Widget>[
                  Container(
                    width: 30,
                    child: Text(_t107_classificacao),
                  ),
                  Container(
                    width: 45,
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      _t107_pontos,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ),
                  VerticalDivider(
                    width: 5,
                    thickness: 5,
                  ),
                  Container(
                    width: 210,
                    child: Text(
                      _t107_nome,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ),
                ]),
                // Linha 8
                Row(children: <Widget>[
                  Container(
                    width: 30,
                    child: Text(_t108_classificacao),
                  ),
                  Container(
                    width: 45,
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      _t108_pontos,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ),
                  VerticalDivider(
                    width: 5,
                    thickness: 5,
                  ),
                  Container(
                    width: 210,
                    child: Text(
                      _t108_nome,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ),
                ]),
                // Linha 9
                Row(children: <Widget>[
                  Container(
                    width: 30,
                    child: Text(_t109_classificacao),
                  ),
                  Container(
                    width: 45,
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      _t109_pontos,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ),
                  VerticalDivider(
                    width: 5,
                    thickness: 5,
                  ),
                  Container(
                    width: 210,
                    child: Text(
                      _t109_nome,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ),
                ]),
                // Linha 10
                Row(children: <Widget>[
                  Container(
                    width: 30,
                    child: Text(_t1010_classificacao),
                  ),
                  Container(
                    width: 45,
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      _t1010_pontos,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ),
                  VerticalDivider(
                    width: 5,
                    thickness: 5,
                  ),
                  Container(
                    width: 210,
                    child: Text(
                      _t1010_nome,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ),
                ]),
                // Fim
              ],
            ),
          ),
        ),
      ],
    );
  }

  _getCategorias() async {
    try {
      API.getCategorias(_userId).then((response) {
        if (this.mounted) {
          setState(() {
            Iterable list = json.decode(response.body)['categorias'];
            _categorias =
                list.map((model) => Categorias.fromJson(model)).toList();
          });
        }
      });
    } catch (e) {
      return null;
    }
  }

  Future<List<Analise>> _getAnalise(String pUserId) async {
    try {
      print('getAnalise');
      var dataAnalise = await http.post(
        Uri.parse('https://www.cortexvendas.com.br/apiquiz/apiquiz.php'),
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

      if (analiseData.length > 0) {
        if (this.mounted) {
          setState(() {
            _nome_usuario = analiseData[0].nome_usuario;
            print('nome_usuario: $_nome_usuario');
            _total_respondidas = analiseData[0].total_respondidas;
            _total_corretas = analiseData[0].total_corretas;
            _total_erradas = analiseData[0].total_erradas;
            _pontos_partida = analiseData[0].pontos_partida;
            _percAcertos = analiseData[0].percAcertos;
            _percErro = analiseData[0].percErro;
            _recorde_usuario = analiseData[0].recorde_usuario;
            _data_recorde = analiseData[0].data_recorde;
            _recorde_anterior = analiseData[0].recorde_anterior;
            _bateu_recorde = analiseData[0].bateu_recorde;
            _perc_bater_seu_recorde = analiseData[0].perc_bater_seu_recorde;
            _recorde_geral = analiseData[0].recorde_geral;
            _perc_bater_recorde_geral = analiseData[0].perc_bater_recorde_geral;
            var _tamanho = analiseData[0].top10.length;
            if (_tamanho > 0) {
              _t101_classificacao = '1º';
              _t101_id_usuario = analiseData[0].top10[0].id_usuario;
              _t101_nome = analiseData[0].top10[0].nome;
              _t101_pontos = analiseData[0].top10[0].pontos;
            }
            if (_tamanho > 1) {
              _t102_classificacao = '2º';
              _t102_id_usuario = analiseData[0].top10[1].id_usuario;
              _t102_nome = analiseData[0].top10[1].nome;
              _t102_pontos = analiseData[0].top10[1].pontos;
            }
            if (_tamanho > 2) {
              _t103_classificacao = '3º';
              _t103_id_usuario = analiseData[0].top10[2].id_usuario;
              _t103_nome = analiseData[0].top10[2].nome;
              _t103_pontos = analiseData[0].top10[2].pontos;
            }
            if (_tamanho > 3) {
              _t104_classificacao = '4º';
              _t104_id_usuario = analiseData[0].top10[3].id_usuario;
              _t104_nome = analiseData[0].top10[3].nome;
              _t104_pontos = analiseData[0].top10[3].pontos;
            }
            if (_tamanho > 4) {
              _t105_classificacao = '5º';
              _t105_id_usuario = analiseData[0].top10[4].id_usuario;
              _t105_nome = analiseData[0].top10[4].nome;
              _t105_pontos = analiseData[0].top10[4].pontos;
            }
            if (_tamanho > 5) {
              _t106_classificacao = '6º';
              _t106_id_usuario = analiseData[0].top10[5].id_usuario;
              _t106_nome = analiseData[0].top10[5].nome;
              _t106_pontos = analiseData[0].top10[5].pontos;
            }
            if (_tamanho > 6) {
              _t107_classificacao = '7º';
              _t107_id_usuario = analiseData[0].top10[6].id_usuario;
              _t107_nome = analiseData[0].top10[6].nome;
              _t107_pontos = analiseData[0].top10[6].pontos;
            }
            if (_tamanho > 7) {
              _t108_classificacao = '8º';
              _t108_id_usuario = analiseData[0].top10[7].id_usuario;
              _t108_nome = analiseData[0].top10[7].nome;
              _t108_pontos = analiseData[0].top10[7].pontos;
            }
            if (_tamanho > 8) {
              _t109_classificacao = '9º';
              _t109_id_usuario = analiseData[0].top10[8].id_usuario;
              _t109_nome = analiseData[0].top10[8].nome;
              _t109_pontos = analiseData[0].top10[8].pontos;
            }
            if (_tamanho > 9) {
              _t1010_classificacao = '10º';
              _t1010_id_usuario = analiseData[0].top10[9].id_usuario;
              _t1010_nome = analiseData[0].top10[9].nome;
              _t1010_pontos = analiseData[0].top10[9].pontos;
            }
            // forçando o teste
            print('_pontos_partida: $_pontos_partida');
            print('_recorde_usuario: $_recorde_usuario');
            //  _pontos_partida = '20';
            //  _recorde_usuario = '50';
            _recorde_usuarioI = double.parse(_recorde_usuario);
            try {
              if (double.parse(_recorde_usuario) > 0 &&
                  double.parse(_pontos_partida) > 0) {
                _percAcertoRecord = double.parse(_pontos_partida) /
                    double.parse(_recorde_usuario);
                var _var = (_percAcertoRecord).toStringAsFixed(1);
                _percAcertoRecord = double.parse(_var);
              } else {
                _visible1 = false;
                _percAcertoRecord = 1.0;
              }
            } catch (e) {
              _visible1 = false;
              _percAcertoRecord = 1.0;
              print('calcula - _percAcertoRecord - try - saida');
            }

            _percAcertoRecordText =
                (_percAcertoRecord * 100).toStringAsFixed(0);

            // Calculo Recorde Geral
            print('_perc_bater_recorde_geral: $_perc_bater_recorde_geral');
            //_recorde_geralI = double.parse(_recorde_geral);
/*            try {
              _percGeralRecord = double.parse(_perc_bater_recorde_geral) / 100;
              _percGeralRecordText = _perc_bater_recorde_geral;
            } catch (e) {
              _visible1 = false;
            } */

            try {
              if (double.parse(_recorde_geral) > 0 &&
                  double.parse(_pontos_partida) > 0) {
                _percGeralRecord = double.parse(_pontos_partida) /
                    double.parse(_recorde_geral);
                var _var = (_percGeralRecord).toStringAsFixed(1);
                _percGeralRecord = double.parse(_var);
              } else {
                _percGeralRecord = 1.0;
                _visible1 = false;
              }
            } catch (e) {
              _percGeralRecord = 1.0;
              _visible1 = false;
              print('calcula - _percGeralRecord - try - saida');
            }
            _percGeralRecordText = (_percGeralRecord * 100).toStringAsFixed(0);
          });
        }
      }
    } catch (e) {
      print('Erro leitura json - analise');
    }
  }

/*  _iniciaPartida(String pUserId, String pIdCategoria) async {
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
  } */

  void _iniciaPartida(String pUserId, String pIdCategoria) async {
    print('Classificacao : _iniciaPartida - pIdCategoria : $pIdCategoria');
    try {
      var dataJSon = await http.post(
        Uri.parse('https://www.cortexvendas.com.br/apiquiz/apiquiz.php'),
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
      _vidasGame = retPartida[0].vidas;
      dataUsuario.email = _email;
      dataUsuario.userId = _userId;
      dataUsuario.vidas = _vidasGame;
      dataUsuario.idPartida = _idPartida;
      dataUsuario.userIdMQ = '';
      dataUsuario.programa = 'Classificacao';
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

  Widget _patrocinio() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Card(
              color: Colors.green,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.network(
                          'https://cortexsolucoes.com.br/wp-content/uploads/2020/06/Logo-C%C3%B3rtex-Solu%C3%A7%C3%B5es-transp-3-300x157.png',
                          height: 60,
                          width: 70),
                      Text(
                        "Córtex Soluções - Patrocinador oficial",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        "https://www.cortexsolucoes.com.br",
                        style: TextStyle(fontSize: 16),
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _logout() {
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
      {this.nome_usuario,
      this.total_respondidas,
      this.total_corretas,
      this.total_erradas,
      this.percAcertos,
      this.percErro,
      this.pontos_partida,
      this.recorde_usuario,
      this.data_recorde,
      this.recorde_anterior,
      this.bateu_recorde,
      this.perc_bater_seu_recorde,
      this.recorde_geral,
      this.perc_bater_recorde_geral,
      this.top10});

  final String nome_usuario;
  final String total_respondidas;
  final String total_corretas;
  final String total_erradas;
  final String percAcertos;
  final String percErro;
  final String pontos_partida;
  final String recorde_usuario;
  final String data_recorde;
  final String recorde_anterior;
  final String bateu_recorde;
  final String perc_bater_seu_recorde;
  final String recorde_geral;
  final String perc_bater_recorde_geral;
  final List<Top10> top10;

  factory Analise.fromJson(Map<String, dynamic> json) => Analise(
      nome_usuario: json["nome_usuario"],
      total_respondidas: json["total_respondidas"],
      total_corretas: json["total_corretas"],
      total_erradas: json["total_erradas"],
      percAcertos: json["percAcertos"],
      percErro: json["percErro"],
      pontos_partida: json["pontos_partida"],
      recorde_usuario: json["recorde_usuario"],
      data_recorde: json['data_recorde'],
      recorde_anterior: json["recorde_anterior"],
      bateu_recorde: json["bateu_recorde"],
      perc_bater_seu_recorde: json["perc_bater_seu_recorde"],
      recorde_geral: json["recorde_geral"],
      perc_bater_recorde_geral: json["perc_bater_recorde_geral"],
      top10: (json["top10"] as List)
          .map((conteudo) => Top10.fromJson(conteudo))
          .toList());
}
