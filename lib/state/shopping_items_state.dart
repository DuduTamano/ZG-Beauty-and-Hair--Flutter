import 'package:get/get.dart';
import 'package:zg_beauty_and_hair/model/shopping_items.dart';

class ShoppingItemsStateController extends GetxController {
  var selectShoppingItems = ShoppingModel(name: '', image: '', price: 0, dec: '').obs;
}