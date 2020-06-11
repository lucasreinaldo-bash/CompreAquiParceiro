import 'package:barcode_scan/platform_wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaquiparceiros/app/widget/order_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cliente_tile.dart';

class OrderTile extends StatelessWidget {
  final DocumentSnapshot order;
  String nome;
  String barcode = "";
  OrderTile(this.order, this.nome);

  String nomeCompleto = "não informado";
  String telefone = "não informado";
  final states = [
    "",
    "Em Análise",
    "Em transporte",
    "Serviço em andamento",
    "Serviço concluido"
  ];

  @override
  Widget build(BuildContext context) {
    String or = order.data["clienteId"];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 10,
        child: ExpansionTile(
          key: Key(order.documentID),
          initiallyExpanded: order.data["status"] != 4,
          title: Text(
            "#${order.documentID.substring(order.documentID.length - 7, order.documentID.length)} - "
            "${states[order.data["status"]]}",
            style: TextStyle(
                color: order.data["status"] != 4
                    ? Colors.grey[850]
                    : Colors.green),
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: order.data["produtos"].map<Widget>((p) {
                      print(order.data["produtos"]);
                      return Column(
                        children: <Widget>[
                          StreamBuilder(
                              stream: Firestore.instance
                                  .collection("ConsumidorFinal")
                                  .document(order.data["clienteId"])
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                else {
                                  return Card(
                                    elevation: 20,
                                    child: ExpansionTile(
                                      title: Text("Informações do Cliente"),
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Column(
                                            children: [
                                              Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(100.0),
                                                      side: BorderSide(
                                                          color:
                                                              Colors.white30)),
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Container(
                                                          width: 150.0,
                                                          height: 150.0,
                                                          decoration:
                                                              new BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image:
                                                                      new DecorationImage(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    image: new NetworkImage(snapshot.data["photo"] !=
                                                                            null
                                                                        ? snapshot
                                                                            .data["photo"]
                                                                        : ""),
                                                                  ))),
                                                    ],
                                                  )),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(snapshot.data["nome"],
                                                  style: TextStyle(
                                                      fontFamily: "QuickSand",
                                                      fontSize: 15)),
                                              Text(snapshot.data["cidade"]),
                                              Text(snapshot.data["email"]),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                "Endereço: " +
                                                    snapshot.data["endereco"],
                                                style: TextStyle(
                                                    color: Colors.blueGrey),
                                              ),
                                              FlatButton(
                                                child: Image.asset(
                                                  "assets/icon_zap.png",
                                                  height: 50,
                                                  width: 50,
                                                ),
                                                onPressed: () async {
                                                  String whatsapp = snapshot
                                                      .data["telefone"]
                                                      .toString();
                                                  var whatsappUrl =
                                                      "whatsapp://send?phone=${whatsapp}&text=${"Olá, vim através do App CompreAqui!"}";
                                                  await canLaunch(whatsappUrl)
                                                      ? launch(whatsappUrl)
                                                      : print(
                                                          "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
                                                },
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              }),
                          Text("Telefone: " + telefone),
                          ListTile(
                            title: Text(p["product"]["title"] +
                                " com a preferência de " +
                                p["variacao"]),
                            subtitle: Text("Categoria: " + p["categoria"]),
                            trailing: Text(
                              "Quantidade " + p["quantidade"].toString(),
                              style: TextStyle(fontSize: 10),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: <Widget>[
                                  Text("Solicitação realizada no dia " +
                                      order.data["data"]),
                                  Text("\n" + order.data["enderecoCliente"])
                                ],
                              ))
                        ],
                      );
                    }).toList(),
                  ),

                  OrderHeader(order),
//                  ClienteTile(order, order.data["clienteId"]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        onPressed: order.data["status"] < 4
                            ? () {
                                Firestore.instance
                                    .collection("ConsumidorFinal")
                                    .document(order.data["clienteId"])
                                    .collection("ordemPedidos")
                                    .document("realizados")
                                    .collection(nome)
                                    .document(order.documentID)
                                    .delete();
                                print(order.data["clienteId"]);

                                order.reference.delete();
                              }
                            : null,
                        textColor: Colors.red,
                        child: Text("Excluir"),
                      ),
                      FlatButton(
                        onPressed:
                            order.data["status"] > 1 && order.data["status"] < 4
                                ? () {
                                    order.reference.updateData(
                                        {"status": order.data["status"] - 1});
                                  }
                                : null,
                        textColor: Colors.grey[850],
                        child: Text("Regredir"),
                      ),
                      FlatButton(
                        onPressed: order.data["status"] < 3
                            ? () {
                                order.reference.updateData(
                                    {"status": order.data["status"] + 1});
                              }
                            : order.data["status"] < 4
                                ? () async {
                                    FlutterBarcodeScanner
                                            .getBarcodeStreamReceiver(
                                                "#ff6666",
                                                "Cancelar",
                                                false,
                                                ScanMode.DEFAULT)
                                        .listen((barcode) {
                                      if (barcode == order.documentID) {
                                        order.reference.updateData({
                                          "status": order.data["status"] + 1
                                        });
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                "QR Code inválido! Utilize o QR que esta na tela Minhas Solicitações no app do seu cliente.",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 4,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }

                                      print(barcode);

                                      /// barcode to be used
                                    });
                                  }
                                : null,
                        textColor: Colors.green,
                        child: Text(
                            order.data["status"] >= 3 ? "Concluir" : "Avançar"),
                      )
                    ],
                  ),
                  Center(
                    child: FlatButton(
                      onPressed: order.data["status"] == 4 ? () {} : null,
                      child: order.data["status"] == 4
                          ? Icon(
                              Icons.verified_user,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.verified_user,
                              color: Colors.grey,
                            ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
