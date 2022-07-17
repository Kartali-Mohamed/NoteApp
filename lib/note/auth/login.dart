import 'package:flutter/material.dart';
import 'package:note_app_php/components/crud.dart';
import 'package:note_app_php/constant/linkapi.dart';
import 'package:note_app_php/main.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  Crud _crud = Crud();

  // Login fonction
  login() async {
    if (formstate.currentState!.validate()) {
      var response = await _crud.postRequest(linkLogin, {
        "email": emailcontroller.text,
        "password": passwordcontroller.text,
      });

      if (response['status'] == "success") {
        sharedPref.setString("id", response['data']['id'].toString());
        sharedPref.setString(
            "username", response['data']['username'].toString());
        sharedPref.setString("email", response['data']['email'].toString());
        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Alert"),
                content: Text("Please enter your correct account"),
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Form(
          key: formstate,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text("if you haven't an account "),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed("signup");
                      },
                      child: Text(
                        "Click here",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              // Login Button
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await login();
                  },
                  child: Text(
                    "Login",
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
