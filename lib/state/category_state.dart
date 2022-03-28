import 'package:get/get.dart';
import 'package:zg_beauty_and_hair/model/category_model.dart';
import 'package:zg_beauty_and_hair/model/shopping_items.dart';

class CategoryStateController extends GetxController{
  var selectedCategory = CategoryModel(name: '', image: '').obs;
}