import 'package:cloud_firestore/cloud_firestore.dart';

class SalonModel{
  String name='', address='';
  String? docId='';
  DocumentReference? reference;

  SalonModel({required this.name, required this.address});

  SalonModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    address = json['address'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    return data;
  }
}