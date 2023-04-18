import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing/helper/Fungsi.dart';
import 'package:testing/helper/Konstan.dart';
import 'package:testing/screens/update/UpdateBloc.dart';
import 'package:testing/screens/update/UpdateModel.dart';

late UpdateBloc updateBloc;
final _formKey = GlobalKey<FormState>();

class UpdateScreen extends StatelessWidget {
  int id;
  String name;
  String job;
  UpdateScreen(this.id,this.name,this.job, {super.key});

  @override
  Widget build(BuildContext context) {
    updateBloc = UpdateBloc(UpdateBegin());
    return MultiBlocProvider(
        providers: [
          BlocProvider<UpdateBloc>(
              create: (BuildContext context) => updateBloc
          )
        ],
        child: UpdateView(id, name, job)
    );
  }
}

class UpdateView extends StatelessWidget {
  int id;
  String name;
  String job;
  UpdateView(this.id,this.name,this.job, {super.key});

  @override
  Widget build(BuildContext context) {

    Widget getTombol(){
      return ElevatedButton(
          onPressed: (){
            if (_formKey.currentState!.validate()){
                updateBloc.doUpdate(this.id);
            }
          },
          child: Text("Update")
      );
    }

    updateBloc.tecJob.text = job;
    updateBloc.tecName.text = name;

    return Scaffold(
      appBar: AppBar(title: const Text("Update User"),),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: updateBloc.tecName,
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
              controller: updateBloc.tecJob,
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
            BlocConsumer<UpdateBloc,UpdateModel>(
                builder: (context,state){
                  if (state is UpdateBegin){
                    return getTombol();
                  }else if (state is UpdateLoading){
                    return LinearProgressIndicator();
                  }else if (state is UpdateError){
                    return getTombol();
                  }else{
                    return Column(
                      children: [
                        getTombol(),
                        Text("Name : ${state.name!}"),
                        Text("Job : ${state.job!}"),
                        Text("Created at : ${state.updatedAt}")
                      ],
                    );
                  }
                },
                listener: (context,state){
                  if (state is UpdateBegin){

                  }else if (state is UpdateLoading){

                  }else if (state is UpdateError){
                    Fungsi.showSnack(context, Konstan.tag_error, Konstan.tag_ok, 2);
                  }else{
                    Fungsi.showSnack(context, "Update OK", Konstan.tag_ok, 2);
                  }
                }
            )
          ],
        ),
      ),
    );
  }
}
