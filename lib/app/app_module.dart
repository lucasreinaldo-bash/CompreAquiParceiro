import 'package:compreaquiparceiros/app/login/login_bloc.dart';
import 'package:compreaquiparceiros/app/login/login_module.dart';
import 'package:compreaquiparceiros/app/login/login_page.dart';
import 'package:compreaquiparceiros/app/splash/splash_bloc.dart';
import 'package:compreaquiparceiros/app/app_bloc.dart';
import 'package:compreaquiparceiros/app/splash/splash_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:compreaquiparceiros/app/app_widget.dart';
import 'package:compreaquiparceiros/app/modules/home/home_module.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind((i) => LoginBloc()),
        Bind((i) => SplashBloc()),
        Bind((i) => AppBloc()),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, module: LoginModule()),
        Router("/Splash", child: (_, args) => SplashPage()),
        Router("/Login", child: (_, args) => Login()),
      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
