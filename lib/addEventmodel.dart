import 'package:flutter/material.dart';

class addeventmodel {
  String _title = "";
  String _desc = "";
  String _date="";
  String _time="";
  String _amount="";
  String _OrderNo="";
  String _givenDate="";
  String _cusId="";
  String _orderUKey="";
  String _cusname="";
  String _cusmobile="";
  String _balance="";

  addeventmodel(this._title, this._desc, this._date,this._amount,this._OrderNo,this._givenDate,this._cusId);
  addeventmodel.withbalance(this._title, this._desc, this._date,this._amount,this._OrderNo,this._givenDate,this._cusId,this._balance,this._cusname,this._cusmobile);

  addeventmodel.pendingwithkeys(this._title, this._desc, this._date,this._amount,this._OrderNo,this._givenDate,this._cusId,this._orderUKey,this._cusname,this._cusmobile);

  addeventmodel.withoutkey(this._title, this._desc, this._date,this._amount,this._OrderNo,this._givenDate,this._cusId,this._cusname,this._cusmobile);

  addeventmodel.empty();

  String get balance => _balance;

  set balance(String value) {
    _balance = value;
  }

  String get cusname => _cusname;

  set cusname(String value) {
    _cusname = value;
  }

  String get orderUKey => _orderUKey;

  set orderUKey(String value) {
    _orderUKey = value;
  }

  String get givenDate => _givenDate;

  set givenDate(String value) {
    _givenDate = value;
  }

  String get OrderNo => _OrderNo;

  set OrderNo(String value) {
    _OrderNo = value;
  }

  String get amount => _amount;

  set amount(String value) {
    _amount = value;
  }

  String get time => _time;

  set time(String value) {
    _time = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  String get desc => _desc;

  set desc(String value) {
    _desc = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get cusId => _cusId;

  set cusId(String value) {
    _cusId = value;
  }

  String get cusmobile => _cusmobile;

  set cusmobile(String value) {
    _cusmobile = value;
  }
}