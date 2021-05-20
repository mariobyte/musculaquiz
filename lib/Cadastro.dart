import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:musculaquiz/app/model/Usuario.dart';

import 'Home.dart';
import 'package:musculaquiz/app/components/default_background_conteiner.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'app/utils/config.dart';
import 'package:musculaquiz/classificacao.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  // Controladores
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  final dataUsuario = Usuario();
/*
try {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: "some invlaid emaill",
    password: "SuperSecretPassword!"
  );
} on FirebaseAuthException catch  (e) {
  if (e.code == 'invalid-email') {
    // Do something :D
  }
}
*/
  _validarCampos() {
    // Recupera dados digitados
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    print('nome: $nome');
    print('email: $email');
    print('senha: $senha');

    if (nome.isNotEmpty && nome.length > 3) {
      print('entrou no nome preenchido');

      if (email.isNotEmpty && email.contains("@")) {
        if (senha.isNotEmpty && senha.length > 5) {
          setState(() {
            _mensagemErro = "";
          });

          Usuario usuario = Usuario();

          usuario.nome = nome.trim();
          usuario.email = email.trim();
          usuario.senha = senha.trim();

          _cadastrarUsuario(usuario); // Realiza cadastro do usuário no firebase

        } else {
          setState(() {
            _mensagemErro = "Preencha a senha com mais de 5 Caracteres";
          });
        }
      } else {
        setState(() {
          _mensagemErro = "Email deve ser preenchido e conter @";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Nome precisa ter mais de 3 caracteres";
      });
    }
  }

  void _cadastrarUsuario(Usuario usuario) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .createUserWithEmailAndPassword(
            email: usuario.email, password: usuario.senha
            // ignore: deprecated_member_use
            )
        .then((firebaseUser) {
      setState(() {
        _mensagemErro = "Sucesso ao cadastrar";

        try {
          final User user = auth.currentUser;
          usuario.userId = user.uid;
          print('Cadastro novo ');
          print(usuario.userId);
          print(usuario.nome);
          print(usuario.email);
          print(usuario.senha);
          _cadUsuarioApi(
              usuario.userId, usuario.nome, usuario.email, usuario.senha);
        } catch (e) {
          _mensagemErro =
              "Erro ao enviar o getsuário, verifique os campos e tente novamente\n Erro : " +
                  e.toString();
          print('Erro enviar o getUsuario - Json');
        }

        dataUsuario.nome = usuario.nome;
        dataUsuario.email = usuario.email;
        dataUsuario.userId = usuario.userId;
        dataUsuario.programa = 'iniciar';
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Classificacao(dataUsuario: dataUsuario)));
      });
    }).catchError((error) {
      print("error app " + error.toString());

      setState(() {
        _mensagemErro =
            "Erro ao cadastro usuário, verifique os campos e tente novamente\n Erro : " +
                error.toString();
        print(usuario.nome);
        print(usuario.email);
        print(usuario.senha);
        print(_mensagemErro);
      });
    });
  }

  void _cadUsuarioApi(
      String pid_usuario, String pnome, String pemail, String psenha) async {
    try {
      var dataResposta = await http.post(
        Uri.parse('https://www.cortexvendas.com.br/apiquiz/apiquiz.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "metodo": "getusuario",
          "id_usuario": "$pid_usuario",
          "nome": "$pnome",
          "email": "$pemail",
          "senha": "$psenha"
        }),
      );
    } catch (e) {
      _mensagemErro =
          "Erro ao cadastrar o usuario, verifique os campos e tente novamente\n Erro : " +
              e.toString();
      print('Erro enviar postUsuarioApi - Json');
    }
  }

  Future _getUsuario(
      String _puserId, String _pnome, String _pemail, String _psenha) async {
    List<Perguntas> _listPerguntas = [];
    try {
      var data = await http.post(
        Uri.parse('https://www.cortexvendas.com.br/apiquiz/apiquiz.php'),
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
      dataUsuario.email = _pemail;
      dataUsuario.userId = _puserId;
      dataUsuario.nome = _pnome;

      print('userIdMQ: $dataUsuario.userIdMQ');
      print('DataUsuario:');
      print(dataUsuario);
    } catch (e) {}
    return _listPerguntas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cadastro"),
          backgroundColor: Color(0xff00A191),
        ),
        body: Container(
          //      decoration: BoxDecoration(color: Color(0xff00A696)),
//        padding: EdgeInsets.all(16),
          child: DefaultBackgroundContainer(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 22),
                      child: Image.asset(
                        "imagens/usuario.png",
                        width: 100,
                        height: 50,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: _controllerNome,
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: 'Nome',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: TextField(
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
                            "Cadastrar",
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
                    Center(
                        child: Text(
                      _mensagemErro,
                      style: TextStyle(color: Colors.red, fontSize: 18),
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
