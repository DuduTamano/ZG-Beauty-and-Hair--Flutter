import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zg_beauty_and_hair/list/staff_widgets/appointment_list.dart';
import 'package:zg_beauty_and_hair/list/staff_widgets/city_list.dart';
import 'package:zg_beauty_and_hair/list/staff_widgets/salon_list.dart';
import 'package:zg_beauty_and_hair/state/state_management.dart';
import 'package:zg_beauty_and_hair/view_model/staff_home/staff_home_view_model_imp.dart';

class StaffHome extends ConsumerWidget {
  final staffHomeViewModel = StaffHomeViewModelImp();

  @override
  Widget build(BuildContext context, watch) {
    var currentStaffStep = watch(staffStep).state;
    var cityWatch = watch(selectedCity).state;
    var salonWatch = watch(selectedSalon).state;
    var dateWatch = watch(selectedDate).state;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            currentStaffStep == 1
                ? 'בחרי עיר'
                : currentStaffStep == 2
                ? 'בחרי מספרה'
                : currentStaffStep == 3
                ? 'קביעת תור'
                : 'מנהל', style: TextStyle(color: Colors.black),),
          actions: [
            currentStaffStep == 3 ? InkWell(
              child: Icon(Icons.history),
              onTap: () =>
                  Navigator.of(context).pushNamed('/bookingHistory'),
            ) : Container()
          ],
        ),
        body: Column(
          children: [
            //Area
            Expanded(
              flex: 10,
              child: currentStaffStep == 1
                  ? staffDisplayCity(staffHomeViewModel)
                  : currentStaffStep == 2
                  ? staffDisplaySalon(staffHomeViewModel, cityWatch.name)
                  : currentStaffStep == 3
                  ? staffDisplayAppointment(staffHomeViewModel, context)
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
                          onPressed: currentStaffStep ==1 ? null : ()=> context.read(staffStep).state--,
                          child: Text('חזרה'),
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
                          onPressed: (currentStaffStep == 1 &&
                              context.read(selectedCity).state.name.length == 0) ||
                              (currentStaffStep == 2 &&
                                  context.read(selectedSalon).state.docId!.length == 0) ||
                              currentStaffStep == 3
                              ? null
                              : ()=> context.read(staffStep).state++,
                          child: Text('הבא'),
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