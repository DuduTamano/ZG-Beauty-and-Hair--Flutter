import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingModel{
  String? docId='';
  String name='', image='', dec='';
  int price = 0;

  DocumentReference? reference;

  ShoppingModel({required this.name, required this.image, required this.price, required this.dec});

  ShoppingModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    image = json['image'];
    dec = json['dec'];
    price = json['price'] == null ? 0 : int.parse(json['price'].toString());
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['dec'] = this.dec;
    data['price'] = this.price;
    return data;
  }
}