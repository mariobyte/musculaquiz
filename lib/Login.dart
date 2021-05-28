import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:musculaquiz/classificacao.dart';
import 'package:musculaquiz/app/utils/config.dart';

import 'Cadastro.dart';
import 'app/components/default_background_conteiner.dart';
import 'app/model/Usuario.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  bool _temArquivo = false;
  String _mensagemErro = "";

  final dataUsuario = Usuario();

  List _acessoUserList = [];

  _validarCampos() {
    // Recupera dados digitados
    String email = _controllerEmail.text.trim();
    String senha = _controllerSenha.text.trim();

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty) {
        if (this.mounted) {
          setState(() {
            _mensagemErro = "";
          });
        }
        Usuario usuario = Usuario();

        usuario.email = email.trim();
        usuario.senha = senha.trim();
        dataUsuario.email = usuario.email;

        _logarUsuario(usuario); // Realiza cadastro do usuário no firebase

      } else {
        if (this.mounted) {
          setState(() {
            _mensagemErro = "Preencha a senha com mais de 5 Caracteres";
          });
        }
      }
    } else {
      print(email);
      if (this.mounted) {
        setState(() {
          _mensagemErro = "Email deve ser preenchido e conter @";
        });
      }
    }
  }

  void _addUser(String pUsuarioEmail, String pIdUsuario, String pNome) {
    setState(() {
      print('_addUser : $pNome - pIdUsuario: $pIdUsuario');
      Map<String, dynamic> newUser = Map();
      newUser["login"] = pUsuarioEmail;
      newUser["idUser"] = pIdUsuario;
      newUser["nome"] = pNome;

      _acessoUserList.add(newUser);
      _saveData();
    });
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
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

  void apagarArquivo() {
    _deleteData();
  }

  _logarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .signInWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      dataUsuario.email = usuario.email;
      dataUsuario.userId = auth.currentUser.uid;
      dataUsuario.programa = 'iniciar';
      var wEmail = usuario.email;
      var wUserId = dataUsuario.userId;
      var wNome = dataUsuario.nome;
      //  print('id do usuario:');
      //  print(dataUsuario.userId);
      _addUser(wEmail, wUserId, wNome);
      // chamada 2
      print('login - chamada 2');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Classificacao(dataUsuario: dataUsuario)));
    }).catchError((error) {
      setState(() {
        //print ("Erro App" + error.toString) ;
        _mensagemErro =
            "Erro ao autenticar email e senha, verifique os dados informados e tente novamente";
      });
    });
  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signOut();

    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      final usuarioLogado = firebaseUser.email;

      print("usuario logado é " + usuarioLogado.toString());

      dataUsuario.email = usuarioLogado;
      dataUsuario.userId = auth.currentUser.uid;
      dataUsuario.programa = 'iniciar';
      // chamada 3
      //   print('Login - chamada 3');
      //   Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) => Classificacao(dataUsuario: dataUsuario)));
      // do whatever you want based on the firebaseUser state
    });
  }

  @override
  void initState() {
    print('cheguei na tela de login ');

    // Minha Configuração
    _readData().then((data) {
      setState(() {
        _acessoUserList = json.decode(data);

        var _email = _acessoUserList[0]['login'];
        var _idUser = _acessoUserList[0]['idUser'];
        var _nome = _acessoUserList[0]['nome'];

        print('_readData _email = $_email');
        print('_readData _idUser = $_idUser');
        print('_readData _nome = $_nome');

        dataUsuario.email = _email;
        dataUsuario.userId = _idUser;
        dataUsuario.nome = _nome;
        dataUsuario.programa = 'iniciar';
        // chamada 1
        print('login - chamada 1');
/*        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Classificacao(dataUsuario: dataUsuario))
                ); */
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => Classificacao(dataUsuario: dataUsuario)),
            (Route<dynamic> route) => false);
      });
    });

    _verificarUsuarioLogado();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: DefaultBackgroundContainer(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "imagens/logo.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    autofocus: true,
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: 'E-mail',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                TextField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: 'Senha',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Entrar",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      color: Color(0xff006C5D),
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      onPressed: () {
                        _validarCampos();
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
//                      Center(
                  child: GestureDetector(
                    child: Text(
                      "Não tem cadastro ? clique aqui",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Cadastro()));
                    },
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Center(
                      child: Text(
                        _mensagemErro,
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
