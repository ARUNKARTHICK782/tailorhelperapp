import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

import 'package:tailorapp/addEventmodel.dart';
import 'package:tailorapp/userdetailsmodel.dart';
Future<List<addeventmodel>> cusCompOrderFunc(String userUid,String cusID,String childName) async{
  List<addeventmodel> returnlist=[];
  DataSnapshot event= await  FirebaseDatabase.instance.ref(userUid).child(childName).get();
  var iter=event.children.iterator;
  while(iter.moveNext()){
    if(iter.current.child("CUSTOMER ID").value.toString()==cusID){
      addeventmodel obj=addeventmodel.pendingwithkeys(
          iter.current.child("WORK TITLE").value.toString(),
          iter.current.child("WORK DESCRIPTION").value.toString(),
          iter.current.child("DUE DATE").value.toString(),
          iter.current.child("AMOUNT").value.toString(),
          iter.current.child("ORDER NO").value.toString(),
          iter.current.child("GIVEN DATE").value.toString(),
          iter.current.child("CUSTOMER ID").value.toString(),
        iter.current.key.toString(),
        iter.current.child("CUSTOMER NAME").value.toString(),
        iter.current.child("CUSTOMER MOBILE NO").value.toString(),
    );
      returnlist.add(obj);
    }
  }
  return returnlist;
}

Future<List<addeventmodel>> cusPayPendFunc(String userUid,String cusID,String childName) async{
  List<addeventmodel> returnlist=[];
  DataSnapshot event= await  FirebaseDatabase.instance.ref(userUid).child(childName).get();
  var iter=event.children.iterator;
  while(iter.moveNext()){
    if(iter.current.child("CUSTOMER ID").value.toString()==cusID){
      addeventmodel obj= addeventmodel.withbalance(
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
      returnlist.add(obj);
    }
  }
  return returnlist;
}

Future<customerdetailsmodel> cusDetails(String userID,String cusID) async{
    customerdetailsmodel obj=customerdetailsmodel.empty();
    DataSnapshot event= await FirebaseDatabase.instance.ref(userID).child("customers").get();
    var iterator = event.children.iterator;
    while(iterator.moveNext()){
      if(iterator.current.child("CUSTOMER UNIQUE ID").value.toString() == cusID){
        obj=customerdetailsmodel(
            iterator.current.child("CUSTOMER NAME").value.toString(),
            iterator.current.child("CUSTOMER LOCATION").value.toString(),
            iterator.current.child("CUSTOMER MOBILE NO").value.toString(),
            int.parse(iterator.current.child("CUSTOMER UNIQUE ID").value.toString()),
        );
        break;
      }
    }
    return obj;
}

Future<String> lengthfunc(String userID,String path) async{
  DataSnapshot event;
  DatabaseReference compOrders;
  try{
    compOrders=
    FirebaseDatabase.instance.ref(userID).child(path);
  }catch(e){
    return "0";
  }
  event = await compOrders.get();
  return event.children.length.toString();
}

Future<String> cusPhno(String userId,String cusId) async{
  DataSnapshot event;
  DatabaseReference cusphnoref;
  String phno="";
  try{
    cusphnoref=FirebaseDatabase.instance.ref(userId).child("customers");
  }catch(e){
    return " ";
  }
  event=await cusphnoref.get();
  var iterator = event.children.iterator;
  while(iterator.moveNext()){
    if(iterator.current.child("CUSTOMER UNIQUE ID").value.toString() == cusId){
        phno=iterator.current.child("CUSTOMER MOBILE NO").value.toString();
        break;
    }
  }
  return phno;
}

void deleteFunc(String userID,String orderNo,String childname) async {
  DatabaseReference userRef =
  await FirebaseDatabase.instance.ref(userID);
  DatabaseReference compOrder = await userRef.child(childname);
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
void addtopaypend(String userID,String orderno,addeventmodel obj,String balance,String childname) async{
  DatabaseReference paypendref= FirebaseDatabase.instance.ref(userID).child("PAYMENT PENDING");
  await paypendref.push().set(<String,String>{
    "ORDER NO":obj.OrderNo,
    "ORDER":obj.title,
    "ORDER DESC":obj.desc,
    "AMOUNT":obj.amount,
    "GIVEN DATE":obj.givenDate,
    "CUSTOMER ID":obj.cusId,
    "DUE DATE":obj.date,
    "BALANCE AMOUNT":balance,
    "CUSTOMER NAME":obj.cusname,
    "CUSTOMER MOBILE NO":obj.cusmobile,
  }).then((value) {
    deleteFunc(userID, orderno,childname);
  });
}
void addtocomp(String userID,String orderno,addeventmodel obj,String childname) async{
  DatabaseReference compRef= FirebaseDatabase.instance.ref(userID).child("COMPLETED ORDERS");
  await compRef
      .child(orderno)
      .set(<String, String>{
    "ORDER NO": obj.OrderNo,
    "WORK TITLE": obj.title,
    "WORK DESCRIPTION": obj.desc,
    "DUE DATE":obj.date,
    "GIVEN DATE": obj.givenDate,
    "AMOUNT": obj.amount,
    "CUSTOMER ID":obj.cusId,
    "CUSTOMER NAME":obj.cusname,
    "CUSTOMER MOBILE NO":obj.cusmobile,
  }).then((value) {
    deleteFunc(userID, orderno,childname);
  });

}
Future<void> masterfunc(String userID,String orderno,String balance,int choice) async{
  DatabaseReference pendref= FirebaseDatabase.instance.ref(userID).child("PENDING WORKS");
  DataSnapshot snapshot=await pendref.get();
  var iter=snapshot.children.iterator;
  addeventmodel obj=addeventmodel.empty();
  while(iter.moveNext()){
    if(iter.current.child("ORDER NO").value.toString() == orderno){
      obj= new addeventmodel.withoutkey(
        iter.current.child("WORK TITLE").value.toString(),
        iter.current.child("WORK DESCRIPTION").value.toString(),
        iter.current.child("DUE DATE").value.toString(),
        iter.current.child("AMOUNT").value.toString(),
        iter.current.child("ORDER NO").value.toString(),
        iter.current.child("GIVEN DATE").value.toString(),
        iter.current.child("CUSTOMER ID").value.toString(),
        iter.current.child("CUSTOMER NAME").value.toString(),
        iter.current.child("CUSTOMER MOBILE NO").value.toString(),
      );
    }
  }
  switch(choice){
    case 1:{
      addtocomp(userID, orderno, obj,"PENDING WORKS");
      break;
    }
    case 2:{
      addtopaypend(userID, orderno, obj, balance,"PENDING WORKS");
      break;
    }
  }
}
Future<int> earningsfunc(String useruid) async{
  var earnings=0;
  DataSnapshot data=await  FirebaseDatabase.instance.ref(useruid).child("COMPLETED ORDERS").get();
  var iter=data.children.iterator;
  while(iter.moveNext()){
    earnings+=int.parse(iter.current.child("AMOUNT").value.toString());
  }
  return earnings;
}
Future<List<addeventmodel>> pending(String userid) async {
  List<addeventmodel> pendingData=[];
  DatabaseReference ref = FirebaseDatabase.instance
      .ref(userid)
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
  });
  // for(addeventmodel eve in pendingData){
  //   print(eve.orderUKey);
  // }
  return pendingData;
  //DataSnapshot event= await ref.get();
  //var iterator = event.children.iterator;
  //sprint(iterator.current.value.toString());
  //print("hi");
}