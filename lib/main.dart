import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_arc_speed_dial/flutter_speed_dial_menu_button.dart';
import 'package:tailorapp/addEventmodel.dart';
import 'package:tailorapp/completedOrders.dart';
import 'package:tailorapp/cusCompletedOrders.dart';
import 'package:tailorapp/customerdetails.dart';
import 'package:tailorapp/orderlistmodel.dart';
import 'package:tailorapp/userdetailsmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_arc_speed_dial/flutter_arc_speed_dial.dart';
import 'package:flutter_arc_speed_dial/main_menu_floating_action_button.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

customcolors cobj=new customcolors();
bool isplatformandroid=false;
int webWidth=700;
void main() async {

    WidgetsFlutterBinding.ensureInitialized();
  const fbconfig=FirebaseOptions(
      apiKey: "AIzaSyA7SR2bVVRO-mXLDNhfhsDyUw0ERpbtq5g",
      authDomain: "tailorhelperapp.firebaseapp.com",
      databaseURL: "https://tailorhelperapp-default-rtdb.firebaseio.com",
      projectId: "tailorhelperapp",
      storageBucket: "tailorhelperapp.appspot.com",
      messagingSenderId: "297206631507",
      appId: "1:297206631507:web:484db7b1cb045f90f08aa6",
      measurementId: "G-TCY4DNMSYQ"
  );
  if(kIsWeb){
    await Firebase.initializeApp(
      options: fbconfig
    );
  }else{
    await Firebase.initializeApp();
  }
  // await Firebase.initializeApp(
  //     options: );
  if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android)) {
    // Some android/ios specific code
    isplatformandroid=true;
  }
  else if ((defaultTargetPlatform == TargetPlatform.linux) || (defaultTargetPlatform == TargetPlatform.macOS) || (defaultTargetPlatform == TargetPlatform.windows)) {
    isplatformandroid=false;
    // Some desktop specific code there
  }
  else {
    // Some web specific code there

  }
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/': (context) => LoginPage(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/loginhome': (context) => loginhome(),
      '/forgetpass':(context)=>forgetPassPage(),
      '/register':(context)=>RegisterPage(),
      '/dashboardpage':(context)=>dashboardpage(),
    },
  ));
  // runApp(const LoginPage());
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool alreadyLogged = false;
  String useruid = "";

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Barlow'),
      home: alreadyLogged ? dashboardpage(useruid: useruid) :  loginhome(),
    );
  }

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        alreadyLogged = false;
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        setState(() {
          alreadyLogged = true;
          useruid = user.uid.toString();
        });
      }
    });
  }
}

class loginhome extends StatefulWidget {
  const loginhome({Key? key}) : super(key: key);

  @override
  _loginhomeState createState() => _loginhomeState();
}

class _loginhomeState extends State<loginhome> {
  String? useruid = "";
  FirebaseAuth auth = FirebaseAuth.instance;

  // FirebaseAuth.instance
  //     .authStateChanges()
  //     .listen((User? user) {
  // if (user == null) {
  // print('User is currently signed out!');
  // } else {
  // print('User is signed in!');
  // }
  // });
  String email = " ";
  String password = " ";
  late FocusNode passFnode;




  @override
  void initState() {
    super.initState();
    passFnode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    passFnode.dispose();

    super.dispose();
  }
  bool _loading=false;

  void showToast(String s){
    Fluttertoast.showToast(msg: s);
  }
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(fontFamily: 'Barlow'),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 400,
                  child: Image(
                      image: AssetImage("images/img1.png")
                  )
              ),
              Container(
                width: 250,
                child: TextField(
                  cursorColor: cobj.violet,
                  cursorHeight: 20,
                  onChanged: (String s) {
                    email = s;
                  },
                  onSubmitted: (s) {
                    passFnode.requestFocus();
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: cobj.violet, width: 2.0),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    border: OutlineInputBorder(),
                      labelText: "EMAIL",
                      labelStyle: TextStyle(color: cobj.violet)
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
              ),
              Container(
                width: 250,
                child: TextField(
                  cursorHeight: 20,
                  cursorColor: cobj.violet,
                  focusNode: passFnode,
                  onChanged: (String s) {
                    password = s;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: cobj.violet, width: 2.0),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    border: OutlineInputBorder(),
                      labelText: "PASSWORD",
                      labelStyle: TextStyle(color: cobj.violet)
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      child: ElevatedButton(
                          onPressed: () async {
                            try {
                              UserCredential usercred = await FirebaseAuth
                                  .instance
                                  .signInWithEmailAndPassword(
                                      email: email, password: password);
                              useruid = usercred.user?.uid;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => dashboardpage(
                                            useruid: useruid,
                                          )));
                            } on FirebaseAuthException catch (e) {
                              if(e.code=="user-not-found")
                                showToast("USER NOT FOUND");
                              else if(e.code=="invalid-email")
                                showToast("INVALID EMAIL");
                              else if(e.code=="wrong-password")
                                showToast("WRONG PASSWORD");
                            } catch (e) {
                              Fluttertoast.showToast(msg: e.toString());
                            }
                          },
                          style:
                              ElevatedButton.styleFrom(primary: cobj.violet,elevation: 4,shadowColor: cobj.darksandal,shape:RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                              )),
                          child: Text("LOGIN")),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      width: 150,
                      child: ElevatedButton(
                          onPressed: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage()));
                            // try {
                            //   UserCredential userCredential = await FirebaseAuth
                            //       .instance
                            //       .createUserWithEmailAndPassword(
                            //     email: email,
                            //     password: password,
                            //   );
                            //   var uid = userCredential.user?.uid;
                            //   await FirebaseDatabase.instance
                            //       .ref(uid.toString())
                            //       .child("CUSTOMER UIDS")
                            //       .child("ID")
                            //       .set(0);
                            //   await FirebaseDatabase.instance
                            //       .ref(uid.toString())
                            //       .child("PENDING WORKS");
                            //   await FirebaseDatabase.instance
                            //       .ref(uid.toString())
                            //       .child("customers");
                            //   await FirebaseDatabase.instance
                            //       .ref(uid.toString())
                            //       .child("ORDER NO")
                            //       .child("ID")
                            //       .set(0);
                            // } on FirebaseAuthException catch (e) {
                            //   Fluttertoast.showToast(
                            //       msg: e.code.toString(),
                            //       toastLength: Toast.LENGTH_SHORT,
                            //       gravity: ToastGravity.CENTER,
                            //       timeInSecForIosWeb: 1,
                            //       backgroundColor: Colors.red,
                            //       textColor: Colors.white,
                            //       fontSize: 16.0);
                            //   if (e.code == 'weak-password') {
                            //     print('The password provided is too weak.');
                            //   } else if (e.code == 'email-already-in-use') {
                            //     print(
                            //         'The account already exists for that email.');
                            //   }
                            // } catch (e) {
                            //   Fluttertoast.showToast(
                            //       msg: e.toString(),
                            //       toastLength: Toast.LENGTH_SHORT,
                            //       gravity: ToastGravity.CENTER,
                            //       timeInSecForIosWeb: 1,
                            //       backgroundColor: Colors.red,
                            //       textColor: Colors.white,
                            //       fontSize: 16.0);
                            //   print(e.toString());
                            // }
                          },

                          style:
                              ElevatedButton.styleFrom(primary: cobj.violet,elevation: 3,shape:RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              )),
                          child: Text("REGISTER")),
                    ),

                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>forgetPassPage()));
                },
                child: Text("Forget Password",style: TextStyle(color: cobj.violet),),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget registerDialog() {
  //   return AlertDialog(
  //     content: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Container(
  //           width: 250,
  //           child: TextField(
  //             cursorColor: colorObj.violet,
  //             cursorHeight: 20,
  //             controller: registerEmail,
  //             onSubmitted: (s) {
  //               registerPassNode.requestFocus();
  //             },
  //             autofocus: true,
  //             decoration: InputDecoration(
  //               focusedBorder: OutlineInputBorder(
  //                 borderSide: BorderSide(color: colorObj.violet, width: 2.0),
  //                 borderRadius: BorderRadius.circular(13),
  //               ),
  //               border: OutlineInputBorder(),
  //               hintText: "EMAIL",
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 30,
  //         ),
  //         Container(
  //           width: double.infinity,
  //         ),
  //         Container(
  //           width: 250,
  //           child: TextField(
  //             focusNode: registerPassNode,
  //             controller: registerPass,
  //             obscureText: true,
  //             decoration: InputDecoration(
  //               border: OutlineInputBorder(),
  //               hintText: "PASSWORD",
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 20,
  //         ),
  //         ElevatedButton(
  //           onPressed: () async {
  //             try {
  //               UserCredential userCredential =
  //                   await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //                 email: registerEmail.text.toString(),
  //                 password: registerPass.text.toString(),
  //               );
  //               var uid = userCredential.user?.uid;
  //               await FirebaseDatabase.instance
  //                   .ref(uid.toString())
  //                   .child("CUSTOMER UIDS")
  //                   .child("ID")
  //                   .set(0);
  //               await FirebaseDatabase.instance
  //                   .ref(uid.toString())
  //                   .child("PENDING WORKS");
  //               await FirebaseDatabase.instance
  //                   .ref(uid.toString())
  //                   .child("customers");
  //               await FirebaseDatabase.instance
  //                   .ref(uid.toString())
  //                   .child("ORDER NO")
  //                   .child("ID")
  //                   .set(0);
  //               Navigator.pop(context);
  //             } on FirebaseAuthException catch (e) {
  //               Fluttertoast.showToast(
  //                   msg: e.code.toString(),
  //                   toastLength: Toast.LENGTH_SHORT,
  //                   gravity: ToastGravity.CENTER,
  //                   timeInSecForIosWeb: 1,
  //                   backgroundColor: Colors.red,
  //                   textColor: Colors.white,
  //                   fontSize: 16.0);
  //               if (e.code == 'weak-password') {
  //                 print('The password provided is too weak.');
  //               } else if (e.code == 'email-already-in-use') {
  //                 print('The account already exists for that email.');
  //               }
  //             } catch (e) {
  //               Fluttertoast.showToast(
  //                   msg: e.toString(),
  //                   toastLength: Toast.LENGTH_SHORT,
  //                   gravity: ToastGravity.CENTER,
  //                   timeInSecForIosWeb: 1,
  //                   backgroundColor: Colors.red,
  //                   textColor: Colors.white,
  //                   fontSize: 16.0);
  //               print(e.toString());
  //             }
  //           },
  //           child: Text("REGISTER"),
  //           style: ElevatedButton.styleFrom(primary: colorObj.violet),
  //         )
  //       ],
  //     ),
  //   );
  }

class forgetPassPage extends StatefulWidget {
  const forgetPassPage({Key? key}) : super(key: key);

  @override
  _forgetPassPageState createState() => _forgetPassPageState();
}

