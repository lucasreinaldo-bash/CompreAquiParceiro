import 'package:compreaquiparceiros/app/login/login_bloc.dart';
import 'package:compreaquiparceiros/app/modules/home/home_bloc.dart';
import 'package:compreaquiparceiros/app/splash/splash_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:compreaquiparceiros/app/modules/home/home_page.dart';

class LoginModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => LoginBloc()),
      ];

  @override
  List<Router> get routers => [
        Router("/", child: (_, args) => HomePage()),
        Router("/Splash", child: (_, args) => SplashPage()),
        Router("/Login", child: (_, args) => SplashPage()),
      ];

  static Inject get to => Inject<LoginModule>.of();
}
