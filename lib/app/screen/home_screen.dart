import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaquiparceiros/app/bloc/orders_bloc.dart';
import 'package:compreaquiparceiros/app/bloc/user_bloc.dart';
import 'package:compreaquiparceiros/app/tabs/orders_tab.dart';
import 'package:compreaquiparceiros/app/tabs/products_tab.dart';
import 'package:compreaquiparceiros/app/tabs/users_tab.dart';
import 'package:compreaquiparceiros/app/widget/edit_category_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomeScreen extends StatefulWidget {
  String nome = "Supermecado Bretas";
//  HomeScreen(this.nome);
  @override
  _HomeScreenState createState() => _HomeScreenState(nome);
}

class _HomeScreenState extends State<HomeScreen> {
  String nome;
  _HomeScreenState(this.nome);
  PageController _pageController;
  int _page = 0;

  UserBloc _userBloc;
  OrdersBloc _ordersBloc;

  String uid;
  @override
  void initState() {
    super.initState();

    _ordersBloc = OrdersBloc("Barbearia ElShaday");
    _pageController = PageController();

    _userBloc = UserBloc();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.pinkAccent,
            primaryColor: Colors.white,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: TextStyle(color: Colors.white54))),
        child: BottomNavigationBar(
            currentIndex: _page,
            onTap: (p) {
              _pageController.animateToPage(p,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_pin_circle),
                  title: Text("Meus Clientes")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  title: Text("Pedidos Recebidos")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list), title: Text("Meus Produtos"))
            ]),
      ),
      body: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder(
              stream: Firestore.instance
                  .collection("UserBusiness")
                  .document(snapshot.data.uid)
                  .snapshots(),
              builder: (context, snapshot2) {
                nome = snapshot2.data["nome"];
                uid = snapshot.data.uid;

                Future<FirebaseUser> user = FirebaseAuth.instance.currentUser();

                if (!snapshot2.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot2.hasData) {}
                return SafeArea(
                  child: BlocProvider<UserBloc>(
                    bloc: _userBloc,
                    child: BlocProvider<OrdersBloc>(
                      bloc: _ordersBloc,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (p) {
                          setState(() {
                            _page = p;
                          });
                        },
                        children: <Widget>[
                          UsersTab(),
                          OrdersTab(),
                          ProductsTab()
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: _buildFloating(),
    );
  }

  Widget _buildFloating() {
    switch (_page) {
      case 0:
        return null;
      case 1:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Colors.pinkAccent,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_downward,
                  color: Colors.pinkAccent,
                ),
                backgroundColor: Colors.white,
                label: "Concluídos Abaixo",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_LAST);
                }),
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.pinkAccent,
                ),
                backgroundColor: Colors.white,
                label: "Concluídos Acima",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_FIRST);
                })
          ],
        );
      case 2:
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.pinkAccent,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => EditCategoryDialog(nome: nome));
          },
        );
    }
  }
}