class _forgetPassPageState extends State<forgetPassPage> {
  var forgetEmail = TextEditingController();
  bool _forgerPassLoading=false;
  String _finishtext="";
  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    forgetEmail.dispose();
    super.dispose();
  }
  void forgetPass(String forEmail) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: forEmail).then((value) {
      setState(() {
        _forgerPassLoading=false;
        _finishtext="Reset link sent to your mail id";
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Theme(
      data:ThemeData(fontFamily: 'Barlow'),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: cobj.violet,
            leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){Navigator.pop(context);},),
          ),
          body: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 30,),
                Container(
                  width: 280,
                  child: TextField(
                    autofocus: true,
                    cursorColor: cobj.violet,
                    cursorHeight: 20,
                    controller: forgetEmail,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: cobj.violet, width: 2.0),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      border: OutlineInputBorder(),
                        labelText: "EMAIL",
                        labelStyle: TextStyle(color: cobj.violet)
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                ElevatedButton(
                    onPressed: () {

                      if (forgetEmail.text
                          .toString()
                          .isNotEmpty) {
                        setState(() {
                          _forgerPassLoading=true;
                        });
                        forgetPass(forgetEmail.text.toString());
                      } else {
                        Fluttertoast.showToast(
                            msg: "EMAIL FIELD IS EMPTY");
                      }
                    },
                    style: ElevatedButton.styleFrom(primary: cobj.violet),
                    child: Text("SEND RESET LINK")
                ),
                _forgerPassLoading?CircularProgressIndicator(color: cobj.violet,):Text(_finishtext),
              ],
            ),
          ),
        ),
    );

  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var registerEmail = TextEditingController();
  var registerPass = TextEditingController();
  FocusNode registerPassNode = FocusNode();

  @override
  void dispose() {
    registerEmail.dispose();
    registerPass.dispose();
    super.dispose();
  }
  bool _loading=false;
  bool _obscuretext=true;
  @override
  Widget build(BuildContext context) {
    return Theme(data: ThemeData(fontFamily: 'Barlow'), child: Scaffold(
      appBar: AppBar(
        leading: IconButton(icon:Icon(Icons.arrow_back),onPressed: (){Navigator.pop(context);},),
        backgroundColor: cobj.violet,
      ),
      body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 280,
                child: TextField(
                  cursorColor: cobj.violet,
                  cursorHeight: 20,
                  controller: registerEmail,
                  onSubmitted: (s) {
                    registerPassNode.requestFocus();
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: cobj.violet,
                            width: 2.0),
                        borderRadius:
                        BorderRadius.circular(13),
                      ),
                      border: OutlineInputBorder(),
                      labelText: "EMAIL",
                      labelStyle: TextStyle(color: cobj.violet)
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
              ),
              Container(
                width: 280,
                child: TextField(
                  cursorHeight: 20,
                  cursorColor: cobj.violet,
                  focusNode: registerPassNode,
                  controller: registerPass,
                  obscureText: _obscuretext,
                  decoration: InputDecoration(

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: cobj.violet,
                          width: 2.0),
                      borderRadius:
                      BorderRadius.circular(13),
                    ),
                    border: OutlineInputBorder(),
                    labelText: "PASSWORD",
                    labelStyle: TextStyle(color: cobj.violet),
                    suffixIcon: IconButton(icon:Icon(CupertinoIcons.eye_solid,color: cobj.darksandal,),onPressed: (){
                      setState(() {
                        _obscuretext=!_obscuretext;
                      });
                    },),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _loading=true;
                  });
                  try {
                    UserCredential userCredential =
                    await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email:
                      registerEmail.text.toString(),
                      password:
                      registerPass.text.toString(),
                    ).then((value){
                      setState(() {
                        _loading=false;
                      });
                      return value;
                    });
                    //await userCredential.user?.sendEmailVerification();
                    var uid = userCredential.user?.uid;
                    await FirebaseDatabase.instance
                        .ref(uid.toString())
                        .child("CUSTOMER UIDS")
                        .child("ID")
                        .set(0);
                    await FirebaseDatabase.instance
                        .ref(uid.toString())
                        .child("PENDING WORKS");
                    await FirebaseDatabase.instance
                        .ref(uid.toString())
                        .child("customers");
                    await FirebaseDatabase.instance
                        .ref(uid.toString())
                        .child("ORDER NO")
                        .child("ID")
                        .set(0);
                    Navigator.of(context).pop();
                  } on FirebaseAuthException catch (e) {
                    if(e.code == 'email-already-in-use'){
                      showToast("EMAIL ALREADY IN USE");
                      setState(() {
                        _loading=false;
                      });
                    }
                    else if(e.code=="invalid-email"){
                      showToast("INVALID EMAIL");
                      setState(() {
                        _loading=false;
                      });
                    }
                    else if(e.code=='weak=password'){
                      showToast("WEAK PASSWORD");
                      setState(() {
                        _loading=false;
                      });
                    }
                    // Fluttertoast.showToast(
                    //     msg: e.code.toString(),
                    //     toastLength: Toast.LENGTH_SHORT,
                    //     gravity: ToastGravity.CENTER,
                    //     timeInSecForIosWeb: 1,
                    //     backgroundColor: Colors.red,
                    //     textColor: Colors.white,
                    //     fontSize: 16.0);
                    // if (e.code == 'weak-password') {
                    //   print(
                    //       'The password provided is too weak.');
                    // } else if (e.code ==
                    //     'email-already-in-use') {
                    //   print(
                    //       'The account already exists for that email.');
                    // }
                  } catch (e) {
                    Fluttertoast.showToast(
                        msg: e.toString(),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
                child: Text("REGISTER"),
                style: ElevatedButton.styleFrom(
                    primary: cobj.violet),
              ),
              _loading?CircularProgressIndicator(color:cobj.violet):Text("")
            ],
          )
      ),
    ),);
  }
  void showToast(String s){
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        fontSize: 16.0);
  }

}

class dashboardpage extends StatefulWidget {
  const dashboardpage({Key? key, @required this.useruid}) : super(key: key);
  final String? useruid;

  @override
  _dashboardpageState createState() => _dashboardpageState();
}

class _dashboardpageState extends State<dashboardpage> {
  late List<Widget> widlist;

  @override
  void initState() {
    // FirebaseMessaging.onMessage.listen((event) {
    //   print(event.notification?.title);
    // });
    widlist = <Widget>[
      dashboard(widget.useruid.toString()),
      // pendingwork(widget.useruid.toString()),
      users(widget.useruid),
      myaccount(widget.useruid.toString()),
    ];
  }

  int selected = 0;

  void navigationfunc(int i) {
    setState(() {
      selected = i;
      if (i == 0) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(fontFamily: 'Barlow'),
      child: Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: true,
        //   leading: IconButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: Icon(Icons.arrow_back),)
        // ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if(constraints.maxWidth<800){
              return widlist.elementAt(selected);
            }
            else{
              return Container(color: Colors.red,);
            }
          },),
        bottomNavigationBar: LayoutBuilder(
          builder:(BuildContext context,BoxConstraints constraints){
            if()
          }
        )
      ),
    );
  }
}

class webdashboard extends StatefulWidget {
  const webdashboard({Key? key}) : super(key: key);

  @override
  State<webdashboard> createState() => _webdashboardState();
}

class _webdashboardState extends State<webdashboard> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class dashboard extends StatefulWidget {
  final String userUid;

  const dashboard(this.userUid, {Key? key}) : super(key: key);

  @override
  _dashboardState createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  String penOrL="";
  String compOrL="";
  String paypendOrl="";
  late AnimationController animcont;
  void lengthcalfunc() async{
    penOrL=await lengthfunc(widget.userUid,"PENDING WORKS");
    compOrL=await lengthfunc(widget.userUid,"COMPLETED ORDERS");
    paypendOrl=await lengthfunc(widget.userUid,"PAYMENT PENDING");
    setState(() {

    });
  }
  @override
  void initState() {
    lengthcalfunc();
  }


  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(fontFamily: 'Barlow'),
      child: Scaffold(
          appBar: AppBar(
            title: Text("DASHBOARD"),
            centerTitle: true,
            backgroundColor: cobj.violet,
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10,0),
            child: Align(
              alignment: AlignmentDirectional.topCenter,
              child: Container(
                width: isplatformandroid
                    ? MediaQuery.of(context).size.width
                    : 700,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      child: Container(
                        height: 120,
                        child: Card(
                          elevation: 3,
                          color: cobj.sandal,
                          child:Padding(
                            padding:EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex:1,
                                    child: Container(child: Text("PENDING ORDERS"),)
                                ),
                                Expanded(flex:2,child: Container(width: double.infinity,)),
                                Expanded(flex:1,child: Container(child:CircleAvatar(backgroundColor: cobj.violet,child: Text(penOrL,style: TextStyle(color: cobj.sandal),)))),
                              ],
                            ),
                          )
                        ),
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>pendingwork(widget.userUid.toString())));
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        height: 120,
                        child: Card(
                            elevation: 3,
                            color: cobj.sandal,
                            child:Padding(
                              padding:EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex:1,
                                      child: Container(child: Text("PAYMENT PENDING"),)
                                  ),
                                  Expanded(flex:2,child: Container(width: double.infinity,)),
                                  Expanded(flex:1,child: Container(child:CircleAvatar(backgroundColor: cobj.violet,child: Text(paypendOrl,style: TextStyle(color: cobj.sandal),)))),
                                ],
                              ),
                            )
                        ),
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>paypendpage(widget.userUid.toString())));
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        height: 120,
                        child: Card(
                            elevation: 3,
                            color: cobj.sandal,
                            child:Padding(
                              padding:EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex:1,
                                      child: Container(child: Text("COMPLETED ORDERS"),)
                                  ),
                                  Expanded(flex:2,child: Container(width: double.infinity,)),
                                  Expanded(flex:1,child: Container(child:CircleAvatar(backgroundColor: cobj.violet,child: Text(compOrL,style: TextStyle(color: cobj.sandal),)))),
                                ],
                              ),
                            )
                        ),
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>compOrders(widget.userUid)));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
      //     floatingActionButton: FloatingActionButton(
      //     onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context)=>AddEvent(widget.userUid))); },
      //
      // ),
          // body: pendingwork(widget.userUid),
        ),
    );
  }
}

class users extends StatefulWidget {
  const users(@required this.useruid, {Key? key}) : super(key: key);
  final String? useruid;

  @override
  _usersState createState() => _usersState();
}

class _usersState extends State<users> {
  List<customerdetailsmodel> fetchedUsers = [];
  List<customerdetailsmodel> templist = [];
  bool _loading = true;
  bool _empty = true;
  void arun() async {
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref(widget.useruid.toString())
        .child("customers");
    Stream<DatabaseEvent> stream = userRef.onValue;
    stream.listen((event) async {
      fetchedUsers.clear();
      var iterator = event.snapshot.children.iterator;
      while (iterator.moveNext()) {
        String custoname =
            iterator.current.child("CUSTOMER NAME").value.toString();
        String customobile =
            iterator.current.child("CUSTOMER MOBILE NO").value.toString();
        //String imglink=iterator.current.child("PHOTO LINK").value.toString();
        String gender = iterator.current.child("GENDER").value.toString();
        String cusUid =
            iterator.current.child("CUSTOMER UNIQUE ID").value.toString();
        //print(custoname+customobile);
        customerdetailsmodel obj = customerdetailsmodel.temp(
            custoname, customobile, int.parse(cusUid), gender);
        fetchedUsers.add(obj);
      }
      var a=customerdetails.of(context)?.cusdetails=fetchedUsers;
      setState(() {
        if (fetchedUsers.isNotEmpty)
          _empty = false;
        else {
          _empty = true;
        }
        _loading = false;
      });
    });
    //Query q=userRef.orderByChild("CUSTOMER NAME");
    //DataSnapshot event= await userRef.get();

    // print(fetchedUsers.elementAt(0).customermobile);
  }

