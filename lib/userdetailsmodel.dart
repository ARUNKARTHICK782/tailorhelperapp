class customerdetailsmodel{
  String _customername="";
  String _customerlocation="";
  int _customerage=0;
  String _customermobile="";
  String _imglink="";
  String _gender="";
  int _customerUid=0;
  customerdetailsmodel(String customername,String customerlocation,String customermobile,int customeruid){
    this._customername=customername;
    this._customerlocation=customerlocation;
    this._customermobile=customermobile;
    this._customerUid=customeruid;
  }


  customerdetailsmodel.empty();

  int get customerUid => _customerUid;

  set customerUid(int value) {
    _customerUid = value;
  }

  customerdetailsmodel.temp(this._customername, this._customermobile,this._customerUid,this._gender);

  String get gender => _gender;

  set gender(String value) {
    _gender = value;
  }

  String get imglink => _imglink;

  set imglink(String value) {
    _imglink = value;
  }

  String get customermobile => _customermobile;

  set customermobile(String value) {
    _customermobile = value;
  }

  int get customerage => _customerage;

  set customerage(int value) {
    _customerage = value;
  }

  String get customerlocation => _customerlocation;

  set customerlocation(String value) {
    _customerlocation = value;
  }

  String get customername => _customername;

  set customername(String value) {
    _customername = value;
  }
}