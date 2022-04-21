class orderlistmodel{
  String _ordername="";
  String _orderquantity="";

  orderlistmodel(this._ordername, this._orderquantity);
  orderlistmodel.empty();
  String get orderquantity => _orderquantity;

  set orderquantity(String value) {
    _orderquantity = value;
  }

  String get ordername => _ordername;

  set ordername(String value) {
    _ordername = value;
  }
}