import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing/helper/Endpoint.dart';
import 'package:testing/helper/Konstan.dart';
import 'package:testing/screens/login/LoginRequest.dart';
import 'package:testing/screens/login/LoginRespon.dart';

class LoginBloc extends Cubit<LoginRespon>{
  LoginBloc(super.initialState);

  TextEditingController tecUsername = TextEditingController();
  TextEditingController tecPassword = TextEditingController();

  Future<void> doLogin() async{
    try{
      emit(LoginLoading());
      var hasil = await futureLogin();
      emit(hasil);
    }catch(e){
      debugPrint('try ' + e.toString());
      emit(LoginError());
    }

  }

  Future<LoginRespon> futureLogin() async{
    var bu = "${Endpoint.BASE_URL}login";
    var ebu = Uri.parse(bu);

    LoginRequest loginRequest = LoginRequest();
    loginRequest.email = tecUsername.text.toString();
    loginRequest.password = tecPassword.text.toString();
    
    var hasil = await http.post(ebu, body: loginRequest.toJson());
    debugPrint("status code ${hasil.statusCode}" );
    if (hasil.statusCode == Konstan.tag200){
      var a = LoginRespon.fromJson(jsonDecode(hasil.body));
      return a;
    }else{
      debugPrint("error bukan 200");
      return LoginError();
    }

  }

}