import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing/helper/Fungsi.dart';
import 'package:testing/helper/Konstan.dart';
import 'package:testing/screens/register/RegisterBloc.dart';
import 'package:testing/screens/register/RegisterRespon.dart';


late RegisterBloc registerBloc;
final _formKey = GlobalKey<FormState>();

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    registerBloc = RegisterBloc(RegisterBegin());
    return MultiBlocProvider(
        providers: [
          BlocProvider<RegisterBloc>(
              create: (BuildContext context) => registerBloc
          )
        ],
        child: const RegisterView()
    );
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget getTombol(){
      return ElevatedButton(
          onPressed: (){
            if (_formKey.currentState!.validate()){
              registerBloc.doRegister();
            }
          },
          child: const Text("SUBMIT")
      );
    }

    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(40),
          children: [
            const Text("REGISTER", textAlign: TextAlign.center, style: TextStyle(fontSize: 40),),
            TextFormField(
              controller: registerBloc.tecUsername,
              decoration: const InputDecoration(
                labelText: "Username / email"
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return Konstan.tagrequired;
                }
                return null;
              },
            ),
            TextFormField(
              controller: registerBloc.tecPassword,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: "Password"
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return Konstan.tagrequired;
                }
                return null;
              },
            ),
            BlocConsumer<RegisterBloc,RegisterRespon>(
                builder: (context,state){
                  if (state is RegisterBegin){
                    return getTombol();
                  }else if (state is RegisterLoading){
                    return const LinearProgressIndicator();
                  }else if (state is RegisterError){
                    return getTombol();
                  }else{
                    return Text("Registrasi berhasil, token " + state.token!, textAlign: TextAlign.center,);
                  }
                },
                listener: (context,state){
                  if (state is RegisterError){
                    Fungsi.showSnack(context, "Register error!", "Coba lagi", 2);
                  }else if (state is RegisterLoading || state is RegisterBegin){

                  }else{
                    Fungsi.showSnack(context, "Register berhasil", "OK", 2);
                  }
                }
            ),
            TextButton(
                onPressed: (){
                  Navigator.popAndPushNamed(context, "/login");
                },
                child: Text("LOGIN"))
          ],
        ),
      ),
    );
  }
}

