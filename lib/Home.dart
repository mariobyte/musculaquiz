import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'app/components/default_background_conteiner.dart';
import 'app/model/Usuario.dart';
import 'app/utils/config.dart';
import 'classificacao.dart';

class Home extends StatefulWidget {
  final Usuario dataUsuario;

  Home({this.dataUsuario});

  @override
  _HomeState createState() => _HomeState(dataUsuario: dataUsuario);
}

class _HomeState extends State<Home> {
  final Usuario dataUsuario;

  _HomeState({this.dataUsuario});

  FirebaseAuth auth = FirebaseAuth.instance;

  List<Perguntas> perguntas;

  String _pergunta = '';
  String _idPergunta = '';
  int _resposta = -1;
  String _tempoResp = '';

  int _controlePerguntas = 0;

  var _respostas = new List(5);
  var _idResposta = new List(5);
  var _respCerta = new List(5);

  var _email = '';
  var _userId = '';
  var _userIdMQ = '';

  void initState() {
    super.initState();
    setState(() {
      _respostas[0] = '';
      _respostas[1] = '';
      _respostas[2] = '';
      _respostas[3] = '';
      _respostas[4] = '';
      _email = this.dataUsuario.email;
      _userId = this.dataUsuario.userId;
      _userIdMQ = this.dataUsuario.userIdMQ;
      print('passo 1 - antes getperguntas');
      _getPerguntas();
    });
  }

