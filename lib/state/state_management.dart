import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zg_beauty_and_hair/model/barber_model.dart';
import 'package:zg_beauty_and_hair/model/booking_model.dart';
import 'package:zg_beauty_and_hair/model/category_model.dart';
import 'package:zg_beauty_and_hair/model/city_model.dart';
import 'package:zg_beauty_and_hair/model/salon_model.dart';
import 'package:zg_beauty_and_hair/model/services_model.dart';
import 'package:zg_beauty_and_hair/model/shopping_items.dart';
import 'package:zg_beauty_and_hair/model/user_model.dart';

final userLogged = StateProvider((ref) => FirebaseAuth.instance.currentUser);
final userToken = StateProvider((ref) => '');
final forceReload = StateProvider((ref) => false);

final userInformation = StateProvider((ref) => UserModel(phoneNumber: '', name: '', address: '', created: ''));

//Booking state
final currentStep = StateProvider((ref) => 1);
final selectedCity = StateProvider((ref) => CityModel(name: ''));
final selectedSalon = StateProvider((ref) => SalonModel(name: '', address: ''));
final selectedBarber = StateProvider((ref) => BarberModel(name: ''));
final selectedDate = StateProvider((ref) => DateTime.now());
final selectedTimeSlot = StateProvider((ref) => -1);
final selectedTime = StateProvider((ref) => '');

//Delete Booking
final deleteFlagRefresh = StateProvider((ref) => false);

//Staff
final staffStep = StateProvider((ref) => 1);
final selectedBooking = StateProvider((ref) => BookingModel(
        totalPrice: 0,
        customerId: '',
        customerName: '',
        barberId: '',
        time: '',
        cityBook: '',
        customerPhone: '',
        done: false,
        salonName: '',
        salonId: '',
        salonAddress: '',
        barberName: '',
        slot: 0,
        timeStamp: 0));

final selectedServices = StateProvider((ref) => List<ServicesModel>.empty(growable: true));

//Loading
final isLoading = StateProvider((ref) => false);

final selectedItems = StateProvider((ref) => List<ShoppingModel>.empty(growable: true));
