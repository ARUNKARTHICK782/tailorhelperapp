import 'package:flutter/cupertino.dart';
import 'package:tailorapp/addEventmodel.dart';
import 'package:tailorapp/userdetailsmodel.dart';

class customerdetails extends InheritedWidget{
  customerdetails({
    Key? key,
    required this.cusdetails,
    required Widget child,
  }) : super(key: key, child: child);
  List<customerdetailsmodel> cusdetails;
  static customerdetails? of(BuildContext context) {
    final customerdetails? result = context.dependOnInheritedWidgetOfExactType<customerdetails>();
    return result;
  }
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    throw UnimplementedError();
  }
  void show(){
    print(cusdetails.toString());
  }
}