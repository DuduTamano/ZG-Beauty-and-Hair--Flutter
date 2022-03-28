
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String name='', address='', phoneNumber = '', created='';
  DocumentReference? reference;
  bool isStaff = false;

  UserModel({required this.name, required this.address, required this.phoneNumber, required this.created});

  UserModel.fromJson(Map<String, dynamic> json){
    address = json['address'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    isStaff = json['isStaff'] == null ? false : json['isStaff'] as bool;
  }


  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['isStaff'] = this.isStaff;
    return data;
  }
}