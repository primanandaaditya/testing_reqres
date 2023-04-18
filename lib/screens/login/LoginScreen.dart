import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing/helper/Fungsi.dart';
import 'package:testing/helper/Konstan.dart';
import 'package:testing/screens/login/LoginBloc.dart';
import 'package:testing/screens/login/LoginRespon.dart';

late LoginBloc loginBloc;
final _formKey = GlobalKey<FormState>();

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    loginBloc = LoginBloc(LoginBegin());
    return MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
              create: (BuildContext context) => loginBloc
          )
        ],
        child: const LoginView()
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget getTombol(){
      return ElevatedButton(
          onPressed: (){
            if (_formKey.currentState!.validate()){
              loginBloc.doLogin();
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
            const Text("LOGIN", textAlign: TextAlign.center, style: TextStyle(fontSize: 40),),
            TextFormField(
              controller: loginBloc.tecUsername,
              decoration: const InputDecoration(
                labelText: "Email"
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return Konstan.tagrequired;
                }
                return null;
              },

            ),
            TextFormField(
              controller: loginBloc.tecPassword,
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
            BlocConsumer<LoginBloc,LoginRespon>(
                builder: (context, state){
                  if (state is LoginBegin){
                    return getTombol();
                  }else if (state is LoginLoading){
                    return const LinearProgressIndicator();
                  }else if (state is LoginError){
                    return getTombol();
                  }else{
                    return const Text("Login berhasil...");
                  }
                },
                listener: (context,state){
                  if (state is LoginError){
                    Fungsi.showSnack(context, Konstan.tag_error, "OK", 2);
                  }else if (state is LoginBegin || state is LoginLoading ){
                  }else{
                    Fungsi.showSnack(context, "Login berhasil", state.token!, 3);
                    Navigator.popAndPushNamed(context, "/user");
                  }
                }
            ),
            TextButton(
                onPressed: (){
                  Navigator.popAndPushNamed(context, "/register");
                },
                child: const Text("Register")
            )
          ],
        ),
      )
    );
  }
}