  void initState() {
    //_loading=true;
    arun();
  }
  void tempfunc(int cusid) async{
    String cusidstr=cusid.toString();
    DataSnapshot event= await FirebaseDatabase.instance.ref(widget.useruid).child("PENDING WORKS").get();
    var iter=event.children.iterator;
    while(iter.moveNext()){
      if(cusidstr==iter.current.child("CUSTOMER ID").value.toString()){
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(fontFamily: 'Barlow'),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: cobj.violet,
          title: Text("CUSTOMERS"),
          centerTitle: true,
          actions: [
            IconButton(icon:Icon(Icons.add),onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => addusers(useruid: widget.useruid)
                  )
              ).then((value) {
                setState(() {

                });
              });}
            ),
          ],
        ),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(
                color: cobj.violet,
              ))
            : _empty
                ? Center(
                    child: Text("NO CUSTOMERS ADDED")
                  )
                : Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: Container(
                      width: isplatformandroid
                          ? MediaQuery.of(context).size.width
                          : webWidth.toDouble(),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: fetchedUsers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: Container(
                              height: 120,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10,10,10,0),
                                child: Card(
                                  color: Color(0xfff7ebe6),
                                  elevation: 3,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Row(
                                      children: [
                                        fetchedUsers.elementAt(index).gender ==
                                                "M"
                                            ? CircleAvatar(
                                                backgroundColor:
                                                    Color(0xffc4a99d),
                                                backgroundImage: AssetImage(
                                                    "images/male1.png"),
                                                radius: 40,
                                              )
                                            : CircleAvatar(
                                                backgroundColor:
                                                    Color(0xffc4a99d),
                                                backgroundImage: AssetImage(
                                                    "images/female1.png"),
                                                radius: 40,
                                              ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            fetchedUsers
                                                .elementAt(index)
                                                .customername,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              width: double.infinity,
                                            )),
                                        Expanded(
                                          flex: 1,
                                          child: IconButton(
                                              icon: Icon(Icons.add),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddEvent(
                                                                widget.useruid,
                                                                fetchedUsers
                                                                    .elementAt(
                                                                        index)
                                                                    .customerUid
                                                                    .toString())));
                                              }),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (_) => customerPage(
                                      widget.useruid.toString(),
                                      fetchedUsers.elementAt(index)),
                                ),
                              );
                              tempfunc(fetchedUsers.elementAt(index).customerUid);
                              // showDialog(
                              //     context: context,
                              //     builder: (context) {
                              //       return AlertDialog(
                              //           content: Column(
                              //         mainAxisSize: MainAxisSize.min,
                              //         children: [
                              //           fetchedUsers
                              //                       .elementAt(index)
                              //                       .gender ==
                              //                   "M"
                              //               ? CircleAvatar(
                              //                   backgroundColor:
                              //                       colorobj.darksandal,
                              //                   backgroundImage: AssetImage(
                              //                       "images/male1.png"),
                              //                   radius: 40,
                              //                 )
                              //               : CircleAvatar(
                              //                   backgroundColor:
                              //                       colorobj.darksandal,
                              //                   backgroundImage: AssetImage(
                              //                       "images/female1.png"),
                              //                   radius: 40,
                              //                 ),
                              //           Text("NAME : " +
                              //               fetchedUsers
                              //                   .elementAt(index)
                              //                   .customername),
                              //           Text("ID : " +
                              //               fetchedUsers
                              //                   .elementAt(index)
                              //                   .customerUid
                              //                   .toString()),
                              //           Text(fetchedUsers
                              //               .elementAt(index)
                              //               .customermobile),
                              //           SizedBox(
                              //             height: 30,
                              //           ),
                              //           Padding(
                              //             padding: EdgeInsets.fromLTRB(
                              //                 50, 0, 0, 0),
                              //             child: Row(
                              //               children: [
                              //                 FloatingActionButton(
                              //                   onPressed: () {
                              //                     FlutterPhoneDirectCaller
                              //                         .callNumber(fetchedUsers
                              //                             .elementAt(
                              //                                 index)
                              //                             .customermobile);
                              //                   },
                              //                   child: Icon(Icons.call),
                              //                   backgroundColor:
                              //                       colorobj.violet,
                              //                 ),
                              //                 SizedBox(
                              //                   width: 30,
                              //                 ),
                              //                 FloatingActionButton(
                              //                   onPressed: () {
                              //                     Navigator.push(
                              //                         context,
                              //                         MaterialPageRoute(
                              //                             builder: (context) => AddEvent(
                              //                                 widget
                              //                                     .useruid,
                              //                                 fetchedUsers
                              //                                     .elementAt(
                              //                                         index)
                              //                                     .customerUid
                              //                                     .toString())));
                              //                   },
                              //                   child:
                              //                       Icon(Icons.note_add),
                              //                   backgroundColor:
                              //                       colorobj.violet,
                              //                 ),
                              //               ],
                              //             ),
                              //           )
                              //         ],
                              //       ));
                              //     });
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 5,
                          );
                        },
                      ),
                    ),
                ),
      ),
    );
  }
}


class customerPage extends StatefulWidget {
  final String userUid;
  final customerdetailsmodel cusobj;
  const customerPage(this.userUid,this.cusobj, {Key? key}) : super(key: key);

  @override
  _customerPageState createState() => _customerPageState();
}

class _customerPageState extends State<customerPage> with SingleTickerProviderStateMixin{
  Map<int, String> months = {
    01: "JAN",
    02: "FEB",
    03: "MAR",
    04: "APR",
    05: "MAY",
    06: "JUN",
    07: "JUL",
    08: "AUG",
    09: "SEP",
    10: "OCT",
    11: "NOV",
    12: "DEC",
  };
  late TabController _tabController=new TabController(length: 2, vsync: this);
  List<addeventmodel> cusPendingOrder=[];
  List<addeventmodel> cusPayPendOrder=[];
  List<addeventmodel> allorders=[];
  int totalbal=0;
  void samplefunc() async{
    cusPendingOrder= await cusCompOrderFunc(widget.userUid, widget.cusobj.customerUid.toString(),"PENDING WORKS").then((value){
      setState(() {
        cusPendingOrder=value;
      });
      return value;
    });
  }
  void paypendfunc() async{
    cusPayPendOrder= await cusPayPendFunc(widget.userUid, widget.cusobj.customerUid.toString(),"PAYMENT PENDING").then((value){
      setState(() {

      });
      return value;
    });
    for(addeventmodel obj in cusPayPendOrder){
      totalbal+=int.parse(obj.balance);
    }
  }
  void orderfunc() async{
    allorders=await pending(widget.userUid.toString()).then((value){
      setState(() {
          allorders=value;
      });
      return value;
    });
  }
  String gender="F";
  @override
  void initState(){
    samplefunc();
    paypendfunc();
    orderfunc();
    if(widget.cusobj.gender=="M"){
      gender="M";
    }
    super.initState();
  }
  int balIndex=0;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(fontFamily: 'Barlow'),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: cobj.violet,
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  child: (gender=="M")?CircleAvatar(
                    backgroundColor: cobj.darksandal,
                    backgroundImage: AssetImage("images/male1.png"),
                    radius: 50,
                  ):
                  CircleAvatar(
                    backgroundColor: cobj.darksandal,
                    backgroundImage: AssetImage("images/female1.png"),
                    radius: 50,
                  ),
                ),
              ),
              Text(widget.cusobj.customerUid.toString()),
              Text(widget.cusobj.customername),
              Text(widget.cusobj.customermobile),
              ElevatedButton(onPressed: () async{
                    String mobileno=widget.cusobj.customermobile;
                    await launch("tel:$mobileno");
              }, child:Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.call),
                  Text("CALL"),
                ],
              ),
                style: ElevatedButton.styleFrom(primary: cobj.violet),
              ),
              SizedBox(height: 30,),
              TabBar(
                unselectedLabelColor: Colors.black,
                labelColor: cobj.violet,
                indicatorColor: cobj.violet,
                tabs: [
                  Tab(
                    child: Text("PENDING ORDERS",maxLines: 2,),

                  ),
                  Tab(
                    child: Text("PAYMENT PENDING",maxLines: 2,),
                  )
                ],
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                onTap: (i){
                  if(i==1){
                    setState(() {
                      balIndex=i;
                    });
                  }
                  else{
                    setState(() {
                      balIndex=i;
                    });
                  }
                },
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    (cusPendingOrder.isEmpty)?Center(child: Text("NO PENDING ORDERS FOR THIS CUSTOMER"),):Center(
                      child: Container(
                        width: isplatformandroid
                            ? MediaQuery.of(context).size.width
                            : webWidth.toDouble(),
                        child: ListView.builder(
                          itemCount: cusPendingOrder.length,
                            itemBuilder: (BuildContext context,int index){
                          return GestureDetector(
                            child: Container(
                              height: 120,
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Card(
                                color: Color(0xfff7ebe6),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                cusPendingOrder
                                                    .elementAt(index)
                                                    .title,
                                                style: TextStyle(fontSize: 25),
                                                overflow: TextOverflow
                                                    .ellipsis, // Probelm here
                                              ),
                                            ),
                                            // Text(cusNames[
                                            // cusids.elementAt(index)]
                                            //     .toString()),

                                            // Customer Name
                                            //SizedBox(height: 10,),
                                            // Text(
                                            //   '\u{20B9}'+pendingData.elementAt(index).amount,
                                            //   style: TextStyle(
                                            //     color: Colors.red,
                                            //     fontSize: 30,
                                            //     fontWeight: FontWeight.normal,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ), // Title, customer name, amount
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        width: double.infinity,
                                      ),
                                    ), // Empty container with width = infinity
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // SizedBox(
                                            //   height: 10,
                                            // ),
                                            // months.elementAt(int.parse(pendingData.elementAt(index).date.substring(3,5)))
                                            Text(
                                              months[int.parse(cusPendingOrder
                                                  .elementAt(index)
                                                  .date
                                                  .substring(3, 5))]
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 20,
                                                //color: Colors.red,
                                              ),
                                            ),
                                            CircleAvatar(
                                              backgroundColor:
                                              Color(0xff734370),
                                              child: Text(
                                                cusPendingOrder
                                                    .elementAt(index)
                                                    .date
                                                    .substring(0, 2),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ), // Date
                                  ],
                                ),
                              ),
                            ),
                            onTap: (){
                              // print("hiii");
                              // print(cusPendingOrder.elementAt(index).orderUKey.toString());
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>orderDetails(widget.userUid, allorders, cusPendingOrder.elementAt(index).orderUKey)));
                            },
                          );
                        }),
                      ),
                    ),
                    (cusPayPendOrder.isEmpty)?Center(child:Text("NO PAYMENT PENDING ORDERS")):Center(
                      child: Container(
                        width: isplatformandroid
                            ? MediaQuery.of(context).size.width
                            : webWidth.toDouble(),
                        child: ListView.builder(
                            itemCount: cusPayPendOrder.length,
                            itemBuilder: (BuildContext context,int index){
                              return GestureDetector(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(minHeight: 120),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Card(
                                      color: Color(0xfff7ebe6),
                                      child: Row(
                                        //mainAxisAlignment: MainAxisAlignment,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Text(
                                                    cusPayPendOrder
                                                        .elementAt(index)
                                                        .title,
                                                    style: TextStyle(fontSize: 25),
                                                    overflow: TextOverflow
                                                        .ellipsis, // Probelm here
                                                  ),
                                                  // Text(cusNames[
                                                  // cusids.elementAt(index)]
                                                  //     .toString()),

                                                  // Customer Name
                                                  //SizedBox(height: 10,),
                                                  // Text(
                                                  //   '\u{20B9}'+pendingData.elementAt(index).amount,
                                                  //   style: TextStyle(
                                                  //     color: Colors.red,
                                                  //     fontSize: 30,
                                                  //     fontWeight: FontWeight.normal,
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ), // Title, customer name, amount
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              width: double.infinity,
                                            ),
                                          ), // Empty container with width = infinity
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // SizedBox(
                                                  //   height: 10,
                                                  // ),
                                                  // months.elementAt(int.parse(pendingData.elementAt(index).date.substring(3,5)))
                                                  Text(
                                                    "BALANCE"
                                                    ),
                                                  Text(cusPayPendOrder.elementAt(index).balance),
                                                ],
                                              ),
                                            ),
                                          ), // Date
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: (){
                                  paypendDialog(context, cusPayPendOrder.elementAt(index), widget.userUid);
                                },
                              );
                            }),
                      ),
                    ),
                  ],
                  controller: _tabController,
                ),
              ),
              (balIndex==1)?Container(
                  color: cobj.violet,
                  height: 60,
                  child:Padding(
                    padding:EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(flex:1,child: Text("TOTAL BALANCE",style: TextStyle(color:Colors.white),)),
                        Expanded(flex:2,child:Container(width:double.infinity)),
                        Expanded(flex:1,child: Text(totalbal.toString(),style: TextStyle(color:Colors.white),)),
                      ],
                    ),
                  )
              ): SizedBox()
            ],
          ),
        )
      ),
    );
  }
}


class myaccount extends StatefulWidget {
  final String useruid;

  const myaccount(this.useruid, {Key? key}) : super(key: key);

  @override
  _myaccountState createState() => _myaccountState();
}

