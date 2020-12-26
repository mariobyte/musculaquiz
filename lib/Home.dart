import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:musculaquiz/Login.dart';

import 'app/components/default_background_conteiner.dart';

class Home extends StatefulWidget {
    @override
    _HomeState createState() => _HomeState();

}

  

class _HomeState extends State<Home> {

  FirebaseAuth auth = FirebaseAuth.instance ;

  _deslogar(){

    auth.signOut();
    Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) => Login()
          )
        );

  }

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text ("Muscula Quiz" ),
      ) , 
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
                  padding: EdgeInsets.only(top:16, bottom:10),
                  child: RaisedButton(
                    child: Text(
                      "Sair",
                      style: TextStyle(color: Colors.white,fontSize: 20),
                    ) ,
                    color: Color(0xff006C5D),
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: (){
                     _deslogar();
                    } 
                  ),
                ) ,
              ] ,
            ), 
           ),
          ),  
        ),
      )
      );
  }


}