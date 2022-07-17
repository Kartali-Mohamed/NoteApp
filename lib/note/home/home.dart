import 'package:flutter/material.dart';
import 'package:note_app_php/components/crud.dart';
import 'package:note_app_php/constant/linkapi.dart';
import 'package:note_app_php/main.dart';
import 'package:note_app_php/note/crud/editnote.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Crud _crud = Crud();

  // View Function
  getNotes() async {
    var response = await _crud
        .postRequest(linkViewNotes, {"id": sharedPref.getString("id")});
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
              onPressed: (() {
                sharedPref.clear();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("login", (route) => false);
              }),
              icon: Icon(Icons.exit_to_app)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("addnote");
        },
        child: Icon(Icons.add_rounded),
      ),
      body: Container(
        color: Color.fromARGB(47, 158, 158, 158),
        padding: EdgeInsets.all(8),
        child: FutureBuilder(
            future: getNotes(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data['status'] == 'fail') {
                  return Center(
                    child: Text("NOT FOUND NOTES"),
                  );
                }
                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data['data'].length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                            title: Text(
                                "${snapshot.data['data'][index]['notes_title']}"),
                            subtitle: Text(
                                "${snapshot.data['data'][index]['notes_content']}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: ((context) => EditNote(
                                                    notes: snapshot.data['data']
                                                        [index],
                                                  ))));
                                    },
                                    icon: Icon(Icons.edit_rounded)),
                                IconButton(
                                    onPressed: () async {
                                      var response = await _crud.postRequest(
                                          linkDeleteNotes, {
                                        "id": snapshot.data['data'][index]
                                                ['notes_id']
                                            .toString()
                                      });
                                      if (response["status"] == "success") {
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                "home", (route) => false);
                                      }
                                    },
                                    icon: Icon(Icons.delete_rounded)),
                              ],
                            )),
                      );
                    });
              }

              return Center(
                child: Text("Loading.."),
              );
            }),
      ),
    );
  }
}