class _myaccountState extends State<myaccount> {
  int earnings=0;
  void func() async{
    await earningsfunc(widget.useruid).then((value) {
      setState(() {
          earnings=value;
      });
      return value;
    });
}
  @override
  void initState() {
   func();
  }
  void makeRoutePage({context,  pageRef}) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => pageRef),
            (Route<dynamic> route) => false);
  }
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(fontFamily: 'Barlow'),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff734370),
            title: Text("MY ACCOUNT"),
            centerTitle: true,
          ),
          body: Center(
            child: Container(
              width: isplatformandroid
                  ? MediaQuery.of(context).size.width
                  : webWidth.toDouble(),
              child: Column(
                children: [
                  // Container(
                  //     height: 120,
                  //     child: Padding(
                  //       padding: EdgeInsets.all(10),
                  //       child: GestureDetector(
                  //         child: Card(
                  //           elevation: 3,
                  //           child: Padding(
                  //             padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  //             child: Row(
                  //               children: [
                  //                 Expanded(
                  //                     flex: 1,
                  //                     child: Container(
                  //                       child: Text(
                  //                         "COMPLETED ORDERS : ",
                  //                         style: TextStyle(fontSize: 15),
                  //                       ),
                  //                     )),
                  //                 Expanded(
                  //                     flex: 2,
                  //                     child: Container(
                  //                       width: double.infinity,
                  //                     )),
                  //                 Expanded(
                  //                     flex: 1,
                  //                     child: Container(
                  //                         child: Text(
                  //                       "compOrderCount.toString()",
                  //                       style: TextStyle(fontSize: 20),
                  //                     )))
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //         onTap: () {
                  //           print("tapped");
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) => compOrders(widget.useruid)));
                  //         },
                  //       ),
                  //     )),
                  // // SizedBox(height: 20,),
                  GestureDetector(
                    child: Container(
                        height: 120,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Card(
                            elevation: 3,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Text(
                                          "EARNINGS : ",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        width: double.infinity,
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                          child: Text(earnings.toString())))
                                ],
                              ),
                            ),
                          ),
                        )),
                    onTap: (){
                      earningsfunc(widget.useruid);
                    },
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: cobj.violet),
                      onPressed: () {
                        //Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text("DO YOU WANT TO LOGOUT ? "),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("NO"),
                                    style: ElevatedButton.styleFrom(
                                        primary: cobj.violet),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await FirebaseAuth.instance.signOut().then((value) {
                                        makeRoutePage(context: context, pageRef: LoginPage());
                                      });


                                      //SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
                                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage(), settings: RouteSettings(name: "LoginPage")));
                                      // Navigator.popUntil(context, (route) => route.settings.name == "dashboardpage");
                                      // Navigator.push(context,
                                      //     MaterialPageRoute(builder: (context) => LoginPage()));
                                    },
                                    child: Text("YES"),
                                    style: ElevatedButton.styleFrom(
                                        primary: cobj.violet),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Text("LOGOUT"),
                    ),
                  ),

                ],
              ),
            ),
          )),
    );

  }

}

class compOrders extends StatefulWidget {
  String userUid;
  compOrders(this.userUid,{Key? key}) : super(key: key);

  @override
  State<compOrders> createState() => _compOrdersState();
}

class _compOrdersState extends State<compOrders> {
  List<addeventmodel> data = [];
  late int compOrderCount = 0;
  late int compOrderIncome = 0;
  void compOrderFunc() async {
    DatabaseReference compOrders =
    FirebaseDatabase.instance.ref(widget.userUid).child("COMPLETED ORDERS");
    DataSnapshot fdata = await compOrders.get();
    var iterator = fdata.children.iterator;
    //print(iterator.current.children.child("AMOUNT").value.toString());
    while (iterator.moveNext()) {
      addeventmodel temp = addeventmodel.withoutkey(
        iterator.current.child("WORK TITLE").value.toString(),
        iterator.current.child("WORK DESCRIPTION").value.toString(),
        iterator.current.child("DUE DATE").value.toString(),
        iterator.current.child("AMOUNT").value.toString(),
        iterator.current.child("ORDER NO").value.toString(),
        iterator.current.child("GIVEN DATE").value.toString(),
        iterator.current.child("CUSTOMER ID").value.toString(),
        iterator.current.child("CUSTOMER NAME").value.toString(),
        iterator.current.child("CUSTOMER MOBILE NO").value.toString(),
      );
      compOrderIncome += int.parse(temp.amount);
      data.add(temp);
      //compOrderCount+=1;
    }
    setState(() {
      compOrderCount = data.length;
    });
    //compOrderCount=fdata.length;
    // print(iterator.current.child("AMOUNT").value.toString());
  }

  @override
  void initState() {
      compOrderFunc();
  }
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(fontFamily: 'Barlow'),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff734370),
          title: Text("COMPLETED ORDERS"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body:(data.isEmpty)?Center(child: Text("NO COMPLETED ORDERS"),): Center(
          child: Container(
            width: isplatformandroid
                ? MediaQuery.of(context).size.width
                : webWidth.toDouble(),
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 130,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Card(
                    color: cobj.sandal,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                    child: Text(
                                  data.elementAt(index).title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                )),
                              ), // Title, customer name, amount
                              Expanded(
                                flex: 2,
                                child: Container(
                                  width: double.infinity,
                                ),
                              ), // Empty container with width = infinity
                              Expanded(
                                flex: 1,
                                child: Container(
                                    child: Text(
                                  '\u{20B9}' + data.elementAt(index).amount,
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                )),
                              ), // Date
                            ],
                          ),

                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: Text(data.elementAt(index).desc,
                          //         overflow:TextOverflow.ellipsis ,
                          //         style: TextStyle(fontSize: 15),
                          //       ),
                          //     )
                          //   ],
                          // ),
                          Row(
                            children: [
                              Text(
                                "COMPLETED ON",
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                data.elementAt(index).date,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "CUSTOMER NAME",
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                data.elementAt(index).cusname,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: data.length,
            ),
          ),
        ),
      ),
    );
  }
}

class addusers extends StatefulWidget {
  const addusers({Key? key, String? this.useruid}) : super(key: key);
  final String? useruid;

  @override
  _addusersState createState() => _addusersState();
}

enum SingingCharacter { Male, Female }

class _addusersState extends State<addusers> {
  String customername = "";
  String customerlocation = "";
  String customermobile = "";
  int customerage = 0;
  bool loading = false;
  File? imgfile;
  String tempimg = "";
  String Gender = "M";
  bool _visible = true;
  late List<String> imgs;
  final ImagePicker _picker = ImagePicker();
  var cNameCont = TextEditingController();
  var cLocCont = TextEditingController();
  var cAgeCont = TextEditingController();
  var cPhCont = TextEditingController();

