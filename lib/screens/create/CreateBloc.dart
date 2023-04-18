import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing/helper/Endpoint.dart';
import 'package:testing/helper/Konstan.dart';
import 'package:testing/screens/create/CreateModel.dart';
import 'package:testing/screens/create/CreateRequest.dart';


class CreateBloc extends Cubit<CreateModel>{
  CreateBloc(super.initialState);

  TextEditingController tecName = TextEditingController();
  TextEditingController tecJob = TextEditingController();

  Future<void> doCreate() async{
    try{
      emit(CreateLoading());
      var hasil = await futureCreate();
      emit(hasil);
    }catch(e){
      debugPrint('try $e');
      emit(CreateError());
    }

  }

  Future<CreateModel> futureCreate() async{
    var bu = "${Endpoint.BASE_URL}users";
    var ebu = Uri.parse(bu);

    CreateRequest req = CreateRequest();
    req.name = tecName.text.toString();
    req.job = tecJob.text.toString();
    
    var hasil = await http.post(ebu, body: req.toJson());
    debugPrint("status code ${hasil.statusCode}" );
    if (hasil.statusCode == 201){
      var a = CreateModel.fromJson(jsonDecode(hasil.body));
      return a;
    }else{
      debugPrint("error bukan 200");
      return CreateError();
    }

  }

}