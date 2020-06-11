import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaquiparceiros/app/bloc/user_bloc.dart';
import 'package:flutter/material.dart';

class OrderHeader extends StatelessWidget {
  final DocumentSnapshot order;

  OrderHeader(this.order);

  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.of<UserBloc>(context);

    final _user = _userBloc.getUser(order.data["clientId"]);

    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              "Produtos/ Servicos: R\$${order.data["precoDosProdutos"].toStringAsFixed(2)}",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              "Total: R\$${order.data["precoTotal"].toStringAsFixed(2)}",
              style: TextStyle(fontWeight: FontWeight.w500),
            )
          ],
        )
      ],
    );
  }
}