  Future camerafunc(bool cameraper) async {
    final image;
    if (cameraper) {
      image =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 25);
    } else {
      image = await _picker.pickImage(source: ImageSource.gallery);
    }
    if (image?.path != null) {
      setState(() {
        imgfile = File(image!.path);
      });
    }
  }

  @override
  void dispose() {
    cNameCont.dispose();
    cLocCont.dispose();
    cAgeCont.dispose();
    cPhCont.dispose();
    super.dispose();
  }

  @override
  void initState() {
    imgs = [
      "images/female1.png",
      "images/male1.png",
    ];
    tempimg = "images/male1.png";
  }

  Future<String> uploadFile(String s) async {
    String downloadURL = "error";

    try {
      var child1 = FirebaseStorage.instance
          .ref("users/")
          .child(widget.useruid.toString())
          .child("customer")
          .child(s);
      //.putFile(imgfile!);
      await child1.putFile(imgfile!);
      downloadURL = await child1.getDownloadURL();
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
    return downloadURL;
  }

  SingingCharacter? _character = SingingCharacter.Male;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(fontFamily: 'Barlow'),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff734370),
          title: Text("CUSTOMER DETAILS"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              //imgfile==null?
              CircleAvatar(
                backgroundColor: cobj.darksandal,
                backgroundImage: AssetImage(tempimg),
                radius: 60,
              ),
              // ):GestureDetector(
              //   child: CircleAvatar(
              //     //child:ClipRRect(borderRadius: BorderRadius.circular(60),child:imgfile==null?Text("CHOOSE PHOTO"):Image.file(imgfile!)),
              //     backgroundImage: FileImage(imgfile!),
              //     radius: 60,
              //   ),
              //   onTap: (){
              //     //camerafunc(true);
              //   },
              // ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 250,
                child: TextField(
                  cursorHeight: 20,
                  cursorColor: cobj.violet,
                  controller: cNameCont,
                  onChanged: (String s) {
                    customername = s;
                  },
                  decoration: InputDecoration(
                    labelText: "CUSTOMER NAME",
                    labelStyle: TextStyle(color:cobj.violet),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: cobj.violet, width: 2.0),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 250,
                child: TextField(
                  cursorHeight: 20,
                  cursorColor: cobj.violet,
                  controller: cLocCont,
                  onChanged: (String s) {
                    customerlocation = s;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: cobj.violet, width: 2.0),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    labelText: "CUSTOMER LOCATION",
                    labelStyle: TextStyle(color:cobj.violet),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              // Container(
              //   width: 250,
              //   child: TextField(
              //     cursorHeight: 20,
              //     cursorColor: cobj.violet,
              //     controller: cAgeCont,
              //     keyboardType: TextInputType.number,
              //     onChanged: (String s) {
              //       customerage = int.parse(s);
              //     },
              //     decoration: InputDecoration(
              //       focusedBorder: OutlineInputBorder(
              //         borderSide:
              //             BorderSide(color: cobj.violet, width: 2.0),
              //         borderRadius: BorderRadius.circular(13),
              //       ),
              //       labelText: "CUSTOMER AGE",
              //       labelStyle: TextStyle(color:cobj.violet),
              //       border: OutlineInputBorder(),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 30,
              // ),
              Container(
                width: 250,
                child: TextField(
                  cursorHeight: 20,
                  cursorColor: cobj.violet,
                  controller: cPhCont,
                  keyboardType: TextInputType.phone,
                  onChanged: (String s) {
                    customermobile = s;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: cobj.violet, width: 2.0),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    labelText: "CUSTOMER MOBILE NO",
                    labelStyle: TextStyle(color:cobj.violet),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                width: 250,
                child: Column(
                  children: [
                    Container(
                      child: ListTile(
                        title: const Text('MALE'),
                        leading: Radio<SingingCharacter>(
                          activeColor: cobj.violet,
                          value: SingingCharacter.Male,
                          groupValue: _character,
                          onChanged: (SingingCharacter? value) {
                            setState(() {
                              tempimg = "images/male1.png";
                              _character = value;
                              Gender = "M";
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      child: ListTile(
                        title: const Text('Female'),
                        leading: Radio<SingingCharacter>(
                          activeColor: cobj.violet,
                          value: SingingCharacter.Female,
                          groupValue: _character,
                          onChanged: (SingingCharacter? value) {
                            setState(() {
                              tempimg = "images/female1.png";
                              _character = value;
                              Gender = "F";
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: cobj.violet),
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    if (cNameCont.text.isNotEmpty &&
                        cLocCont.text.isNotEmpty &&
                        cPhCont.text.isNotEmpty) {
                      if(cPhCont.text.length >10){
                        if(cPhCont.text.contains("+91")){
                          customermobile=cPhCont.text;
                          //
                        }
                        else{
                          Fluttertoast.showToast(
                              msg: "ADD +91 BEFORE MOBILE NUUMBER",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          setState(() {
                            loading=false;
                          });
                          return;
                        }
                      }
                      else if(cPhCont.text.length <10){
                        Fluttertoast.showToast(
                            msg: "INVALID MOBILE NUMBER",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                      else{
                        customermobile="+91"+cPhCont.text;
                      }
                      //print("no problem");
                      DatabaseReference cusidRef = await FirebaseDatabase
                          .instance
                          .ref(widget.useruid)
                          .child("CUSTOMER UIDS");
                      await cusidRef.set({"ID": ServerValue.increment(1)});
                      DataSnapshot id = await cusidRef.get();
                      //var t=temp.current.value;
                      int cusid =
                          int.parse(id.children.first.value.toString());
                      customerdetailsmodel newcus = new customerdetailsmodel(
                          customername,
                          customerlocation,
                          customermobile,
                          cusid);
                      //String url= await uploadFile(newcus.customername.toString());
                      await FirebaseDatabase.instance
                          .ref()
                          .child(widget.useruid.toString())
                          .child("customers")
                          .child(cusid.toString())
                          .set(<String, Object>{
                        "CUSTOMER NAME": newcus.customername,
                        "CUSTOMER LOCATION": newcus.customerlocation,
                        "CUSTOMER MOBILE NO": newcus.customermobile,
                        "CUSTOMER UNIQUE ID": newcus.customerUid,
                        "GENDER": Gender,
                        //"PHOTO LINK":url,
                      }).then((value) => {
                                setState(() {
                                  loading = false;
                                }),
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                height: 100,
                                                child: Image(
                                                    image: AssetImage(
                                                        "images/thumbsup.png"))),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                              child: Text(
                                                "USER ADDED SUCCESSFULLY",
                                                style:
                                                    TextStyle(fontSize: 20),
                                              ),
                                            )
                                            //AssetImage();
                                          ],
                                        ),
                                      );
                                    }),
                          Navigator.of(context)
                          .maybePop(ModalRoute.withName("/dashboardpage"))
                              });
                    } else {
                      setState(() {
                        loading = false;
                      });
                      Fluttertoast.showToast(
                          msg: "SOME FIELDS ARE EMPTY",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);

                    }
                  },
                  child: Text("ADD")),
              loading
                  ? CircularProgressIndicator(
                      color: cobj.violet,
                    )
                  : Text(""),
            ],
          ),
        ),
      ),
    );
  }
}

class AddEvent extends StatefulWidget {
  final String? useruid;
  final String cusid;
  const AddEvent(this.useruid,this.cusid, {Key? key}) : super(key: key);

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  String? selectedDate, presentDate;
  String? selectedTime;
  String? hour;
  String? minute;
  String worktitle = "";
  String workdesc = "";
  bool loading = false;
  List<String> cusnames=[];
  customerdetailsmodel cusobj=customerdetailsmodel.empty();
  //var preDateController=new TextEditingController();
  var datecontroller = new TextEditingController();
  var amountcontroller = new TextEditingController();
  var worktitlecont = TextEditingController();
  var desc = TextEditingController();

  var orderlistname=new TextEditingController();
  var orderlistquan=new TextEditingController();
  void initState() {
    func();
    setState(() {

    });
    double heightval=60;
  }
  func() async{
    cusobj=await cusDetails(widget.useruid.toString(),widget.cusid.toString());
    orderlistmodel firstobj=orderlistmodel("", "");
    orderList.add(firstobj);
    DataSnapshot data=await FirebaseDatabase.instance.ref(widget.useruid).child("customers").get();
    var iter=data.children.iterator;
    while(iter.moveNext()){
      String name=iter.current.child("CUSTOMER NAME").value.toString();
      cusnames.add(name);
    }
    setState(() {

    });
  }
  int tempsize=1;
  List<orderlistmodel> orderList=[];

  @override


  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(fontFamily: 'Barlow'),
      child: Scaffold(

          appBar: AppBar(
            title: Text("ORDER DETAILS"),
            centerTitle: true,
            backgroundColor: Color(0xff734370),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      width: 250,
                      child: TextField(
                        cursorHeight: 20,
                        maxLines: 5,
                        cursorColor: cobj.violet,
                        controller: worktitlecont,
                        onChanged: (c) {
                          worktitle = c;
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: cobj.violet, width: 2),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          hintText: "Order",
                          border: OutlineInputBorder(),
                        ),
                      )),
                  // Container(
                  //   width: 250,
                  //   child: DropdownSearch<String>(
                  //     //mode of dropdown
                  //     mode: Mode.DIALOG,
                  //     //to show search box
                  //     showSearchBox: true,
                  //
                  //     //list of dropdown items
                  //     items: cusnames,
                  //     onChanged: print,
                  //     //show selected item
                  //     selectedItem: "India",
                  //   ),
                  // ),
                  // Container(
                  //   child: ListView.separated(
                  //       shrinkWrap: true,
                  //       itemCount: orderList.isEmpty?1:orderList.length,
                  //         itemBuilder: (BuildContext context,int index){
                  //       return Padding(
                  //         padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  //         child: Container(
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             mainAxisSize: MainAxisSize.min,
                  //             children: [
                  //               Expanded(
                  //                 flex:3,
                  //                   child: Container(
                  //                     width: 150,
                  //                 child: TextField(
                  //                   onChanged: (s){
                  //                     orderList.elementAt(index).ordername=s;
                  //                   },
                  //                   decoration: InputDecoration(
                  //                     hintText: "Order",
                  //                     border: OutlineInputBorder(),
                  //                   ),
                  //                 ),
                  //               )
                  //               ),
                  //             Expanded(flex:1,child: Container(width: double.infinity,),),
                  //             Expanded(
                  //               flex:2,
                  //             child:Container(
                  //             child:TextField(
                  //               onChanged: (s){
                  //                 orderList.elementAt(index).orderquantity=s;
                  //               },
                  //               keyboardType: TextInputType.number,
                  //               decoration: InputDecoration(
                  //                 hintText: "Quantity",
                  //                 border: OutlineInputBorder(),
                  //               ),
                  //             )
                  //             )
                  //             ),
                  //               Expanded(flex:1,child: Container()
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       );
                  //     }, separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 10,); },),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     ElevatedButton(onPressed: (){
                  //       setState(() {
                  //         orderlistmodel newobj=orderlistmodel("", "");
                  //         orderList.add(newobj);
                  //         tempsize++;
                  //       });
                  //     }, child: Icon(Icons.add)),
                  //     SizedBox(width: 20,),
                  //     ElevatedButton(onPressed: (){
                  //       setState(() {
                  //         orderList.clear();
                  //       });
                  //     }, child: Icon(Icons.cancel))
                  //   ],
                  // ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      width: 250,
                      child: TextField(
                        cursorHeight: 20,
                        cursorColor: cobj.violet,
                        controller: desc,
                        onChanged: (desc) {
                          workdesc = desc;
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: cobj.violet, width: 2),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          hintText: "DESCRIPTION",
                          border: OutlineInputBorder(),
                        ),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: (){

                      },
                    child: Container(
                      width: 250,
                      child: TextField(
                          cursorHeight: 20,
                          cursorColor: cobj.violet,
                          readOnly: true,
                          controller: datecontroller,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: cobj.violet, width: 2),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              hintText: "DATE",
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                  color: cobj.violet,
                                  icon: Icon(Icons.today),
                                  onPressed: () {

                                  })),
                        onTap: (){
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2050),
                          ).then((date) {
                            final DateFormat formatter =
                            DateFormat('dd-MM-yyyy');
                            final String formatted =
                            formatter.format(date!);
                            setState(() {
                              datecontroller.text = formatted;
                              selectedDate = formatted;
                            });
                          });
                        },
                        ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      width: 250,
                      child: TextField(
                        cursorHeight: 20,
                        cursorColor: cobj.violet,
                        controller: amountcontroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: cobj.violet, width: 2),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          hintText: "AMOUNT",
                          border: OutlineInputBorder(),
                        ),
                      )),
                  // ElevatedButton(onPressed: (){
                  //   for(int i=0;i<orderList.length;i++){
                  //     print("ORDER NAME "+(i+1).toString()+orderList.elementAt(i).ordername);
                  //     print("ORDER QUAN "+(i+1).toString()+orderList.elementAt(i).orderquantity);
                  //   }
                  // }, child: Text("TEMP")),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (worktitlecont.text.isNotEmpty &&
                          desc.text.isNotEmpty &&
                          datecontroller.text.isNotEmpty &&
                          amountcontroller.text.isNotEmpty) {
                        setState(() {
                          loading = true;
                        });
                        DatabaseReference orderRef = await FirebaseDatabase
                            .instance
                            .ref(widget.useruid)
                            .child("ORDER NO");
                        await orderRef.set({"ID": ServerValue.increment(1)});
                        DataSnapshot orderid = await orderRef.get();
                        int orderNO =
                            int.parse(orderid.children.first.value.toString());
                        final DateFormat formatter = DateFormat('dd-MM-yyyy');
                        presentDate = formatter.format(DateTime.now());
                        DatabaseReference addEventRef = await FirebaseDatabase
                            .instance
                            .ref()
                            .child(widget.useruid.toString())
                            .child("PENDING WORKS")
                            .push();
                        await addEventRef.set(<String, String>{
                          "ORDER NO": orderNO.toString(),
                          "WORK TITLE": worktitle,
                          "WORK DESCRIPTION": workdesc,
                          "DUE DATE": selectedDate.toString(),
                          "GIVEN DATE": presentDate.toString(),
                          "AMOUNT": amountcontroller.text.toString(),
                          "CUSTOMER ID": widget.cusid.toString(),
                          "CUSTOMER NAME":cusobj.customername,
                          "CUSTOMER MOBILE NO":cusobj.customermobile,
                        }).then((value) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: 100,
                                          child: Image(
                                              image: AssetImage(
                                                  "images/order.png"))),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        child: Text(
                                          "ORDER ADDED SUCCESSFULLY",
                                          style:
                                          TextStyle(fontSize: 20),
                                        ),
                                      )
                                      //AssetImage();
                                    ],
                                  ),
                                );
                              });

                          Navigator.of(context)
                              .maybePop(ModalRoute.withName("/dashboardpage"));
                          // setState(() {
                          //   loading = false;
                          // });
                          // worktitlecont.clear();
                          // desc.clear();
                          // datecontroller.clear();
                          // amountcontroller.clear();
                        });
                      } else {
                        Fluttertoast.showToast(msg: "SOME FIELDS ARE EMPTY");
                      }

                      // Add2Calendar.addEvent2Cal(
                      //       buildEvent(),
                      //     );
                    },
                    child: Text("ADD ORDER"),
                    style: ElevatedButton.styleFrom(primary: cobj.violet),
                  ),
                  loading
                      ? CircularProgressIndicator(
                          color: cobj.violet,
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
           resizeToAvoidBottomInset: false,
      ),
    );
  }
}

class pendingwork extends StatefulWidget {
  final String userUid;

  const pendingwork(this.userUid, {Key? key}) : super(key: key);

  @override
  _pendingworkState createState() => _pendingworkState();
}

class _pendingworkState extends State<pendingwork> {
  bool _loading = true;
  List<addeventmodel> pendingData = [];
  Map<int, String> months = {
    01: "JAN",
    02: "FEB",
    03: "MAR",
    04: "APR",
    05: "MAY",
    06: "JUN",
    07: "JUL",
    08: "AUG",
    09: "SEP",
    10: "OCT",
    11: "NOV",
    12: "DEC",
  };
  bool _noData=false;
  //List<String> months=[,"FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];
  void pending() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref(widget.userUid.toString())
        .child("PENDING WORKS");
    Stream<DatabaseEvent> stream = await ref.onValue;
    stream.listen((event) async {
      pendingData.clear();
      var iterator = event.snapshot.children.iterator;
      while (iterator.moveNext()) {
        //print(iterator.current.child("WORK TITLE").value.toString());
        addeventmodel eve = new addeventmodel.pendingwithkeys(
          iterator.current.child("WORK TITLE").value.toString(),
          iterator.current.child("WORK DESCRIPTION").value.toString(),
          iterator.current.child("DUE DATE").value.toString(),
          iterator.current.child("AMOUNT").value.toString(),
          iterator.current.child("ORDER NO").value.toString(),
          iterator.current.child("GIVEN DATE").value.toString(),
          iterator.current.child("CUSTOMER ID").value.toString(),
          iterator.current.key.toString(),
          iterator.current.child("CUSTOMER NAME").value.toString(),
          iterator.current.child("CUSTOMER MOBILE NO").value.toString(),
        );
        pendingData.add(eve);
      }
      //print(cusNames.toString());
      setState(() {
        if(pendingData.isEmpty){
          _noData=true;
        }
        _loading = false;
      });
    });
    //DataSnapshot event= await ref.get();
    //var iterator = event.children.iterator;
    //sprint(iterator.current.value.toString());
    //print("hi");
  }

  @override
  void initState() {
    pending();
    for(int i=0;i<pendingData.length;i++){
    }

    //print(widget.userUid.toString());
    //print(pendingData.toString());
  }

  @override
  void dispose() {
   // print(cusNames.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(fontFamily: 'Barlow'),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(icon:Icon(Icons.arrow_back),onPressed: (){Navigator.pop(context);},),
            backgroundColor: Color(0xff734370),
            title: Text("PENDING ORDERS"),
            centerTitle: true,
          ),
          body: _loading
              ? Center(
                  child: CircularProgressIndicator(
                  color: cobj.violet,
                ))
              :_noData?Center(child: Text("NO PENDING ORDERS"),): Align(
                alignment: AlignmentDirectional.topCenter,
                child: Container(
                  width: isplatformandroid
                      ? MediaQuery.of(context).size.width
                      : webWidth.toDouble(),
                  child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(child: Text("ORDERS")),
                                ],
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: Container(
                                  width: double.infinity,
                                )),
                            Expanded(
                              flex: 1,
                              child: Container(child: Text("DUE DATE")),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                child: Container(
                                  height: 120,
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Card(
                                    color: Color(0xfff7ebe6),
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  flex:2,
                                                  child: Text(
                                                    pendingData
                                                        .elementAt(index)
                                                        .title,
                                                    style: TextStyle(fontSize: 25),
                                                    maxLines: 2,
                                                    overflow: TextOverflow
                                                        .ellipsis, // Probelm here
                                                  ),
                                                ),
                                                Expanded(flex:1,child: Text(pendingData.elementAt(index).cusname)),
                                                // Customer Name
                                                //SizedBox(height: 10,),
                                                // Text(
                                                //   '\u{20B9}'+pendingData.elementAt(index).amount,
                                                //   style: TextStyle(
                                                //     color: Colors.red,
                                                //     fontSize: 30,
                                                //     fontWeight: FontWeight.normal,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ), // Title, customer name, amount
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            width: double.infinity,
                                          ),
                                        ), // Empty container with width = infinity
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // SizedBox(
                                                //   height: 10,
                                                // ),
                                                // months.elementAt(int.parse(pendingData.elementAt(index).date.substring(3,5)))
                                                Text(
                                                  months[int.parse(pendingData
                                                          .elementAt(index)
                                                          .date
                                                          .substring(3, 5))]
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    //color: Colors.red,
                                                  ),
                                                ),
                                                CircleAvatar(
                                                  backgroundColor:
                                                      Color(0xff734370),
                                                  child: Text(
                                                    pendingData
                                                        .elementAt(index)
                                                        .date
                                                        .substring(0, 2),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ), // Date
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  //print(pendingData.elementAt(index).);
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => orderDetails(
                                  //             pendingData.elementAt(index), cusNames)));
                                  Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(
                                      builder: (_) => orderDetails(
                                          widget.userUid,
                                          pendingData,
                                          pendingData.elementAt(index).orderUKey,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            itemCount: pendingData.length,
                          ),
                        ),
                      ],
                    ),
                ),
              ),

        ),
      );
  }
}

