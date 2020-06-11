import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ClienteTile extends StatelessWidget {
  String nomeCompleto = "não informado";
  String telefone = "não informado";
  DocumentSnapshot doc;
  String uid;
  ClienteTile(this.uid);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: Firestore.instance
              .collection("ConsumidorFinal")
              .document(uid)
              .snapshots(),
          builder: (context, snapshot2) {
            Future<FirebaseUser> user = FirebaseAuth.instance.currentUser();

            if (!snapshot2.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              nomeCompleto = snapshot2.data["nome"];
              telefone = snapshot2.data["telefone"];
              Text(nomeCompleto);
            }
          },
        ),
      ),
    );
  }
}
