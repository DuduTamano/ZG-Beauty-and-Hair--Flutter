import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zg_beauty_and_hair/model/services_model.dart';
import 'package:zg_beauty_and_hair/state/state_management.dart';

Future<List<ServicesModel>> getServices(BuildContext context) async {
  var services = List<ServicesModel>.empty(growable: true);
  CollectionReference serviceRef =
  FirebaseFirestore.instance.collection('Services');
  QuerySnapshot snapshot = await serviceRef
  .where(context.read(selectedSalon).state.docId!, isEqualTo: true).get();

  snapshot.docs.forEach((element) {
    final data = element.data() as Map<String, dynamic>;
    var serviceModel = ServicesModel.fromJson(data);
    serviceModel.docId = element.id;
    services.add(serviceModel);
  });
  return services;
}