class orderDetails extends StatefulWidget {
  final String userUid;
  final List<addeventmodel> allOrders;
  final String orderUkey;
  const orderDetails(
      this.userUid, this.allOrders,this.orderUkey,
      {Key? key})
      : super(key: key);

  @override
  _orderDetailsState createState() => _orderDetailsState();
}

enum paymentstatus {PAID,PENDING}

class _orderDetailsState extends State<orderDetails> {
  int cusid=0;
  addeventmodel passedData=addeventmodel.empty();
  var orderController = TextEditingController();
  void fbFunc() async{
    DatabaseReference orderRef = await FirebaseDatabase.instance.ref(widget.userUid).child("PENDING WORKS").child(widget.orderUkey);
    Stream<DatabaseEvent> stream=await orderRef.onValue;
    stream.listen((event) async{
      var iterator = event.snapshot.children.iterator;
      cusid=int.parse(event.snapshot.child("CUSTOMER ID").value.toString());
      passedData=await addeventmodel.pendingwithkeys(
          event.snapshot.child("WORK TITLE").value.toString(),
          event.snapshot.child("WORK DESCRIPTION").value.toString(),
          event.snapshot.child("DUE DATE").value.toString(),
          event.snapshot.child("AMOUNT").value.toString(),
          event.snapshot.child("ORDER NO").value.toString(),
          event.snapshot.child("GIVEN DATE").value.toString(),
          event.snapshot.child("CUSTOMER ID").value.toString(),
          widget.orderUkey,
          event.snapshot.child("CUSTOMER NAME").value.toString(),
          event.snapshot.child("CUSTOMER MOBILE NO").value.toString(),

      );
     // print("obj cusid"+obj.cusId);
      setState(() {

       // passedData=obj;
      });
    });
  }
  @override
  void initState() {
    //print("in orderdetails"+widget.cusNames.toString());
    fbFunc();
    // orderController.addListener(() {
    //   print(orderController.text);
    // });
    // print(passedData.OrderNo);
    // print("cusid"+passedData.cusId);
    // print("cusname:"+widget.cusNames[passedData.cusId].toString());
  }

  void deleteFunc(String orderNo) async {
    DatabaseReference userRef =
        await FirebaseDatabase.instance.ref(widget.userUid.toString());
    DatabaseReference compOrder = await userRef.child("PENDING WORKS");
    DataSnapshot data = await compOrder.get();
    var iter = data.children.iterator;
    while (iter.moveNext()) {
      if (iter.current.child("ORDER NO").value.toString() == orderNo) {
        await compOrder
            .child(iter.current.key.toString())
            .remove()
            .then((value) => {});
        break;
      }
    }
  }

  void dbfunc(String orderNo) async {
    int len = widget.allOrders.length;
    for (int i = 0; i < len; i++) {
      if (widget.allOrders.elementAt(i).OrderNo == orderNo) {
        DatabaseReference userRef =
            await FirebaseDatabase.instance.ref(widget.userUid.toString());
        await userRef
            .child("COMPLETED ORDERS")
            .child(orderNo)
            .set(<String, String>{
          "ORDER NO": widget.allOrders.elementAt(i).OrderNo,
          "WORK TITLE": widget.allOrders.elementAt(i).title,
          "WORK DESCRIPTION": widget.allOrders.elementAt(i).desc,
          "DUE DATE": widget.allOrders.elementAt(i).date,
          "GIVEN DATE": widget.allOrders.elementAt(i).givenDate,
          "AMOUNT": widget.allOrders.elementAt(i).amount,
          "CUSTOMER ID": widget.allOrders.elementAt(i).cusId,
        }).then((value) => {});
        deleteFunc(orderNo);
        break;
      }
    }
    // DatabaseReference userRef=await FirebaseDatabase.instance.ref(widget.userUid.toString());
    // DatabaseReference compOrder=await userRef.child("PENDING WORKS");
    // DataSnapshot data=await compOrder.get();
    // var iter=data.children.iterator;
    // while(iter.moveNext()){
    //   if(iter.current.child("ORDER NO").value.toString()==orderNo){
    //     //print("FB"+iter.current.child("ORDER NO").value.toString());
    //     // print(iter.current.value.toString());
    //     // addeventmodel compOrder=addeventmodel(
    //     //   iter.current.child("WORK TITLE").value.toString(),
    //     //   iter.current.child("WORK DESCRIPTION").value.toString(),
    //     //   iter.current.child("DUE DATE").value.toString(),
    //     //   iter.current.child("AMOUNT").value.toString(),
    //     //   iter.current.child("ORDER NO").value.toString(),
    //     //   iter.current.child("GIVEN DATE").value.toString(),
    //     //   iter.current.child("CUSTOMER ID").value.toString(),
    //     // );
    //   }
    // }
  }
  bool _isShowDial = false;
  bool _tfenabled = true;
  int tempsize=0;

  // void handleClick(String value) {
  //   switch (value) {
  //     case 'Edit':
  //       print("order key in order page "+passedData.orderUKey);
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => OrderEditPage(
  //                   passedData,
  //                   widget.userUid)));
  //       break;
  //     case 'Mark As Done':
  //       showDialog(
  //           context: context,
  //           builder: (context) {
  //             return AlertDialog(
  //               content: Container(
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //
  //                     // Text(
  //                     //     "DO YOU WANT TO MARK IT AS DONE ? "),
  //                   ],
  //                 ),
  //               ),
  //               actions: [
  //                 TextButton(
  //                   child: Text(
  //                     "CANCEL",
  //                     style: TextStyle(
  //                         color: cobj.violet,
  //                         fontSize: 15),
  //                   ),
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                 ),
  //                 TextButton(
  //                   child: Text(
  //                     "YES",
  //                     style: TextStyle(
  //                         color: cobj.violet,
  //                         fontSize: 15),
  //                   ),
  //                   onPressed: () {
  //                     dbfunc(passedData.OrderNo);
  //                     Navigator.of(context).pop();
  //                   },
  //                 )
  //               ],
  //             );
  //           });
  //       break;
  //     case 'Delete':
  //       showDialog(
  //           context: context,
  //           builder: (context) {
  //             return AlertDialog(
  //               content: Container(
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Text("DELETE THIS ORDER ? "),
  //                   ],
  //                 ),
  //               ),
  //               actions: [
  //                 TextButton(
  //                   child: Text(
  //                     "CANCEL",
  //                     style: TextStyle(
  //                         color: cobj.violet,
  //                         fontSize: 15),
  //                   ),
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                 ),
  //                 TextButton(
  //                   child: Text(
  //                     "YES",
  //                     style: TextStyle(
  //                         color: Colors.red,
  //                         fontSize: 15),
  //                   ),
  //                   onPressed: () {
  //                     deleteFunc(
  //                         passedData.OrderNo);
  //                     Navigator.of(context).pop();
  //                   },
  //                 )
  //               ],
  //             );
  //           });
  //       break;
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(fontFamily: 'Barlow'),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff734370),
          title: Text("ORDER DETAILS"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          // actions: <Widget>[
          //   PopupMenuButton<String>(
          //     onSelected: handleClick,
          //     itemBuilder: (BuildContext context) {
          //       return {'Edit', 'Mark As Done','Delete'}.map((String choice) {
          //         return PopupMenuItem<String>(
          //           value: choice,
          //           child: Text(choice),
          //         );
          //       }).toList();
          //     },
          //   ),
          // ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width:isplatformandroid?MediaQuery.of(context).size.width:700,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 80,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(flex: 1, child: Text("ORDER NO : ")),
                              Expanded(flex:2,child: Container(width: double.infinity,)),
                              Expanded(
                                  flex: 1, child: Text(passedData.OrderNo))
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 80,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(flex: 1, child: Text("CUSTOMER ID : ")),
                              Expanded(flex:2,child: Container(width: double.infinity,)),
                              Expanded(
                                  flex: 1, child: Text(passedData.cusId))
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 80,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(flex: 1, child: Text("CUSTOMER NAME : ")),
                              Expanded(flex:2,child: Container(width: double.infinity,)),
                              Expanded(
                                  flex: 1,
                                  child: Text(passedData.cusname),
                              )
                              //
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 80,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(flex: 1, child: Text("GIVEN DATE : ")),
                              Expanded(flex:2,child: Container(width: double.infinity,)),
                              Expanded(
                                  flex: 1, child: Text(passedData.givenDate))
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 80),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(flex: 1, child: Text("ORDER : ")),
                              Expanded(flex:2,child: Container(width: double.infinity,)),
                              Expanded(
                                flex: 1,
                                child: Text(passedData.title),
                                // child: TextFormField(
                                //   initialValue:widget.passedData.title ,
                                //   enabled: false,
                                //   controller: orderController,
                                // // widget.passedData.title
                                // )
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 80,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(flex: 1, child: Text("DUE DATE : ")),
                              Expanded(flex:2,child: Container(width: double.infinity,)),
                              Expanded(flex: 1, child: Text(passedData.date))
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 80,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(flex: 1, child: Text("AMOUNT : ")),
                              Expanded(flex:2,child: Container(width: double.infinity,)),
                              Expanded(
                                  flex: 1,
                                  child:
                                      Text('\u{20B9}' + passedData.amount))
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 80,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(flex: 1, child: Text("DESC : ")),
                              Expanded(flex:2,child: Container(width: double.infinity,)),
                              Expanded(flex: 1, child: Text(passedData.desc))
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    // Expanded(
                    //   child:ListView.separated(
                    //       shrinkWrap: true,
                    //       itemCount: tempsize,
                    //         itemBuilder: (BuildContext context,int index){
                    //       return Container(
                    //         child: Row(
                    //           children: [
                    //             Expanded(
                    //               flex:2,
                    //                 child: Container(
                    //                   width: 150,
                    //               child: TextField(
                    //                 decoration: InputDecoration(
                    //                   border: OutlineInputBorder(),
                    //                 ),
                    //               ),
                    //             )
                    //             ),
                    //           Expanded(flex:1,child: Container(width: double.infinity,),),
                    //           Expanded(
                    //             flex:2,
                    //           child:Container(
                    //           child:TextField(
                    //             decoration: InputDecoration(
                    //               border: OutlineInputBorder(),
                    //             ),
                    //           )
                    //           )
                    //           ),
                    //             Expanded(flex:1,child: Container(
                    //               child: IconButton(
                    //                 icon:Icon(Icons.add),
                    //                 onPressed: (){
                    //                   setState(() {
                    //                     tempsize++;
                    //                   });
                    //                 },
                    //                 )
                    //             )
                    //             ),
                    //           ],
                    //         ),
                    //       );
                    //     }, separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 10,); },),
                    // ),
                    // ElevatedButton(onPressed: (){
                    //   setState(() {
                    //     tempsize++;
                    //   });
                    // }, child: Text("ADD EXPENSES")),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0,0,0,10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                              mini: false,
                              tooltip: "DELETE",
                              backgroundColor: Colors.red,
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Container(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text("DELETE THIS ORDER ? "),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text(
                                              "CANCEL",
                                              style: TextStyle(
                                                  color: cobj.violet,
                                                  fontSize: 15),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              "YES",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15),
                                            ),
                                            onPressed: () {
                                              deleteFunc(
                                                  passedData.OrderNo);
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: Icon(
                                Icons.delete,
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            FloatingActionButton(
                                heroTag: "two",
                                mini: false,
                                tooltip: "MARK AS DONE",
                                backgroundColor: cobj.violet,
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>billpage(passedData,widget.userUid)));
                                  // showDialog(
                                  //     context: context,
                                  //     builder: (context) {
                                  //       return StatefulBuilder(
                                  //         builder: (context,setState) {
                                  //           return AlertDialog(
                                  //             content: Container(
                                  //               child: Column(
                                  //                 mainAxisSize: MainAxisSize
                                  //                     .min,
                                  //                 children: [
                                  //                   Text("PAYMENT STATUS : "),
                                  //                   Column(
                                  //                     children: [
                                  //                       ListTile(
                                  //                         title: Text("PAID"),
                                  //                         leading: Radio<
                                  //                             paymentstatus>(
                                  //                           value: paymentstatus
                                  //                               .PAID,
                                  //                           groupValue: sts,
                                  //                           onChanged: (
                                  //                               paymentstatus? value) {
                                  //                             setState(() {
                                  //                               sts = value!;
                                  //                             });
                                  //                           },
                                  //                         ),
                                  //                       ),
                                  //                       ListTile(
                                  //                         title: Text(
                                  //                             "PENDING"),
                                  //                         leading: Radio<
                                  //                             paymentstatus>(
                                  //                           value: paymentstatus
                                  //                               .PENDING,
                                  //                           groupValue: sts,
                                  //                           onChanged: (
                                  //                               paymentstatus? value) {
                                  //                             setState(() {
                                  //                               sts = value!;
                                  //                             });
                                  //                           },
                                  //                         ),
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                   // Text(
                                  //                   //     "DO YOU WANT TO MARK IT AS DONE ? "),
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //             actions: [
                                  //               TextButton(
                                  //                 child: Text(
                                  //                   "CANCEL",
                                  //                   style: TextStyle(
                                  //                       color: colorObj.violet,
                                  //                       fontSize: 15),
                                  //                 ),
                                  //                 onPressed: () {
                                  //                   Navigator.of(context).pop();
                                  //                 },
                                  //               ),
                                  //               TextButton(
                                  //                 child: Text(
                                  //                   "YES",
                                  //                   style: TextStyle(
                                  //                       color: colorObj.violet,
                                  //                       fontSize: 15),
                                  //                 ),
                                  //                 onPressed: () {
                                  //                   dbfunc(passedData.OrderNo);
                                  //                   Navigator.of(context).pop();
                                  //                 },
                                  //               )
                                  //             ],
                                  //           );
                                  //         }
                                  //       );
                                  //     });
                                },
                                child: Icon(Icons.done)),
                            SizedBox(
                              width: 30,
                            ),
                            FloatingActionButton(
                                heroTag: "one",
                                mini: false,
                                tooltip: "EDIT",
                                backgroundColor: cobj.violet,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderEditPage(
                                              passedData,
                                              widget.userUid)));
                                },
                                child: Icon(Icons.edit))
                          ],
                        ),
                      ),
                    )

                    //Text(widget.passedData.desc),
                    //SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  // Widget fabs() {
  //   return SpeedDialMenuButton(
  //       paddingBtwSpeedDialButton: 45,
  //       isShowSpeedDial: _isShowDial,
  //       //manually open or close menu
  //       updateSpeedDialStatus: (isShow) {
  //         //return any open or close change within the widget
  //         this._isShowDial = isShow;
  //       },
  //       mainMenuFloatingActionButton: MainMenuFloatingActionButton(
  //           closeMenuChild: Icon(Icons.close),
  //           child: Icon(Icons.more_vert),
  //           onPressed: () {}),
  //       isMainFABMini: false,
  //       floatingActionButtonWidgetChildren: <FloatingActionButton>[
  //         FloatingActionButton(
  //           child: Icon(Icons.delete),
  //           onPressed: () {
  //             //if need to close menu after click
  //             _isShowDial = false;
  //             setState(() {});
  //           },
  //           backgroundColor: Colors.red,
  //         ),
  //         FloatingActionButton(
  //           child: Icon(Icons.done),
  //           onPressed: () {
  //             //if need to toggle menu after click
  //             _isShowDial = !_isShowDial;
  //             setState(() {});
  //           },
  //           backgroundColor: Colors.blue,
  //         ),
  //       ],
  //       isSpeedDialFABsMini: false);
  // }
}

