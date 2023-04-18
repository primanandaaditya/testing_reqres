import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing/helper/Endpoint.dart';
import 'package:testing/helper/Konstan.dart';
import 'package:testing/screens/list/UserModel.dart';
import 'package:http/http.dart' as http;

class UserBloc extends Cubit<UserModel>{
  UserBloc(super.initialState);

  Future<void> getUser() async{
    emit(UserLoading());
    try{
      var hasil = await futureUser();
      emit(hasil);
    }catch(e){
      emit(UserError());
    }
  }

  Future<UserModel> futureUser() async {
    var bu = "${Endpoint.BASE_URL}users?page=1";
    var ebu = Uri.parse(bu);
    var api = await http.get(ebu);
    debugPrint(api.statusCode.toString());
    if (api.statusCode == Konstan.tag200){
      var hasil = UserModel.fromJson(jsonDecode(api.body));
      return hasil;
    }else{
      return UserError();
    }
  }
}