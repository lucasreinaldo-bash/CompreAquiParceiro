import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:compreaquiparceiros/app/app_module.dart';
import 'package:compreaquiparceiros/app/login/login_bloc.dart';
import 'package:compreaquiparceiros/app/app_module.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(AppModule());
  LoginBloc bloc;

  // setUp(() {
  //     bloc = AppModule.to.get<LoginBloc>();
  // });

  // group('LoginBloc Test', () {
  //   test("First Test", () {
  //     expect(bloc, isInstanceOf<LoginBloc>());
  //   });
  // });
}