  _classificacao() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Classificacao(dataUsuario: dataUsuario)));
  }

  _tempoResposta(int pCounter) {
    _counter = pCounter;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
          print('_counter: $_counter');
        } else {
          //  _showAlertDialog(context, ' Tempo Esgotado!');
          _showMyDialog(' Tempo Esgotado!');
          _timer.cancel();
        }
      });
    });
  }

  Timer _timer;
  int _counter = 0;
  int _groupValue = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Muscula Quiz"),
        ),
        body: Container(
          child: DefaultBackgroundContainer(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    //   _tempoResposta(),
                    Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 10),
                        child: _formUI()),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _formUI() {
    return Column(children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.end,
            //   crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: 80,
                child: Text('$_counter',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    textAlign: TextAlign.right),
              )
            ]),
      ),
      Container(
        width: 300.0,
        child: Column(children: <Widget>[
          Text(
            _pergunta,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ]),
      ),
      Column(
        children: <Widget>[
          _myRadioButton(
            title: _respostas[0],
            value: 0,
            onChanged: (newValue) => setState(() => _resposta = newValue),
          ),
          _myRadioButton(
            title: _respostas[1],
            value: 1,
            onChanged: (newValue) => setState(() => _resposta = newValue),
          ),
          _myRadioButton(
            title: _respostas[2],
            value: 2,
            onChanged: (newValue) => setState(() => _resposta = newValue),
          ),
          _myRadioButton(
            title: _respostas[3],
            value: 3,
            onChanged: (newValue) => setState(() => _resposta = newValue),
          ),
          _myRadioButton(
            title: _respostas[4],
            value: 4,
            onChanged: (newValue) => setState(() => _resposta = newValue),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(bottom: 50),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          Container(
            width: 100.0,
            alignment: AlignmentDirectional.center,
          ),
          Container(
            width: 160.0,
            alignment: AlignmentDirectional.center,
            child: RaisedButton(
                child: Text(
                  "Proxima",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Color(0xff006C5D),
                padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                onPressed: () {
                  print('_resposta: $_resposta');
                  _proximaPergunta(_resposta);
                  _resposta = -1;
                }),
          )
        ],
      )
    ]);
  }

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _resposta,
      onChanged: onChanged,
      title: Text(title),
    );
  }

  // Minhas Perguntas
  Future<List<Perguntas>> _getPerguntas() async {
    List<Perguntas> _listPerguntas = [];
    try {
      var data = await http.post(
        APP_URL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "metodo": "getperguntas",
          "id_usuario": "$_userId",
          "email": "$_email"
        }),
        //"email": "$_email"
      );
      print("_getPerguntas - _userId: $_userId");
      print("_getPerguntas - _email: $_email");
      var jsonMap = json.decode(data.body);
      //List<Perguntas> perguntas;
      perguntas = (jsonMap["perguntas"] as List)
          .map((pergunta) => Perguntas.fromJson(pergunta))
          .toList();

      _pergunta = perguntas[0].per_descricao;
      _idPergunta = perguntas[0].id_pergunta;
      _tempoResp = perguntas[0].per_tempo;
      _idResposta[0] = perguntas[0].respostas[0].id_resposta;
      _idResposta[1] = perguntas[0].respostas[1].id_resposta;
      _idResposta[2] = perguntas[0].respostas[2].id_resposta;
      _idResposta[3] = perguntas[0].respostas[3].id_resposta;
      _idResposta[4] = perguntas[0].respostas[4].id_resposta;
      _respostas[0] = perguntas[0].respostas[0].res_descricao;
      _respostas[1] = perguntas[0].respostas[1].res_descricao;
      _respostas[2] = perguntas[0].respostas[2].res_descricao;
      _respostas[3] = perguntas[0].respostas[3].res_descricao;
      _respostas[4] = perguntas[0].respostas[4].res_descricao;
      _respCerta[0] = perguntas[0].respostas[0].res_certa;
      _respCerta[1] = perguntas[0].respostas[1].res_certa;
      _respCerta[2] = perguntas[0].respostas[2].res_certa;
      _respCerta[3] = perguntas[0].respostas[3].res_certa;
      _respCerta[4] = perguntas[0].respostas[4].res_certa;
      _controlePerguntas = 0;
      setState(() {
        _tempoResposta(int.parse(_tempoResp));
      });
    } catch (e) {}
    return _listPerguntas;
  }
  // Perguntas

  Future<List<Perguntas>> _postRespostas(
      String pidPergunta, String pidResposta, String pTempo) async {
    try {
      print('_postRespostas - cheguei - passo 0');
      var dataResposta = await http.post(
        APP_URL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "metodo": "getrespostas",
          "id_usuario": "$_userId",
          "id_pergunta": "$pidPergunta",
          "id_resposta": "$pidResposta",
          "res_tempo": "$pTempo"
        }),
      );

      var jsonData = json.decode(dataResposta.body);
      print('_postRespostas - Json de Retorno:  $jsonData');
      List<RetRespostas> _listRespostas = [];
      int x = 0;
      for (var u in jsonData) {
        RetRespostas documento =
            RetRespostas(u['id_resposta_usuario'], u['status'], u['obs']);
        _listRespostas.add(documento);
        x = x + 1;
      }
      var _status = _listRespostas[0].rr_status;
      var _obs = _listRespostas[0].rr_obs;
    } catch (e) {}
  }

  _proximaPergunta(int pResposta) {
    _timer.cancel();
    print('_proximaPergunta = cheguei : $pResposta');
    String wResposta = _respostas[3];
    String wRespCerta = _respCerta[3];

    print('_proximaPergunta = _respostas[3] = $wResposta');
    print('_proximaPergunta = _respCerta[3] = $wRespCerta');
    int _acertou = 99;
    _acertou = pResposta;

    var _idRespInformada = _acertou;
    if (_respCerta[_acertou] != '1') {
      _acertou = 99;
    }

    print('resposta post : $_idResposta ');

    if (_acertou != 99) {
      print('resposta certa! 0 gravar ! ');
      String _respostaId = _idResposta[_acertou];
      _postRespostas(_idPergunta, _respostaId, _counter.toString());
      // {"metodo":"getrespostas","id_usuario":"1","id_pergunta":"1","id_resposta":"1","res_tempo":"00:30"
      // Fim - Envio da resposta certa
      _controlePerguntas = _controlePerguntas + 1;
      _pergunta = perguntas[_controlePerguntas].per_descricao;
      _idPergunta = perguntas[_controlePerguntas].id_pergunta;
      // Chamar proxima sequencia de perguntas
      if (_pergunta == null) {
        setState() {
          //  _showAlertDialog(context, ' Termino Perguntas.');
          _showMyDialog(' Termino Perguntas.');
          _classificacao();
        }
      }

      _tempoResp = perguntas[_controlePerguntas].per_tempo;

      _idResposta[0] = perguntas[_controlePerguntas].respostas[0].id_resposta;
      _idResposta[1] = perguntas[_controlePerguntas].respostas[1].id_resposta;
      _idResposta[2] = perguntas[_controlePerguntas].respostas[2].id_resposta;
      _idResposta[3] = perguntas[_controlePerguntas].respostas[3].id_resposta;
      _idResposta[4] = perguntas[_controlePerguntas].respostas[4].id_resposta;

      _respostas[0] = perguntas[_controlePerguntas].respostas[0].res_descricao;
      _postRespostas(_idPergunta, _respostaId, _counter.toString());
      _respostas[1] = perguntas[_controlePerguntas].respostas[1].res_descricao;
      _respostas[2] = perguntas[_controlePerguntas].respostas[2].res_descricao;
      _respostas[3] = perguntas[_controlePerguntas].respostas[3].res_descricao;
      _respostas[4] = perguntas[_controlePerguntas].respostas[4].res_descricao;

      _respCerta[0] = perguntas[_controlePerguntas].respostas[0].res_certa;
      _respCerta[1] = perguntas[_controlePerguntas].respostas[1].res_certa;
      _respCerta[2] = perguntas[_controlePerguntas].respostas[2].res_certa;
      _respCerta[3] = perguntas[_controlePerguntas].respostas[3].res_certa;
      _respCerta[4] = perguntas[_controlePerguntas].respostas[4].res_certa;

      print('_tempoResp : $_tempoResp');
      _tempoResposta(int.parse(_tempoResp));
    } else {
      print('gravando resposta - errada');
      _postRespostas(
          _idPergunta, _idRespInformada.toString(), _counter.toString());
      print('Game Over!');
      _showMyDialog(' Resposta errada!');
    }
  }

  Future<void> _showMyDialog(String pMensagem) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('FIM DE JOGO'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text(pMensagem), Text('Nova Rodada?')],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text('Continuar'),
                onPressed: () {
                  _classificacao();
                }),
          ],
        );
      },
    );
  }
  // Fim Show Dialog

}

