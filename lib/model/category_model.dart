import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zg_beauty_and_hair/model/shopping_items.dart';

class CategoryModel{
  String? docId='';
  String name='', image='';

  DocumentReference? reference;

  CategoryModel({required this.name,required this.image});

  CategoryModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}