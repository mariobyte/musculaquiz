import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:musculaquiz/app/model/Usuario.dart';

import 'Home.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {

  // Controladores
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "" ;
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
  _validarCampos () {

    // Recupera dados digitados
    String nome = _controllerNome.text ;
    String email = _controllerEmail.text ;
    String senha = _controllerSenha.text ;


    if ( nome.isNotEmpty && nome.length > 3 ) {

    print('entrou no nome preenchido');

      if ( email.isNotEmpty && email.contains("@") ) {
        
        if ( senha.isNotEmpty && senha.length > 5 ) {
          setState(() {
            _mensagemErro = "";
          });          

          Usuario usuario = Usuario();

          usuario.nome = nome.trim() ;
          usuario.email = email.trim() ;
          usuario.senha = senha.trim() ;
  
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

  _cadastrarUsuario (Usuario usuario) async {

    FirebaseAuth auth = FirebaseAuth.instance ;

    auth.createUserWithEmailAndPassword(
      email: usuario.email, password: usuario.senha
    // ignore: deprecated_member_use
    ).then((firebaseUser) {

       setState(() {
          
          _mensagemErro = "Sucesso ao cadastrar";

          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => Home()
          ));
          
        });
 
    }).catchError((error){

      print ( "error app " + error.toString()   ) ;

      setState(() {
         _mensagemErro = "Erro ao cadastro usuário, verifique os campos e tente novamente\n Erro : " +  error.toString();
         print ( usuario.nome);
         print ( usuario.email);
         print ( usuario.senha);
      });

    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xff00A696)),
        padding: EdgeInsets.all(16),
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
                    style: TextStyle(fontSize: 20),
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
                    style: TextStyle(fontSize: 20),
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
                  style: TextStyle(fontSize: 20),
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
                        style: TextStyle(color: Colors.white, fontSize: 20),
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
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
