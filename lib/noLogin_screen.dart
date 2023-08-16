import 'package:flutter/material.dart';
import 'package:prud_gerenciamento/login_screen.dart';

class NoLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.do_not_disturb_off, size: 80,color: Colors.grey[700],),
          SizedBox(
            height: 20,
          ),
          Text("Faça login para \n ver as mensagens!",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(top: 6),
            child: Container(
              width: 200,
              height: 40,
              child: RaisedButton(
                color: Colors.pink,
                onPressed: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=>Login())
                  );
                },
                textColor: Colors.white,
                child: Text("Entrar",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
