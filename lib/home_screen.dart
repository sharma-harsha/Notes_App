import 'package:flutter/material.dart';
import 'package:notes/db_handler.dart';
import 'package:notes/notes.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  DBHelper? dbHelper;
  late Future<List<NotesModel>> notesList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    notesList = dbHelper!.getnotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes Sql'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: notesList,
                builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {

                  if(snapshot.hasData){
                     return ListView.builder(
                      reverse: false,
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: (){
                            dbHelper!.update(
                             
                              NotesModel(
                                 id : snapshot.data![index].id!,
                                title: 'title', age: 5 , description: 'description', email: 'email'),
                            );
                          },
                          child: Dismissible(
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              child: Icon(Icons.delete_forever),
                            ),
                            onDismissed: (DismissDirection direction){
                              setState(() {
                                dbHelper!.delete(snapshot.data![index].id!);
                                notesList = dbHelper!.getnotesList();
                                snapshot.data!.remove(snapshot.data![index]);
                              });
                            },
                            key: ValueKey<int>(snapshot.data![index].id!),
                            child: Card(
                              child: ListTile(
                                // contentPadding: EdgeInsets.all(0),
                                title: Text(snapshot.data![index].title.toString()),
                                subtitle: Text(
                                    snapshot.data![index].description.toString()),
                                trailing:
                                    Text(snapshot.data![index].age.toString()),
                              ),
                            ),
                          ),
                        );
                      });
 
                  }else{
                    return CircularProgressIndicator();
                  }

                                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dbHelper!
              .insert(
            NotesModel(
              title: 'First Note',
              age: 22,
              description: 'this is my second sql app',
              email: 'harshsharmadlp2003@gmail.com',
            ),
          )
              .then((value) {
            print('data added');
            setState(() {
              notesList = dbHelper!.getnotesList();
            });
          }).onError((error, stackTrace) {
            print(error.toString());
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
