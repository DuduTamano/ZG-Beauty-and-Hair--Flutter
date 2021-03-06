import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_stepper/stepper.dart';
import 'package:zg_beauty_and_hair/dialog/my_loading_widget.dart';
import 'package:zg_beauty_and_hair/list/user_widgets/barber_list.dart';
import 'package:zg_beauty_and_hair/list/user_widgets/city_list.dart';
import 'package:zg_beauty_and_hair/list/user_widgets/confirm_list.dart';
import 'package:zg_beauty_and_hair/list/user_widgets/salon_list.dart';
import 'package:zg_beauty_and_hair/list/user_widgets/time_slot_list.dart';
import 'package:zg_beauty_and_hair/state/state_management.dart';
import 'package:zg_beauty_and_hair/view_model/booking/booking_view_model_imp.dart';

class BookingScreen extends ConsumerWidget {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final bookingViewModel = new BookingViewModelImp();

  int currentStepper = 0;

  @override
  Widget build(BuildContext context, watch) {
    var step = watch(currentStep).state;
    var cityWatch = watch(selectedCity).state;
    var salonWatch = watch(selectedSalon).state;
    var barberWatch = watch(selectedBarber).state;
    var dateWatch = watch(selectedDate).state;
    var timeWatch = watch(selectedTime).state;
    var timeSlotWatch = watch(selectedTimeSlot).state;

    var isLoadingWatch = watch(isLoading).state;

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Booking',
            style: TextStyle(color: Colors.black),),
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(icon: Icon(CupertinoIcons.back, color: Colors.black),
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              }
          ),
        ),
        body: Column(
          children: [
            //Step
            NumberStepper(
              activeStep: step-1,
              lineColor: Colors.grey,
              direction: Axis.horizontal,
              stepRadius: 17,
              enableNextPreviousButtons: false,
              enableStepTapping: false,
              numbers: [1,2,3,4,5],
              stepColor: Colors.black,
              activeStepColor: Colors.grey,
              numberStyle: TextStyle(
                color: Colors.white,
              ),

            ),
            //Screen
            Expanded(
              flex: 10,
              child: step == 1
                  ? displayCityList(bookingViewModel)
                  : step == 2
                  ? displaySalon(bookingViewModel, cityWatch.name)
                  : step == 3
                  ? displayBarber(bookingViewModel, salonWatch)
                  : step == 4
                  ? displayTimeSlot(bookingViewModel, context, barberWatch)
                  : step == 5
                  ? isLoadingWatch ? MyLoadingWidget(text: 'We are settings your booking',)
                  : displayConfirm(bookingViewModel, context, scaffoldKey)
                  : Container(),
            ),
            //Button
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: step ==1 ? null : ()=> context.read(currentStep).state--,
                          child: Text('????????'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black87,
                            elevation: 5,
                            shadowColor: Colors.grey[700],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (step == 1 && context.read(selectedCity).state.name.length == 0) ||
                              (step == 2 && context.read(selectedSalon).state.docId!.length == 0) ||
                              (step == 3 && context.read(selectedBarber).state.docId!.length == 0) ||
                              (step == 4 && context.read(selectedTimeSlot).state == -1)
                              ? null : step == 5
                              ? null : ()=> context.read(currentStep).state++,
                          child: Text('??????'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black87,
                            elevation: 5,
                            shadowColor: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
