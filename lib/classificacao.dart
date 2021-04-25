import 'package:flutter/material.dart';
import 'package:musculaquiz/app/model/Usuario.dart';
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
import 'package:percent_indicator/percent_indicator.dart';

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

  var _email = '';
  var _userId = '';
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
  var _data_recorde = '';
  var _recorde_anterior = '';
  var _bateu_recorde = '';
  var _perc_bater_seu_recorde = '';
  var _recorde_geral = '';
  var _perc_bater_recorde_geral = '';
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
//            child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Meu progresso',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: new LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 50,
                      animation: true,
                      lineHeight: 50.0,
                      animationDuration: 2000,
                      percent: _percAcertoRecord,
                      center: Text(_percAcertoRecordText),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Colors.greenAccent,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        _data_recorde,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.normal),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Classificação Geral',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: new LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 50,
                      animation: true,
                      lineHeight: 50.0,
                      animationDuration: 2000,
                      percent: _percGeralRecord,
                      center: Text(_percGeralRecordText),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Colors.greenAccent,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(padding: EdgeInsets.only(left: 0.0, top: 5.0))
                    ],
                  ),
                ]),
                Row(
                  children: <Widget>[
                    Text(
                      'Classificação ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(padding: EdgeInsets.only(left: 0.0, top: 5.0))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      _t101_pontos + ' - ' + _t101_nome,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      _t102_pontos + ' - ' + _t102_nome,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      _t103_pontos + ' - ' + _t103_nome,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                SizedBox(
                  width: 70.0,
                  height: 120.0,
                  child: const Card(
                      child: Text(
                    'Cole aqui seu Anuncio',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
                  )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
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
/*                  child: RaisedButton(
                    child: Text(
                      "Iniciar",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    color: Color(0xff006C5D),
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)), */
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
    );
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

      if (analiseData.length > 0) {
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
        print('tamanho top10 > $_tamanho');
        /*_t101_id_usuario = analiseData[0].top10[0].id_usuario;
        _t101_nome = analiseData[0].top10[0].nome;
        _t101_pontos = analiseData[0].top10[0].pontos;
        _t102_id_usuario = analiseData[0].top10[1].id_usuario;
        _t102_nome = analiseData[0].top10[1].nome;
        _t102_pontos = analiseData[0].top10[1].pontos;
        _t103_id_usuario = analiseData[0].top10[2].id_usuario;
        _t103_nome = analiseData[0].top10[2].nome;
        _t103_pontos = analiseData[0].top10[2].pontos; */
        if (_tamanho > 0) {
          _t101_id_usuario = analiseData[0].top10[0].id_usuario;
          _t101_nome = analiseData[0].top10[0].nome;
          _t101_pontos = analiseData[0].top10[0].pontos;
        } else {
          if (_tamanho > 1) {
            _t102_id_usuario = analiseData[0].top10[1].id_usuario;
            _t102_nome = analiseData[0].top10[1].nome;
            _t102_pontos = analiseData[0].top10[1].pontos;
          } else {
            if (_tamanho > 2) {
              _t103_id_usuario = analiseData[0].top10[2].id_usuario;
              _t103_nome = analiseData[0].top10[2].nome;
              _t103_pontos = analiseData[0].top10[2].pontos;
            }
          }
        }

        // forçando o teste
        print('_pontos_partida: $_pontos_partida');
        print('_recorde_usuario: $_recorde_usuario');
        //  _pontos_partida = '20';
        //  _recorde_usuario = '50';

        if (double.parse(_recorde_usuario) > 0 &&
            double.parse(_pontos_partida) > 0) {
          _percAcertoRecord =
              double.parse(_pontos_partida) / double.parse(_recorde_usuario);
          var _var = (_percAcertoRecord).toStringAsFixed(1);
          _percAcertoRecord = double.parse(_var);
        } else {
          _percAcertoRecord = 1.0;
        }

        _percAcertoRecordText = (_percAcertoRecord * 100).toString();

        print('_recorde_geral: $_recorde_geral');
        //_pontos_partida = '20';
        //_recorde_geral = '41';

        if (double.parse(_recorde_geral) > 0 &&
            double.parse(_pontos_partida) > 0) {
          _percGeralRecord =
              double.parse(_pontos_partida) / double.parse(_recorde_geral);
          var _var = (_percGeralRecord).toStringAsFixed(1);
          _percGeralRecord = double.parse(_var);
        } else {
          _percGeralRecord = 1.0;
        }
        _percGeralRecordText = (_percGeralRecord * 100).toString();
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
      final jsonMap = jsonDecode(dataJSon.body);
      List<Partida> retPartida;
      retPartida = (jsonMap["partida"] as List)
          .map((partida) => Partida.fromJson(partida))
          .toList();

      final _idPartida = retPartida[0].idpartida;
      final _vidasGame = retPartida[0].vidas;
      dataUsuario.vidas = _vidasGame;
      dataUsuario.idPartida = _idPartida;

      print('Go Home - iniciar: _vidas: $_vidasGame');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  // iniciar o jogo
                  Home(dataUsuario: dataUsuario)));
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
      {this.total_respondidas,
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
