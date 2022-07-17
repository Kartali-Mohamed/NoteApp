import 'package:flutter/material.dart';
import 'package:note_app_php/components/crud.dart';
import 'package:note_app_php/constant/linkapi.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpState();
  }
}

class SignUpState extends State<SignUp> {
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  Crud _crud = Crud();

  // SignUp fonction
  signUp() async {
    if (formstate.currentState!.validate()) {
      var response = await _crud.postRequest(linkSignup, {
        "username": usernamecontroller.text,
        "email": emailcontroller.text,
        "password": passwordcontroller.text,
      });

      if (response['status'] == "success") {
        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
      } else {
        AlertDialog(
          title: Text("Alert"),
          content: Text("SignUp fail"),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp"),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Form(
          key: formstate,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Username Input
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please enter your username";
                  }
                },
                controller: usernamecontroller,
                maxLines: 1,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Username",
                  suffixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),
              // Email Input
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please enter your email";
                  }
                },
                controller: emailcontroller,
                maxLines: 1,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                  suffixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20),
              // Password Input
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please enter your password";
                  }
                },
                controller: passwordcontroller,
                maxLines: 1,
                obscureText: true,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                  suffixIcon: Icon(Icons.visibility),
                ),
              ),
              // Move to login
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text("if you have an account "),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed("login");
                      },
                      child: Text(
                        "Click here",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              // Save Button
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await signUp();
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
