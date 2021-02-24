import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Cadastro.dart';
import 'Home.dart';
import 'app/components/default_background_conteiner.dart';
import 'app/model/Usuario.dart';
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  final dataUsuario = Usuario();

  _validarCampos() {
    // Recupera dados digitados
    String email = _controllerEmail.text.trim();
    String senha = _controllerSenha.text.trim();

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty) {
        setState(() {
          _mensagemErro = "";
        });

        Usuario usuario = Usuario();

        usuario.email = email.trim();
        usuario.senha = senha.trim();

        dataUsuario.email = usuario.email;

        _logarUsuario(usuario); // Realiza cadastro do usuário no firebase

      } else {
        setState(() {
          _mensagemErro = "Preencha a senha com mais de 5 Caracteres";
        });
      }
    } else {
      print(email);

      setState(() {
        _mensagemErro = "Email deve ser preenchido e conter @";
      });
    }
  }

  _logarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .signInWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      // Busca Id do Usuario
      _getUsuario(
          auth.currentUser.uid, usuario.nome, usuario.email, usuario.senha);
      // Fim ID do Usuario
      dataUsuario.email = usuario.email;
      dataUsuario.userId = auth.currentUser.uid;
      print('id do usuario:');
      print(dataUsuario.userId);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Home(dataUsuario: dataUsuario)));
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

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Home(dataUsuario: dataUsuario)));

      // do whatever you want based on the firebaseUser state
    });
  }

  Future _getUsuario(
      String _puserId, String _pnome, String _pemail, String _psenha) async {
    List<Perguntas> _listPerguntas = [];
    try {
      print('_getusuario - _pnome : $_pnome');
      print('_getusuario - _puserId : $_puserId');
      print('_getusuario - _pemail : $_pemail');
      print('_getusuario - _psenha : $_psenha');

      var data = await http.post(
        'https://cortexvendas.com.br/apiquiz/apiquiz.php',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "metodo": "getusuario",
          "id_usuario": "$_puserId",
          "nome": "$_pnome",
          "email": "$_pemail",
          "senha": "$_psenha"
        }),
        //"email": "$_email"
      );

      var jsonData = json.decode(data.body);
      List<UsuarioRet> _usuarioRet = [];
      int x = 0;
      for (var u in jsonData) {
        UsuarioRet documento = UsuarioRet(u['id_usuario'], u['usu_nome']);
        _usuarioRet.add(documento);
        x = x + 1;
      }
      dataUsuario.userIdMQ = _usuarioRet[0].usu_id;
      print('userIdMQ: $dataUsuario.userIdMQ');
    } catch (e) {}
    return _listPerguntas;
  }

  @override
  void initState() {
    _verificarUsuarioLogado();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      //decoration: BoxDecoration(color: Color(0xff00A696)),
      //padding: EdgeInsets.all(16),
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

class UsuarioRet {
  final String usu_id;
  final String usu_nome;
  UsuarioRet(this.usu_id, this.usu_nome);
}
