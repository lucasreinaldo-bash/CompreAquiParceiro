import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    openStartPage();
  }

  openStartPage() async {
    await Future.delayed(Duration(seconds: 6), () => _loadCurrentUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Center(
            child: Container(
              width: 200,
              height: 200,
              child: Center(
                child: Transform.scale(
                    scale: 1.2, child: Image.asset("assets/logo.png")),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: RaisedButton(
              child: Text("Entrar"),
              onPressed: () {
                Navigator.pushNamed(context, "/Login");
              },
            ),
          )
        ],
      ),
    );
  }

  Future<Null> _loadCurrentUser() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser;
    if (firebaseUser == null) {
      print("aqui");
      firebaseUser = await _auth.currentUser();
      Navigator.pushNamed(context, "/Login");
    }
    if (firebaseUser != null) {
      print(firebaseUser.uid);
      Navigator.pushNamed(context, "/Login");
    }
  }
}
