import 'package:flutter/material.dart';
import 'package:note_app_php/components/crud.dart';
import 'package:note_app_php/constant/linkapi.dart';
import 'package:note_app_php/main.dart';

class EditNote extends StatefulWidget {
  final notes;
  EditNote({Key? key, this.notes}) : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController contentcontroller = TextEditingController();
  Crud _crud = Crud();

  // Edit Function
  editNote() async {
    if (formstate.currentState!.validate()) {
      var response = await _crud.postRequest(linkEditNotes, {
        "title": titlecontroller.text,
        "content": contentcontroller.text,
        "id": widget.notes['notes_id'].toString(),
      });
      if (response['status'] == "success") {
        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Alert"),
                content: Text("$response['status']"),
              );
            });
      }
    }
  }

  @override
  void initState() {
    titlecontroller.text = widget.notes['notes_title'];
    contentcontroller.text = widget.notes['notes_content'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Note"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: formstate,
          child: Column(
            children: [
              // Title Input
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please enter your title";
                  }
                },
                controller: titlecontroller,
                maxLength: 15,
                decoration: InputDecoration(
                  label: Text("Title"),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title_rounded),
                ),
              ),
              SizedBox(height: 10),
              // Content Note Input
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please enter your title";
                  }
                },
                controller: contentcontroller,
                maxLength: 159,
                minLines: 1,
                maxLines: 3,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  label: Text("Note"),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note_rounded),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      await editNote();
                    },
                    child: Text("Save Note")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
