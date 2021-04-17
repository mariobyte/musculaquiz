import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_beep/flutter_beep.dart';

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
  double _progress;

  var _respostas = new List(5);
  var _idResposta = new List(5);
  var _respCerta = new List(5);

  String _email = '';
  String _userId = '';
  String _userIdMQ = '';
  String _vidas = '';
  int _vidasI = 0;
  bool _isVisible1 = false;
  bool _isVisible2 = false;
  bool _isVisible3 = false;
  bool _isVisible4 = false;
  bool _isVisible5 = false;

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
      _vidas = this.dataUsuario.vidas;
      _vidasI = int.parse(_vidas);

      print('_email: $_email');
      print('_userId: $_userId');
      print('_userIdMQ: $_userIdMQ');

      _isVisible1 = _vidasI > 0 ? true : false;
      _isVisible2 = _vidasI > 1 ? true : false;
      _isVisible3 = _vidasI > 2 ? true : false;
      _isVisible4 = _vidasI > 3 ? true : false;
      _isVisible5 = _vidasI > 4 ? true : false;

      print('passo 1 - anptes getperguntas');
//      _vidasI = 99;
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
    int _counter30 = (pCounter * 0.30).round();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
          _progress = (1 - (_counter / pCounter));
          //    print('progress: $_progress');
          //    print('_counter: $_counter');
          //    print('_counter30: $_counter30');
          if (_counter == _counter30) {
            FlutterBeep.beep(false);
          }
        } else {
          // Tempo Esgotado
          FlutterBeep.beep(false);

          _timer.cancel();
          _classificacao();
        }
      });
    });
  }

  Timer _timer;
  int _counter = 0;
  int _groupValue = -1;

  @override
  Widget build(BuildContext context) {
    //  Future.delayed(const Duration(seconds: 2));
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

  /* teste commit */
  Widget _formUI() {
    return Column(children: <Widget>[
      Row(children: <Widget>[
        Visibility(
          visible: _isVisible1,
          child: Image.asset(
            "imagens/boneco_vida.png",
            width: 60,
            height: 50,
          ),
        ),
        Visibility(
          visible: _isVisible2,
          child: Image.asset(
            "imagens/boneco_vida.png",
            width: 60,
            height: 50,
          ),
        ),
        Visibility(
          visible: _isVisible3,
          child: Image.asset(
            "imagens/boneco_vida.png",
            width: 60,
            height: 50,
          ),
        ),
        Visibility(
          visible: _isVisible4,
          child: Image.asset(
            "imagens/boneco_vida.png",
            width: 60,
            height: 50,
          ),
        ),
        Visibility(
          visible: _isVisible5,
          child: Image.asset(
            "imagens/boneco_vida.png",
            width: 60,
            height: 50,
          ),
        ),
        CircularProgressIndicator(
          strokeWidth: 5, // linha
          backgroundColor: Colors.greenAccent,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.redAccent),
          value: _progress,
        ),
      ]),
      Column(children: <Widget>[]),
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
      print('_postRespostas - cheguei - passo 0 - Id Resposta ' + pidResposta);
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

      var jsonData = json.decode(dataResposta.body)['retorno'];
      print('_postRespostas - Json de Retorno:  $jsonData');
      print('peter 1');
//      List<RetRespostas> _listRespostas = [];
      print('peter 2');
/*      int x = 0;
      for (var u in jsonData) {
        RetRespostas documento = RetRespostas(
            u['id_resposta_usuario'], u['status'], u['obs'], u['vidas']);
        print('peter 3');
        _listRespostas.add(documento);
        x = x + 1;
      } */
      print('peter 4');
      for (var u in jsonData) {
        var _status = u['status'];
        var _obs = u['obs'];
        _vidasI = int.parse(u['vidas']);
      }

//      var _status = _listRespostas[0].rr_status;
//      var _obs = _listRespostas[0].rr_obs;
//      var _vidas = _listRespostas[0].rr_vidas;
      print('vidas: $_vidasI');
      if (_vidasI == 0) {
        FlutterBeep.beep(false);
        _timer.cancel();
        _classificacao();
      } else {
        //_vidasI = int.parse(_vidas);
        _isVisible1 = _vidasI > 0 ? true : false;
        _isVisible2 = _vidasI > 1 ? true : false;
        _isVisible3 = _vidasI > 2 ? true : false;
        _isVisible4 = _vidasI > 3 ? true : false;
        _isVisible5 = _vidasI > 4 ? true : false;
      }
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
// 14/01/2021
//    if (_respCerta[_acertou] != '1') {
//      _acertou = 99;
//    }

    print('resposta post : $_idResposta ');

    // removido dia 14/04/2021 - somente apos perder todas as vida
    // que ocorre o encerramento da partida
    //if (_acertou != 99) {
    print('resposta certa! 0 gravar ! ');
    String _respostaId = _idResposta[_acertou];
    _postRespostas(_idPergunta, _respostaId, _counter.toString());
    // Fim - Envio da resposta certa
    _controlePerguntas = _controlePerguntas + 1;
    print('_controlePerguntas: $_controlePerguntas');
    try {
      _pergunta = perguntas[_controlePerguntas].per_descricao;
      _idPergunta = perguntas[_controlePerguntas].id_pergunta;
      print('_pergunta: $_pergunta');
    } catch (e) {
      _pergunta = 'Fim';
      print('Abortei!');
    }
    print('Controle de perguntas: $_pergunta');
    // Chamar proxima sequencia de perguntas
    if (_pergunta == 'Fim') {
      print('entrei no if _pergunta');
      print('saida');
      _showMyDialog(' Termino Perguntas.');
      _classificacao();
      // }
    } else {
      _tempoResp = perguntas[_controlePerguntas].per_tempo;

      _idResposta[0] = perguntas[_controlePerguntas].respostas[0].id_resposta;
      _idResposta[1] = perguntas[_controlePerguntas].respostas[1].id_resposta;
      _idResposta[2] = perguntas[_controlePerguntas].respostas[2].id_resposta;
      _idResposta[3] = perguntas[_controlePerguntas].respostas[3].id_resposta;
      _idResposta[4] = perguntas[_controlePerguntas].respostas[4].id_resposta;

      _respostas[0] = perguntas[_controlePerguntas].respostas[0].res_descricao;

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
    }
/*    } else {
      print('gravando resposta - errada');

      String _resposta = _idResposta[_idRespInformada];
      print('id resposta - errada - ' + _resposta);

      _postRespostas(_idPergunta, _resposta, _counter.toString());
      print('Game Over!');
      FlutterBeep.beep(false);
    //  _classificacao();
    // Alterado dia 14/04/2021 - somente quando zerar as vidas que encerra a partida
      // _showMyDialog(' Resposta errada!');
    } */
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

class RetRespostas {
  final String rr_id_resposta_usuario;
  final String rr_status;
  final String rr_obs;
  final String rr_vidas;

  RetRespostas(
      this.rr_id_resposta_usuario, this.rr_status, this.rr_obs, this.rr_vidas);
}
