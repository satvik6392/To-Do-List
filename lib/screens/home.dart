import 'dart:ffi';
import 'package:to_do/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

// import 'dart:html';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // List _list = [];
  bool flag = true;
  String username = '';
  final TextEditingController _t1 = TextEditingController();
  late DocumentSnapshot snap;
  late Map<String, dynamic> snapdata = snap.data() as Map<String, dynamic>;

  Future<void> getdata() async {
    snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      flag = false;
      username = snapdata['username'];
    });
  }

  Future<void> addtodo() async {
    // FocusManager.instance.primaryFocus?.unfocus();
    (snapdata['list'] as List).add(_t1.text);
    _t1.clear();
    setState(() {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'list': snapdata['list'] as List});
    });
  }

  Future<void> deletefromtodo(context, index) async {
    (snapdata['list'] as List).removeAt(index);
    setState(() {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'list': snapdata['list'] as List});
    });
  }

  @override
  Widget build(BuildContext context) {
    getdata();
    return flag
        ?const Center(
            child: SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(),
          ))
        : Scaffold(
            appBar: AppBar(
              title: Text("Welcome, $username"),
              backgroundColor: Theme.of(context).primaryColor,
              actions: [
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Do you want to logout?"),
                        duration: const Duration(seconds: 1, milliseconds: 500),
                        action: SnackBarAction(
                            label: "Yes",
                            onPressed: () {
                              FirebaseAuth auth = FirebaseAuth.instance;
                              auth.signOut();
                            }),
                        behavior: SnackBarBehavior.floating,
                        elevation: 100,
                        // animation: AnimatedSnackBar(builder: builder),
                      ),
                    );
                  },
                  child: const Icon(Icons.logout),
                ),
              ],
            ),
            body: Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 8)),
                Container(
                  width: (MediaQuery.of(context).size.width),
                  padding: const EdgeInsets.only(
                    left: 4,
                    right: 4,
                  ),
                  height: 50,
                  child: TextField(
                    controller: _t1,
                    
                    decoration: InputDecoration(
                      filled: true,
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      fillColor: Colors.grey,
                      
                      // suffix: TextButton(onPressed: (){}, child: Text("Add",style: TextStyle(fontSize: 20),),),
                      // contentPadding: EdgeInsets.all(8.0),
                      suffixIcon: TextButton.icon(
                        onPressed: () {
                          if(_t1.text != '')
                          {
                          addtodo();
                          }
                        },
                        icon: const Text("Add",style: TextStyle(color: Colors.black),),
                        label: const Text(""),
                      ),
                      labelText: "Add todo",
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: ListView.builder(
                    // semanticChildCount: 1,
                    // shrinkWrap: false,
                    // scrollDirection: Axis.horizontal,
                    itemCount: (snapdata['list'] as List).length,
                    itemBuilder: ((context, index) {
                      int count = index + 1;
                      return Container(
                        padding: EdgeInsets.all(2),
                        child: ListTile(
                          // focusColor: Colors.blue,
                          // selectedColor: Colors.blue,
                          iconColor: Colors.black54,
                          tileColor: Colors.teal,
                          title: Text((snapdata['list'] as List)[index]),
                          leading: Text("$count"),
                          trailing: IconButton(
                              onPressed: () {
                                deletefromtodo(context, index);
                              }, icon: Icon(Icons.delete)),
                        ),
                      );
                    }),
                  ),
                )
              ],
            ),
          );
  }
}
