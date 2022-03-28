import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zg_beauty_and_hair/model/category_model.dart';
import 'package:zg_beauty_and_hair/model/shopping_items.dart';


Future<List<CategoryModel>> getCategories() async {
  List<CategoryModel> categories = new List<CategoryModel>.empty(growable: true);
  CollectionReference categoriesRef = FirebaseFirestore.instance.collection('Shopping');
  QuerySnapshot snapshot = await categoriesRef.get();

  snapshot.docs.forEach((element) {
    final data = element.data() as Map<String, dynamic>;
    var categoryModel = CategoryModel.fromJson((data));
    categoryModel.docId = element.id;
    categoryModel.reference = element.reference;
    categories.add(categoryModel);
  });
  return categories;
}

Future<List<ShoppingModel>> getShoppingItems(String? id) async {
  List<ShoppingModel> shoppingItems = new List<ShoppingModel>.empty(growable: true);
  CollectionReference shoppingRef = FirebaseFirestore.instance.collection('Shopping')
  .doc(id).collection('items');
  QuerySnapshot snapshot = await shoppingRef.get();

  snapshot.docs.forEach((element) {
    final data = element.data() as Map<String, dynamic>;
    var shoppingModel = ShoppingModel.fromJson((data));
    shoppingModel.docId = element.id;
    shoppingModel.reference = element.reference;
    shoppingItems.add(shoppingModel);
  });
  return shoppingItems;

}

Future<List<ShoppingModel>> getShoppingDetails(CategoryModel id, ShoppingModel shoppingId) async {
  List<ShoppingModel> shoppingItems = new List<ShoppingModel>.empty(growable: true);
  CollectionReference shoppingRef = FirebaseFirestore.instance.collection('Shopping').doc(id.docId).collection('items');
  QuerySnapshot snapshot = await shoppingRef.get();

  snapshot.docs.forEach((element) {
    shoppingItems.add(ShoppingModel.fromJson(element.data() as Map<String, dynamic>));
  });

  return shoppingItems;

}