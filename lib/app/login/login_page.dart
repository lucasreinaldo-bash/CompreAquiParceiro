import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaquiparceiros/app/bloc/login_bloc.dart';
import 'package:compreaquiparceiros/app/models/user_model.dart';
import 'package:compreaquiparceiros/app/screen/home_screen.dart';
import 'package:compreaquiparceiros/app/splash/splash_page.dart';
import 'package:compreaquiparceiros/app/widget/input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginBloc = LoginBloc();
  FirebaseUser user;
  final _formKey = GlobalKey<FormState>();
  bool _obscureTextLogin = true;
  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String nome;

  @override
  void initState() {
    super.initState();

    _loginBloc.outState.listen((state) {
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));

          break;
        case LoginState.FAIL:
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Erro"),
                    content: Text("Você não possui os privilégios necessários"),
                  ));
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:
      }
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: StreamBuilder<LoginState>(
          stream: _loginBloc.outState,
          initialData: LoginState.LOADING,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case LoginState.LOADING:
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                  ),
                );
              case LoginState.FAIL:
              case LoginState.SUCCESS:
              case LoginState.IDLE:
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: new AssetImage("assets/fundo_parceiros.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: null /* add child content content here */,
                    ),
                    SingleChildScrollView(
                        child: Container(
                            margin: EdgeInsets.all(16),
                            child: ScopedModelDescendant<UserModel>(
                              builder: (context, child, model) {
                                return Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/logo.png",
                                        height: 150,
                                        width: 150,
                                      ),
                                      Text("Ambiente Administrativo"),
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0),
                                                side: BorderSide(
                                                    color: Colors.white30)),
                                            elevation: 20,
                                            color: Colors.white,
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: <Widget>[
                                                  TextField(
                                                    focusNode:
                                                        myFocusNodeEmailLogin,
                                                    controller:
                                                        _emailController,
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "WorkSansSemiBold",
                                                        fontSize: 16.0,
                                                        color: Colors.black),
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      icon: Icon(
                                                        Icons.mail,
                                                        color: Colors.black,
                                                        size: 22.0,
                                                      ),
                                                      hintText: "E-mail",
                                                      hintStyle: TextStyle(
                                                          fontFamily: "Georgia",
                                                          fontSize: 17.0),
                                                    ),
                                                  ),
                                                  TextField(
                                                    focusNode:
                                                        myFocusNodePasswordLogin,
                                                    controller:
                                                        _senhaController,
                                                    obscureText:
                                                        _obscureTextLogin,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "WorkSansSemiBold",
                                                        fontSize: 16.0,
                                                        color: Colors.black),
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      icon: Icon(
                                                        Icons.lock,
                                                        size: 22.0,
                                                        color: Colors.black,
                                                      ),
                                                      hintText: "Minha Senha",
                                                      hintStyle: TextStyle(
                                                          fontFamily:
                                                              "WorkSansSemiBold",
                                                          fontSize: 17.0),
                                                      suffixIcon:
                                                          GestureDetector(
                                                        onTap: _toggleLogin,
                                                        child: Icon(
                                                          _obscureTextLogin
                                                              ? Icons
                                                                  .remove_red_eye
                                                              : Icons
                                                                  .remove_red_eye,
                                                          size: 15.0,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ),
                                      StreamBuilder<bool>(
                                          stream: _loginBloc.outSubmitValid,
                                          builder: (context, snapshot) {
                                            return Container(
                                                margin:
                                                    EdgeInsets.only(top: 1.0),
                                                decoration: new BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                      offset: Offset(1.0, 1.0),
                                                      blurRadius: 1.0,
                                                    ),
                                                  ],
                                                  gradient: new LinearGradient(
                                                      colors: [
                                                        Colors.green.shade500,
                                                        Colors.lightBlue
                                                      ],
                                                      begin:
                                                          const FractionalOffset(
                                                              0.2, 0.2),
                                                      end:
                                                          const FractionalOffset(
                                                              1.0, 1.0),
                                                      stops: [0.0, 1.0],
                                                      tileMode: TileMode.clamp),
                                                ),
                                                child: MaterialButton(
                                                  minWidth: 100,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                                  child: Text(
                                                    "Entrar",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15.0,
                                                        fontFamily:
                                                            "WorkSansBold"),
                                                  ),
                                                  onPressed: () {
                                                    if (_formKey.currentState
                                                        .validate()) {}
                                                    model.signIn(
                                                        email: _emailController
                                                            .text,
                                                        pass: _senhaController
                                                            .text,
                                                        onSucess: _onSucess,
                                                        onFail: _onFail);
                                                  },
                                                ));
                                          })
                                    ],
                                  ),
                                );
                              },
                            ))),
                  ],
                );
            }
          }),
    );
  }

  void _onSucess() {
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Sua senha está errada."),
      backgroundColor: Colors.blueGrey,
      duration: Duration(seconds: 2),
    ));
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }
}