class Resposta {
  Resposta({this.id_resposta, this.res_descricao, this.res_certa});

  final String id_resposta;
  final String res_descricao;
  final String res_certa;

  factory Resposta.fromJson(Map<String, dynamic> json) => Resposta(
      id_resposta: json["id_resposta"],
      res_descricao: json["res_descricao"],
      res_certa: json["res_certa"]);
}

class Perguntas {
  Perguntas(
      {this.id_usuario,
      this.id_pergunta,
      this.per_descricao,
      this.per_tempo,
      this.respostas});

  final String id_usuario;
  final String id_pergunta;
  final String per_descricao;
  final String per_tempo;
  final List<Resposta> respostas;

  factory Perguntas.fromJson(Map<String, dynamic> json) => Perguntas(
      id_usuario: json["id_usuario"],
      id_pergunta: json["id_pergunta"],
      per_descricao: json["per_descricao"],
      per_tempo: json["per_tempo"],
      respostas: (json["respostas"] as List)
          .map((conteudo) => Resposta.fromJson(conteudo))
          .toList());
}

class Respostas {
  final int _key;
  final String _value;
  Respostas(this._key, this._value);
}

class RetRespostas {
  final String rr_id_resposta_usuario;
  final String rr_status;
  final String rr_obs;

  RetRespostas(this.rr_id_resposta_usuario, this.rr_status, this.rr_obs);
}
