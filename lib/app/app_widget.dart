import 'package:compreaquiparceiros/app/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/user_model.dart';
import 'modules/home/home_page.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          return MaterialApp(
            routes: <String, WidgetBuilder>{
              '/login': (BuildContext context) => new Login(),
            },
            home: Login(),
//      home: Principal(),
            debugShowCheckedModeBanner: false,
            title: "Compreaí Delivery",
            theme: ThemeData(
                primarySwatch: Colors.blue,
                primaryColor: Color.fromARGB(255, 20, 125, 141)),
          );
        },
      ),
    );
  }
}