class billpage extends StatefulWidget {
  final addeventmodel orderdetails;
  final String userid;
  const billpage(this.orderdetails,this.userid, {Key? key}) : super(key: key);

  @override
  _billpageState createState() => _billpageState();
}
enum Share {
  facebook,
  twitter,
  whatsapp,
  whatsapp_personal,
  whatsapp_business,
  share_system,
  share_instagram,
  share_telegram
}
class _billpageState extends State<billpage> {
  List<String> headings=["Order No : ","Order : ","Customer Name : ","Amount : "];
  List<String> values=[];
  bool _showBtn=false;
  Uint8List? _imageFile;
  String cusphno="";
  ScreenshotController screenshotController = ScreenshotController();
  void fbfunc() async{
    cusphno=await cusPhno(widget.userid,widget.orderdetails.cusId);
    setState(() {

    });
  }
  @override
  void initState() {
    fbfunc();
    values.add(widget.orderdetails.OrderNo);
    values.add(widget.orderdetails.title);
    values.add(widget.orderdetails.cusname);
    values.add(widget.orderdetails.amount);

  }
  String imgpath="";
  paymentstatus sts=paymentstatus.PAID;
  File? capturedFile;
  String balance="";
  Future<void> captfunc() async{

    screenshotController.capture().then((image) async{
      try{
        final String dir = (await getApplicationDocumentsDirectory()).path;
        final String fullPath = '$dir/${DateTime.now().millisecond}.png';
        capturedFile = File(fullPath);
      }catch(e){
        showDialog(context: context, builder: (BuildContext context){
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("THIS FEATURE IS NOT AVAILABLE FOR WEB"),
              ],
            ),
          );
        });
        return;
      }


      await capturedFile?.writeAsBytes(image!);
      //print(image);
      setState(() {
        _imageFile = image!;
      });
    });
  }
  int choice=1;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(fontFamily: 'Barlow'),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: cobj.violet,
        ),
        body: Screenshot(
          controller: screenshotController,
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                width: isplatformandroid
                    ? MediaQuery.of(context).size.width
                    : webWidth.toDouble(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: headings.length,
                          itemBuilder: (BuildContext context,int index){
                        return ConstrainedBox(
                          constraints: BoxConstraints(minHeight: 80),
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(flex: 1, child: Text(headings.elementAt(index))),
                                  Expanded(flex:2,child: Container(width: double.infinity,)),
                                  Expanded(
                                      flex: 1, child: Text(values.elementAt(index)))
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize
                            .min,
                        children: [
                          Text("PAYMENT STATUS : "),
                          ListTile(
                            focusColor: cobj.violet,
                            title: Text("PAID"),
                            leading: Radio<
                                paymentstatus>(
                              activeColor: cobj.violet,

                              value: paymentstatus
                                  .PAID,
                              groupValue: sts,
                              onChanged: (
                                  paymentstatus? value) {
                                setState(() {
                                  choice=1;
                                  _showBtn=false;
                                  sts = value!;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: Text(
                                "PENDING"),
                            leading: Radio<paymentstatus>(
                              activeColor: cobj.violet,
                              value: paymentstatus
                                  .PENDING,
                              groupValue: sts,
                              onChanged: (
                                  paymentstatus? value) {
                                setState(() {
                                  choice=2;
                                  _showBtn=true;
                                  sts = value!;
                                });
                              },
                            ),
                          ),
                          _showBtn?Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Container(
                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      height:60,
                                      width: 100,
                                      child: TextField(
                                        onChanged: (s){
                                          balance=s;
                                        },
                                        keyboardType:TextInputType.number,
                                      decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: cobj.violet, width: 2.0),
                                            borderRadius: BorderRadius.circular(13),
                                          ),
                                          labelText: "BALANCE",
                                          labelStyle: TextStyle(color: cobj.violet),
                                          border: OutlineInputBorder()
                                      ),
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ):Text(""),
                          // Image(image: FileImage(File.fromRawPath(_imageFile!)))
                        ],
                      ),
                    ),
                    // ElevatedButton(onPressed: (){}, child: Text("CAPTURE")),
                    ElevatedButton(onPressed: () async{
                      if(choice==2 && balance.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('ENTER BALANCE AMOUNT'),
                            action: SnackBarAction(
                              label: 'OK',
                              onPressed: () {
                                //Navigator.pop(context);
                                // Some code to undo the change.
                              },
                            )));
                        return;
                      }
                      await masterfunc(widget.userid, widget.orderdetails.OrderNo,balance,choice).then((value) {
                        // Navigator.of(context, rootNavigator: true).pop(context);
                        // Navigator.of(context).canPop();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => dashboardpage(useruid: widget.userid)),
                                (Route<dynamic> route) => false);
                        if(choice==1){
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: 100,
                                          child: Image(
                                              image: AssetImage(
                                                  "images/completedorder.png"))),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        child: Text(
                                          "ADDED TO COMPLETED ORDERS",
                                          style:
                                          TextStyle(fontSize: 20),
                                        ),
                                      )
                                      //AssetImage();
                                    ],
                                  ),
                                );
                              });
                        }
                        else{
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: 100,
                                          child: Image(
                                              image: AssetImage(
                                                  "images/paymentpending.png"))),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        child: Text(
                                          "ADDED TO PAYMENT PENDING ORDERS",
                                          style:
                                          TextStyle(fontSize: 20),
                                        ),
                                      )
                                      //AssetImage();
                                    ],
                                  ),
                                );
                              });
                        }
                        // Navigator.of(context)
                        //     .maybePop(ModalRoute.withName("/dashboardpage"));

                      });


                    }, child: Text("SAVE"),
                      style: ElevatedButton.styleFrom(primary: cobj.violet),
                    ),
                    SizedBox(height:30),
                    ElevatedButton(onPressed: () async{
                      var data={
                        "template": "yKBqAzZ9GEvDvMx36O",
                        "modifications": [
                          {
                            "name": "message",
                            "text": "You can change this text",
                            "color": null,
                            "background": null
                          }
                        ],
                        "webhook_url": null,
                        "transparent": false,
                        "metadata": null
                      };
                      // final jsonEncoder = JsonEncoder();
                      // var response=await http.post(
                      //     Uri.parse("https://api.bannerbear.com/v2/images"),
                      //     body:jsonEncoder.convert(data),
                      //     headers: {
                      //       'Content-Type' : 'application/json',
                      //       'Authorization' : 'Bearer bb_pr_499f2048bf94b96a5799242498ea0c'
                      //     }
                      // );
                      // var rdata=jsonDecode(response.body) as Map;
                      // String uid=rdata["uid"];
                      // print(uid);
                      // print("post response"+rdata.toString());
                      // Timer(Duration(seconds: 10),() async{
                      // var getresp= await http.get(
                      // Uri.parse("https://api.bannerbear.com/v2/images/${uid}"),
                      // headers: {
                      // 'Authorization' : 'Bearer bb_pr_499f2048bf94b96a5799242498ea0c'
                      // }).then((value) {
                      //   print(value.body);
                      //   var getdata=jsonDecode(value.body) as Map;
                      //   print(getdata["image_url_png"]);
                      //   imgpath=getdata["image_url_png"];
                      //
                      // });
                      // // print("get response"+getresp.body);
                      // setState(() {
                      //
                      // });
                      // });

                      String mobile=widget.orderdetails.cusmobile;
                      var msg ='''ORDER NO : ${widget.orderdetails.OrderNo}
                                  ORDER : ${widget.orderdetails.title}
                                  AMOUNT : ${widget.orderdetails.amount}
                                  BALANCE : ${balance}''';
                      var whatsappUrl ="whatsapp://send?phone=$mobile&text=$msg";
                      await launch(whatsappUrl);
                      // await captfunc();
                      // //onButtonTap(Share.whatsapp,"+91"+widget.orderdetails.cusmobile);
                      // onButtonTap(Share.whatsapp_personal,"+91"+widget.orderdetails.cusmobile);
                    }, child: Text("SHARE"),
                      style: ElevatedButton.styleFrom(primary: cobj.violet),
                    ),
                  ],
                ),
              ),
            )
          ),
        ),
      ),
    );
  }
  Future<void> onButtonTap(Share share,String phno) async {
    String msg ="""ORDER NO : ${widget.orderdetails.OrderNo}<br/>ORDER : ${widget.orderdetails.title}<br/>AMOUNT : ${widget.orderdetails.amount}<br/>BALANCE : ${balance}""";

    String? response;
    final FlutterShareMe flutterShareMe = FlutterShareMe();
    switch (share) {
      case Share.whatsapp:
        if (capturedFile != null) {
          response = await flutterShareMe.shareToWhatsApp(
              imagePath: imgpath,
              fileType: FileType.image);
        } else {
          response = await flutterShareMe.shareToWhatsApp(msg: msg);
        }
        break;
      case Share.whatsapp_personal:
        response = await flutterShareMe.shareWhatsAppPersonalMessage(
            message: msg, phoneNumber: phno);
        break;
    }
  }
}


