import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_beep/flutter_beep.dart';

import 'app/components/default_background_conteiner.dart';
import 'app/model/Usuario.dart';
//import 'app/utils/config.dart';
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

  List<Analise> analiseData;

  List _respostas = ['', '', '', '', '', ''];
  List _idResposta = ['', '', '', '', '', ''];
  List _respCerta = ['', '', '', '', '', ''];

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
    if (this.mounted) {
      setState(() {
        _respostas[0] = '';
        _respostas[1] = '';
        _respostas[2] = '';
        _respostas[3] = '';
        _respostas[4] = '';
        print('Home - Cheguei!');
        try {
          _email = this.dataUsuario.email;
          _userId = this.dataUsuario.userId;
          _userIdMQ = this.dataUsuario.userIdMQ;
          _vidas = this.dataUsuario.vidas;
          _vidasI = int.parse(_vidas);
        } catch (e) {}

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
  }

  _classificacao() {
    print('chamada - classificação');
    print('dataUsuario: $dataUsuario');
    var _nomex = dataUsuario.nome;
    var _userIdx = dataUsuario.userId;
    print('Home - _classficacao - nome : $_nomex');
    print('Home - _classficacao - userId : $_userIdx');
    dataUsuario.programa = 'Classificacao';
/*    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Classificacao(dataUsuario: dataUsuario))); */
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => Classificacao(dataUsuario: dataUsuario)),
        (Route<dynamic> route) => false);
  }

  _tempoResposta(int pCounter) {
    _counter = pCounter;
    int _counter30 = (pCounter * 0.30).round();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (this.mounted) {
        setState(() {
          if (_counter > 0) {
            _counter--;
            _progress = (1 - (_counter / pCounter));
            if (_counter == _counter30) {
              FlutterBeep.beep(false);
            }
          } else {
            // Tempo Esgotado
            if (this.mounted) {
              setState(() {
                _timer.cancel();
                FlutterBeep.beep(false);
                print('_vidas: $_vidas');
                if (_vidas == 0) {
                  // Analise
                  _classificacao();
                } else {
                  // Proxima pergunta
                  _proximaPergunta(99);
                }
              });
            }
          }
        });
      }
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
          child: CustomScrollView(shrinkWrap: true, slivers: <Widget>[
            SliverPadding(
                padding: const EdgeInsets.all(20.0),
                sliver: SliverList(
                    delegate: SliverChildListDelegate(<Widget>[
//                child: Center(
                  Row(
                    children: <Widget>[
                      Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: _vidasPlayer(),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: _formUI(),
                            ),
                          ]),
                      Align(
                        alignment: Alignment.topRight,
                        child: _barraProgresso(),
                      ),
                    ],
                    // )),
                  ),
                ])))
          ]),
        ))

        /*
        SizedBox.expand(
            child: Container(
                child: DefaultBackgroundContainer(
          child: Center(
              child: Row(
            children: <Widget>[
              Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: _vidasPlayer(),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: _formUI(),
                    ),
                  ]),
              Align(
                alignment: Alignment.topRight,
                child: _barraProgresso(),
              ),
            ],
          )),
        )))
        */
        /* body: Container(
          child: DefaultBackgroundContainer(
//            child: Center(
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
          //        ),
        ) */
        );
  }

  Widget _barraProgresso() {
    return Container(
      width: 30,
      height: 500,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: RotatedBox(
              quarterTurns: -1,
              child: LinearProgressIndicator(
                backgroundColor: Colors.greenAccent,
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Colors.amberAccent),
                value: _progress,
                minHeight: 40,
              ),
            ),
          ),
        ],
      ),
      // )
    );
  }

  Widget _vidasPlayer() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
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
    ]);
  }

  Widget _formUI() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 270.0,
            alignment: Alignment.centerLeft,
            child: Column(children: <Widget>[
              Text(
                _pergunta,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ]),
          ),
          Container(
            width: 270.0,
            child: Column(
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
          ),
          Row(
            children: <Widget>[
              /*     Container(
                width: 100.0,
                alignment: AlignmentDirectional.center,
              ), */
              Container(
                width: 160.0,
                alignment: AlignmentDirectional.center,
                child: ElevatedButton(
                    child: Text(
                      "Proxima",
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
                      print('_resposta: $_resposta');
                      _timer.cancel();
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
      activeColor: Colors.white,
      value: value,
      groupValue: _resposta,
      onChanged: onChanged,
      selectedTileColor: Colors.white,
      //   tileColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // Minhas Perguntas
  Future<List<Perguntas>> _getPerguntas() async {
    List<Perguntas> _listPerguntas = [];
    try {
      var data = await http.post(
        Uri.parse('https://www.cortexvendas.com.br/apiquiz/apiquiz.php'),
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

// - Removido o Tempo
/*      final jsonPerg =
          '{"perguntas": [{"id_usuario": "PiUwTt3cV7XXeVpeF9ic5w9EpfI2","id_pergunta": "17","per_descricao": "Obrigatoriamente, as proteínas são formadas por um conjunto de:","per_tempo": "9", ' +
              '"respostas": [{"id_resposta": "81","res_descricao": "Aminoácidos","res_certa": "1"},{"id_resposta": "82","res_descricao": "Ácidos Graxos ","res_certa": "0"},{"id_resposta": "83","res_descricao": "Carbonos",' +
              '"res_certa": "0"},{"id_resposta": "84","res_descricao": "Enzimas","res_certa": "0"},{"id_resposta": "85","res_descricao": "Glicerol","res_certa": "0"}]}]}';

      final jsonMap = JsonDecoder().convert(jsonPerg);
*/
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
      if (this.mounted) {
        setState(() {
          _tempoResposta(int.parse(_tempoResp));
        });
      }
    } catch (e) {}
    return _listPerguntas;
  }
  // Perguntas

  Future<List<Perguntas>> _postRespostas(
      String pidPergunta, String pidResposta, String pTempo) async {
    try {
      print('_postRespostas - cheguei - passo 0 - Id Resposta ' + pidResposta);
      var dataResposta = await http.post(
        Uri.parse('https://www.cortexvendas.com.br/apiquiz/apiquiz.php'),
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
      for (var u in jsonData) {
        var _status = u['status'];
        var _obs = u['obs'];
        _vidasI = int.parse(u['vidas']);
      }
      if (this.mounted) {
        setState(() {
          if (_vidasI == 0) {
            FlutterBeep.beep(false);
            _timer.cancel();
            _classificacao();
          } else {
            _isVisible1 = _vidasI > 0 ? true : false;
            _isVisible2 = _vidasI > 1 ? true : false;
            _isVisible3 = _vidasI > 2 ? true : false;
            _isVisible4 = _vidasI > 3 ? true : false;
            _isVisible5 = _vidasI > 4 ? true : false;
          }
        });
      }
    } catch (e) {}
  }

  _proximaPergunta(int pResposta) {
    if (this.mounted) {
      setState(() {
        _timer.cancel();
      });
    }
    print('_proximaPergunta = cheguei : $pResposta');

    int _acertou = pResposta;

    var _idRespInformada = _acertou;

    print('resposta post : $_idResposta ');

    // removido dia 14/04/2021 - somente apos perder todas as vida
    // que ocorre o encerramento da partida
    String _respostaId = '99';
    if (pResposta != 99) {
      _respostaId = _idResposta[_acertou];
    }
    _postRespostas(_idPergunta, _respostaId, _counter.toString());
    // Fim - Envio da resposta certa
    // Chamada da Rotina de Perguntas Novamente
    print('_controlePerguntas: $_controlePerguntas');
    try {
      _controlePerguntas = _controlePerguntas + 1;
      if (_controlePerguntas > (perguntas.length - 1)) {
        _getPerguntas(); // Busca Perguntas
        _controlePerguntas = 0;
      }

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
      if (this.mounted) {
        setState(() {
          _timer.cancel();
          _classificacao();
        });
      }
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
