import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing/helper/Endpoint.dart';
import 'package:testing/helper/Konstan.dart';
import 'package:testing/screens/login/LoginRequest.dart';
import 'package:testing/screens/register/RegisterRespon.dart';

class RegisterBloc extends Cubit<RegisterRespon>{
  RegisterBloc(super.initialState);

  TextEditingController tecUsername = TextEditingController();
  TextEditingController tecPassword = TextEditingController();

  Future<void> doRegister() async{
    try{
      emit(RegisterLoading());
      var hasil = await futureRegister();
      emit(hasil);
    }catch(e){
      debugPrint('try $e');
      emit(RegisterError());
    }

  }

  Future<RegisterRespon> futureRegister() async {
    var bu = "${Endpoint.BASE_URL}register";
    var ebu = Uri.parse(bu);

    LoginRequest loginRequest = LoginRequest();
    loginRequest.email = tecUsername.text.toString();
    loginRequest.password = tecPassword.text.toString();

    var hasil = await http.post(ebu, body: loginRequest.toJson());
    debugPrint("status code ${hasil.statusCode}");
    if (hasil.statusCode == Konstan.tag200) {
      var a = RegisterRespon.fromJson(jsonDecode(hasil.body));
      return a;
    } else {
      debugPrint("error bukan 200");
      return RegisterError();
    }
  }

}