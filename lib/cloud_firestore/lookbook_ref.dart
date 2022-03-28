
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zg_beauty_and_hair/model/image_model.dart';

Future<List<ImageModel>> getLookbook() async {
  List<ImageModel> result = new List<ImageModel>.empty(growable: true);
  CollectionReference bannerRef = FirebaseFirestore.instance.collection('Lookbook');
  QuerySnapshot snapshot = await bannerRef.get();
  snapshot.docs.forEach((element) {
    result.add(ImageModel.fromJson(element.data() as Map<String, dynamic>));
  });
  return result;
}