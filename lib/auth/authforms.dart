import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/main.dart';
import 'package:flutter/src/material/colors.dart';
// import 'dart:html';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _formkey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  List list = [];
  bool isLoginPage = false;
  bool flag = false;
  bool flagforauthentication = false;

  startauthentication() async {
    setState(() {
      flagforauthentication = true;
    });
    final validity = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (validity == true) {
      _formkey.currentState?.save();
      await submitform(_email, _password, _username, list);
    }
    setState(() {
      flagforauthentication = false;
    });
  }

  submitform(
      String eemail, String ppassword, String uusername, List list) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential userCredential;
    try {
      if (isLoginPage) {
        setState(() {
          flag == true;
        });

        userCredential = await auth.signInWithEmailAndPassword(
            email: eemail, password: ppassword);
        setState(() {
          flag == false;
        });
      } else {
        setState(() {
          flag == true;
        });
        userCredential = await auth.createUserWithEmailAndPassword(
          email: eemail,
          password: ppassword,
        );
        String uid = userCredential.user!.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': uusername,
          'email': eemail,
          'list': list,
        });
        setState(() {
          flag == false;
        });
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isLoginPage)
                      TextFormField(
                        keyboardType: TextInputType.text,
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Incorrenct username";
                          } else {
                            return null;
                          }
                        },
                        onSaved: ((value) {
                          _username = value!;
                        }),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(),
                          ),
                          labelText: "Enter Username",
                          labelStyle: GoogleFonts.roboto(),
                        ),
                      ),
                    if (!isLoginPage)
                      const SizedBox(
                        height: 10.0,
                      ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return "Incorrenct email";
                        } else {
                          return null;
                        }
                      },
                      onSaved: ((value) {
                        _email = value!;
                      }),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(),
                        ),
                        labelText: "Enter Email",
                        labelStyle: GoogleFonts.roboto(),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Incorrenct Password";
                        } else {
                          return null;
                        }
                      },
                      onSaved: ((value) {
                        _password = value!;
                      }),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(),
                        ),
                        labelText: "Enter Password",
                        labelStyle: GoogleFonts.roboto(),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0)),
                      height: 60,
                      width: double.infinity,
                      padding: EdgeInsets.all(8),
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor),
                          ),
                          onPressed: () async {
                            await startauthentication();
                          },
                          child: isLoginPage
                              ? flag
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : flagforauthentication
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text("Login")
                              : flag
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : flagforauthentication
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text("Signup")),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isLoginPage = !isLoginPage;
                          });
                        },
                        child: isLoginPage
                            ? const Text("Create a new account.")
                            : const Text("Already have an account?"),
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
