import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing/helper/Endpoint.dart';
import 'package:testing/helper/Konstan.dart';
import 'package:testing/screens/update/UpdateModel.dart';
import 'package:testing/screens/update/UpdateRequest.dart';


class UpdateBloc extends Cubit<UpdateModel>{
  UpdateBloc(super.initialState);

  TextEditingController tecName = TextEditingController();
  TextEditingController tecJob = TextEditingController();

  Future<void> doUpdate(int id) async{
    try{
      emit(UpdateLoading());
      var hasil = await futureUpload(id);
      emit(hasil);
    }catch(e){
      debugPrint('try $e');
      emit(UpdateError());
    }

  }

  Future<UpdateModel> futureUpload(int id) async {
    var bu = "${Endpoint.BASE_URL}users/$id";
    var ebu = Uri.parse(bu);

    UpdateRequest request = UpdateRequest();
    request.name = tecName.text.toString();
    request.job = tecJob.text.toString();

    var hasil = await http.put(ebu, body: request.toJson());
    debugPrint("status code ${hasil.statusCode}");
    if (hasil.statusCode == Konstan.tag200) {
      var a = UpdateModel.fromJson(jsonDecode(hasil.body));
      return a;
    } else {
      debugPrint("error bukan 200");
      return UpdateError();
    }
  }

}