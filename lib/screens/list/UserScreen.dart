import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing/helper/Endpoint.dart';
import 'package:testing/helper/Fungsi.dart';
import 'package:testing/helper/Konstan.dart';
import 'package:testing/screens/list/UserBloc.dart';
import 'package:testing/screens/list/UserModel.dart';
import 'package:testing/screens/update/UpdateScreen.dart';
import 'package:http/http.dart' as http;

late UserBloc userBloc;

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    userBloc = UserBloc(UserBegin());

    return MultiBlocProvider(
        providers: [
          BlocProvider<UserBloc>(
              create: (BuildContext context) => userBloc
          )
        ],
        child: const UserView()
    );
  }
}

class UserView extends StatelessWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    userBloc.getUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text("User List"),

      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white,),
        onPressed: () {
          Navigator.pushNamed(context, "/create");
        },

      ),
      body: BlocBuilder<UserBloc,UserModel>(
          builder: (context,state){
            if (state is UserBegin){
              return Container();
            }else if (state is UserLoading){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }else if (state is UserError){
              return Column(
                children: [
                  const Text(Konstan.tag_error, textAlign: TextAlign.center,),
                  ElevatedButton(
                      onPressed: (){
                        userBloc.getUser();
                      },
                      child: const Text(Konstan.tag_coba_lagi)
                  )
                ],
              );
            }else {
              return ListView.builder(
                itemCount: state.data!.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return UpdateScreen(state.data![index].id!, state.data![index].firstName!, "");
                            })
                        );
                      },
                      leading:  Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(state.data![index].avatar!)
                            )
                        ),
                      ),
                      subtitle: Text(state.data![index].email!),
                      trailing: IconButton(
                          onPressed: (){
                            hapus(context, state.data![index].id!).then((value) {

                            });
                          },
                          icon: const Icon(Icons.delete)
                      ),
                      title: Text("${state.data![index].firstName!}, ${state.data![index].lastName!}"),
                    ) ;
                  }
              );
            }
          }
      ),
    );
  }

  Future<void> hapus(BuildContext context,int id) async{
    try{
      var bu = "${Endpoint.BASE_URL}users/$id";
      var ebu = Uri.parse(bu);
      var api = await http.delete(ebu);
      if (api.statusCode == 204){
        Fungsi.showSnack(context, "Data berhasil dihapus", Konstan.tag_ok, 2);
      }else{
        Fungsi.showSnack(context, "Gagal menghapus data", Konstan.tag_ok, 2);
      }
    }catch(e){
      Fungsi.showSnack(context, e.toString(), Konstan.tag_ok, 2);
    }

  }
}
