import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing/helper/Fungsi.dart';
import 'package:testing/helper/Konstan.dart';
import 'package:testing/screens/create/CreateBloc.dart';
import 'package:testing/screens/create/CreateModel.dart';

late CreateBloc createBloc;
final _formKey = GlobalKey<FormState>();

class CreateScreen extends StatelessWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    createBloc = CreateBloc(CreateBegin());

    return MultiBlocProvider(
        providers: [
          BlocProvider<CreateBloc>(
              create: (BuildContext context) =>  createBloc
          )
        ],
        child: const CreateView()
    );
  }
}

class CreateView extends StatelessWidget {
  const CreateView({Key? key}) : super(key: key);

  Widget getTombol(){
    return ElevatedButton(
        onPressed: (){
          if (_formKey.currentState!.validate()){
            createBloc.doCreate();
          }
        },
        child: const Text("SUBMIT")
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create User"),),
      body: Form(
        key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: createBloc.tecName,
                decoration: const InputDecoration(
                    labelText: "Name"
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return Konstan.tagrequired;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: createBloc.tecJob,
                decoration: const InputDecoration(
                    labelText: "Job"
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return Konstan.tagrequired;
                  }
                  return null;
                },
              ),
              BlocConsumer<CreateBloc,CreateModel>(
                  builder: (context,state){
                    if (state is CreateBegin || state is CreateError ){
                      return getTombol();
                    }else if (state is CreateLoading){
                      return const LinearProgressIndicator();
                    }else{
                      return Column(
                        children: [
                          getTombol(),
                          Text("Name : ${state.name!}"),
                          Text("Job : ${state.job!}"),
                          Text("ID : ${state.id!}"),
                          Text("Created at : ${state.createdAt}")
                        ],
                      );
                    }
                  },
                  listener: (context,state){
                    if (state is CreateBegin || state is CreateLoading){

                    }else if (state is CreateError){
                      Fungsi.showSnack(context, Konstan.tag_error, Konstan.tag_ok, 2);
                    }else{
                      Fungsi.showSnack(context, "Create sukses", Konstan.tag_ok, 2);
                    }
                  }
              )
            ],
          )
      )
    );
  }
}

