import 'package:flutter/material.dart';
import 'package:zg_beauty_and_hair/cloud_firestore/banner_ref.dart';
import 'package:zg_beauty_and_hair/cloud_firestore/lookbook_ref.dart';
import 'package:zg_beauty_and_hair/cloud_firestore/user_ref.dart';
import 'package:zg_beauty_and_hair/model/image_model.dart';
import 'package:zg_beauty_and_hair/model/user_model.dart';
import 'package:zg_beauty_and_hair/state/state_management.dart';
import 'package:zg_beauty_and_hair/view_model/home/home_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeViewModelImp implements HomeViewModel {
  @override
  Future<List<ImageModel>> displayBanner() {
    return getBanners();
  }

  @override
  Future<List<ImageModel>> displayLookBook() {
    return getLookbook();
  }

  @override
  Future<UserModel> displayUserProfiles(BuildContext context, String phoneNumber) {
    return getUserProfiles(context, phoneNumber);
  }

  @override
  bool isStaff(BuildContext context) {
    return context
        .read(userInformation)
        .state.isStaff;
  }
}