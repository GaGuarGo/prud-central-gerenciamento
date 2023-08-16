import 'package:flutter/material.dart';
import 'package:prud_gerenciamento/blocs/login/login_bloc.dart';
import 'package:prud_gerenciamento/main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();

  final TextEditingController _pass = TextEditingController();


  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();

    _loginBloc.outState.listen((state) {
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
          break;
        case LoginState.FAIL:
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('ERRO!'),
                    content:
                        Text("Você não possui os privilégios administrativos"),
                  ));
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.pink,
        centerTitle: true,
        title: Text(
          'Admin Login',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<LoginState>(
        stream: _loginBloc.outState,
        initialData: LoginState.LOADING,
        // ignore: missing_return
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case LoginState.LOADING:
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              );
            case LoginState.IDLE:
            case LoginState.FAIL:
            case LoginState.SUCCESS:
              return ListView(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 20),
                children: [
                  Icon(
                    Icons.person,
                    size: 70,
                    color: Colors.grey[700],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  StreamBuilder<String>(
                      stream: _loginBloc.outEmail,
                      builder: (context, snapshot) {
                        return TextFormField(
                          onChanged: _loginBloc.changeEmail,
                          controller: _email,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              labelText: 'Digite o email',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              )),
                        );
                      }),
                  SizedBox(
                    height: 30,
                  ),
                  StreamBuilder<String>(
                      stream: _loginBloc.outPassword,
                      builder: (context, snapshot) {
                        return TextFormField(
                          onChanged: _loginBloc.changePassword,
                          obscureText: true,
                          controller: _pass,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              labelText: 'Digite a senha',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              )),
                        );
                      }),
                  StreamBuilder<bool>(
                      stream: _loginBloc.outSubmitValid,
                      builder: (context, snapshot) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 26.0, left: 200, right: 200),
                          child: RaisedButton(
                            disabledColor: Colors.pinkAccent.withAlpha(100),
                            onPressed:
                                snapshot.hasData ? _loginBloc.submit : null,
                            color: Colors.pink,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Text(
                              'Entrar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      })
                ],
              );
          }
        },
      ),
    );
  }
}
