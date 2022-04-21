import 'dart:ui';
class customcolors{
  var _violet=Color(0xff734370);
  var _sandal=Color(0xfff7ebe6);
  var _darksandal=Color(0xffc4a99d);
  var _mobilewidth=250;
  var _webwidth=100;

  get mobilewidth => _mobilewidth;

  set mobilewidth(value) {
    _mobilewidth = value;
  }

  get darksandal => _darksandal;
  get sandal => _sandal;
  get violet => _violet;

  get webwidth => _webwidth;

  set webwidth(value) {
    _webwidth = value;
  }
}