class OrderEditPage extends StatefulWidget {
  final addeventmodel obj;
  final String userUid;

  const OrderEditPage(this.obj, this.userUid, {Key? key}) : super(key: key);

  @override
  _OrderEditPageState createState() => _OrderEditPageState();
}

class _OrderEditPageState extends State<OrderEditPage> {
  var ordername = TextEditingController();
  var duedate = TextEditingController();
  var amount = TextEditingController();
  var desc = TextEditingController();
  FocusNode amountFN=FocusNode();
  FocusNode DescFN=FocusNode();
  String selectedDate = "";
  bool _loading=false;
  String _finishtext="";
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(fontFamily: 'Barlow'),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff734370),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                  width: 250,
                  child: TextField(
                    cursorHeight: 20,
                    maxLines: 5,
                    cursorColor: cobj.violet,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: cobj.violet, width: 2),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      helperText: "ORDER",
                      helperStyle: TextStyle(fontWeight: FontWeight.bold),
                      hintText: "ORDER",
                      border: OutlineInputBorder(),
                    ),
                    controller: ordername,
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: 250,
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: cobj.violet, width: 2),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      helperText: "DUE DATE",
                      helperStyle: TextStyle(fontWeight: FontWeight.bold),
                      // suffixIconColor: cObj.violet,
                      suffixIcon: IconButton(
                          color: cobj.violet,
                          icon: Icon(Icons.today),
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2050),
                            ).then((date) {
                              final DateFormat formatter =
                                  DateFormat('dd-MM-yyyy');
                              final String formatted = formatter.format(date!);
                              amountFN.requestFocus();
                              setState(() {

                                duedate.text = formatted;
                                //selectedDate=formatted;
                                // datecontroller.text = formatted;
                                // selectedDate = formatted;
                              });
                            });
                          }),
                      hintText: "DUE DATE",
                      border: OutlineInputBorder(),
                    ),
                    controller: duedate,
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: 250,
                  child: TextField(
                    focusNode: amountFN,
                    cursorColor: cobj.violet,
                    cursorHeight: 2,
                    onSubmitted: (s){
                      DescFN.requestFocus();
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: cobj.violet, width: 2),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      helperText: "AMOUNT",
                      helperStyle: TextStyle(fontWeight: FontWeight.bold),
                      hintText: "AMOUNT",
                      border: OutlineInputBorder(),
                    ),
                    controller: amount,
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: 250,
                  child: TextField(
                    focusNode: DescFN,
                    cursorColor: cobj.violet,
                    cursorHeight: 20,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: cobj.violet, width: 2),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      helperText: "DESC",
                      helperStyle: TextStyle(fontWeight: FontWeight.bold),
                      hintText: "DESCRIPTION",
                      border: OutlineInputBorder(),
                    ),
                    controller: desc,
                  )),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: cobj.violet,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("CANCEL"),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: cobj.violet,
                      ),
                      onPressed: () async {
                        if (ordername.text.isNotEmpty && duedate.text.isNotEmpty && amount.text.isNotEmpty && desc.text.isNotEmpty) {
                          setState(() {
                            _loading=true;
                          });
                          DatabaseReference editRef = await FirebaseDatabase.instance
                              .ref(widget.userUid)
                              .child("PENDING WORKS")
                              .child(widget.obj.orderUKey);
                          await editRef
                              .child("WORK TITLE")
                              .set(ordername.text.toString()).then((value) {
                          });
                          await editRef
                              .child("WORK DESCRIPTION")
                              .set(desc.text.toString());
                          await editRef
                              .child("AMOUNT")
                              .set(amount.text.toString());
                          await editRef
                              .child("DUE DATE")
                              .set(duedate.text.toString());
                          setState(() {
                            _loading=false;
                            _finishtext="CHANGES SAVED";
                          });
                        }
                        else{
                          Fluttertoast.showToast(msg: "SOME FIELDS ARE EMPTY");
                        }
                      },
                      child: Text("SAVE")),
                ],
              ),
              _loading?CircularProgressIndicator(color: cobj.violet,):Text(_finishtext)
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    ordername.text = widget.obj.title;
    duedate.text = widget.obj.date;
    amount.text = widget.obj.amount;
    desc.text = widget.obj.desc;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ordername.dispose();
    duedate.dispose();
    amount.dispose();
    desc.dispose();
    super.dispose();
  }
}

class paypendpage extends StatefulWidget {
  final String useruid;
  const paypendpage(this.useruid,{Key? key}) : super(key: key);

  @override
  _paypendpageState createState() => _paypendpageState();
}

class _paypendpageState extends State<paypendpage> {
  List<addeventmodel> paypendlist=[];
  bool _loading=true;
  void fbfunc() async{
    DataSnapshot event=await FirebaseDatabase.instance.ref(widget.useruid).child("PAYMENT PENDING").get();
    var iter=event.children.iterator;
    while(iter.moveNext()){
      addeventmodel eve = new addeventmodel.withbalance(
        iter.current.child("ORDER").value.toString(),
        iter.current.child("ORDER DESC").value.toString(),
        iter.current.child("DUE DATE").value.toString(),
        iter.current.child("AMOUNT").value.toString(),
        iter.current.child("ORDER NO").value.toString(),
        iter.current.child("GIVEN DATE").value.toString(),
        iter.current.child("CUSTOMER ID").value.toString(),
        iter.current.child("BALANCE AMOUNT").value.toString(),
        iter.current.child("CUSTOMER NAME").value.toString(),
        iter.current.child("CUSTOMER MOBILE NO").value.toString(),
      );
      paypendlist.add(eve);
    }
    setState(() {
      _loading=false;
    });

  }
  @override
  void initState() {
      fbfunc();
  }
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        fontFamily: 'Barlow',
        primaryColor: cobj.violet,
            cardColor: cobj.sandal
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: cobj.violet,
        ),
        body:_loading?Center(child: CircularProgressIndicator(
          color: cobj.violet,
        )):Center(
          child: Container(
            width: isplatformandroid
                ? MediaQuery.of(context).size.width
                : webWidth.toDouble(),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child:(paypendlist.isEmpty)?Center(child: Text("NO PAYMENT PENDING ORDERS"),): ListView.separated(
                itemCount: paypendlist.length,
                itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                        elevation: 4,
                        child:Padding(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding:EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Row(
                                  children: [
                                    Text("CUSTOMER NAME",style: TextStyle(fontSize: 15),),
                                    SizedBox(width: 20,),
                                    Text(paypendlist.elementAt(index).cusname),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:EdgeInsets.fromLTRB(10,10,10,0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("ORDER NO",style: TextStyle(fontSize: 15)),
                                    SizedBox(width: 20,),
                                    Text(paypendlist.elementAt(index).OrderNo,style: TextStyle(fontSize: 15),),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(10,10,10,0),
                                  child:Row(
                                    children: [
                                      Text("BALANCE",style: TextStyle(fontSize: 15)),
                                      SizedBox(width: 20,),
                                      Text("\u{20B9}"+paypendlist.elementAt(index).balance,style: TextStyle(fontSize: 15),),
                                    ],
                                  )
                                  ),
                              Padding(
                                padding:EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Row(
                                  children: [
                                    Text("ORDER",style: TextStyle(fontSize: 15),),
                                    SizedBox(width: 20,),
                                    Expanded(child: Text(paypendlist.elementAt(index).title,overflow: TextOverflow.ellipsis,)),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        )
                    ),
                  ),
                  onTap: (){
                    paypendDialog(context, paypendlist.elementAt(index), widget.useruid);
                  },
                );
              }, separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 10,);
              },

              ),
            ),
          ),
        ),
      ),
    );
  }

}

Future paypendDialog(BuildContext context,addeventmodel obj,String userid){
  return  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(flex:2,child: Text("ORDER NO")),
                      Expanded(flex:2,child:Container(width:double.infinity)),
                      Expanded(flex:1,child: Text(obj.OrderNo)),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Flexible(flex:2,child: Text("CUSTOMER NAME"),),
                      Flexible(flex:2,child:Container(width:double.infinity)),
                      Flexible(flex:1,child:Text(obj.cusname),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(flex:2,child: Text("TAILORING WAGE"),),
                      Expanded(flex:2,child:Container(width:double.infinity)),
                      Expanded(flex:1,child:Text(obj.amount),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(flex:2,child: Text("BALANCE AMOUNT"),),
                      Expanded(flex:2,child:Container(width:double.infinity)),
                      Expanded(flex:1,child:Text(obj.balance),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(flex:2,child: Text("TOTAL"),),
                      Expanded(flex:2,child:Container(width:double.infinity)),
                      Expanded(flex:1,child:Text((int.parse(obj.amount)+int.parse(obj.balance)).toString()),),
                    ],
                  ),

                  // Text(paypendlist.elementAt(index).title),
                  // Text(paypendlist.elementAt(index).desc),
                  // Text(paypendlist.elementAt(index).cusId),
                  // Text(paypendlist.elementAt(index).cusmobile),
                  // Text(paypendlist.elementAt(index).givenDate),
                  // Text(paypendlist.elementAt(index).date),

                ],
              )
          ),
          actions: [
            TextButton(
              child: Text(
                "CANCEL",
                style: TextStyle(
                    fontSize: 15),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "MARK AS PAID",
                style: TextStyle(
                    fontSize: 15),
              ),
              onPressed: (){
                int amount=int.parse(obj.amount);
                int balanceamount=int.parse(obj.balance);
                int totalamount=amount+balanceamount;
                obj.amount=totalamount.toString();
                addtocomp(userid,obj.OrderNo, obj, "PAYMENT PENDING");
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}





// Column(
// children: [
// Container(
// width: 250,
// height: 50,
// child: TextField()
// ),
// Text(selectedDate == null?'':selectedDate.toString()),
// ElevatedButton(onPressed: (){
// showDatePicker(
// context: context,
// initialDate: DateTime.now(),
// firstDate: DateTime(2001),
// lastDate: DateTime(2023),
// )
//     .then((date) {
// setState(() {
// selectedDate=date;
// });
//
// } );
//
// }, child: Text("ADD DATE")),
// Text(selectedTime==null?'':selectedTime.toString()),
// ElevatedButton(onPressed: (){
// showTimePicker(
// context: context,
// initialTime: TimeOfDay.now()
// ).then((timeofday){
// setState(() {
// selectedTime=timeofday;
// });
// });
// }, child: Text("ADD TIME"),)
// ],
// ),

// Center(
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// GestureDetector(
// child: Container(
// height: 150,
// child: Image(image: AssetImage('images/tailorsamplework.png'))
// ),
// onTap: (){
// Navigator.push(
// context,
// MaterialPageRoute(builder: (context)=>pendingwork(widget.userUid))
// );
// },
// ),
// Container(
// height: 150,
// child: Image(image: AssetImage('images/tailorsampledone.png'))
// ),
// ],
// ),
// )
