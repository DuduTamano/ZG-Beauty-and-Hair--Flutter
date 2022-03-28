import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:zg_beauty_and_hair/state/state_management.dart';
import 'package:zg_beauty_and_hair/utils/utils.dart';
import 'package:zg_beauty_and_hair/view_model/staff_home/staff_home_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

staffDisplayAppointment(StaffHomeViewModel staffHomeViewModel, BuildContext context) {
  return FutureBuilder(
      future: staffHomeViewModel.isStaffOfThisSalon(context),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          var result = snapshot.data as bool;
          if(result)
            return displaySlot(staffHomeViewModel, context);
          else
            return Center(
              child: Text('סליחה את לא המנהלת'),
            );
        }
      }
  );
}

displaySlot(StaffHomeViewModel staffHomeViewModel, BuildContext context) {
  var now = context.read(selectedDate).state;
  return Column(
    children: [
      Padding(padding:
      const EdgeInsets.only(top: 15)
      ),
      Container(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Column(
                    children: [
                      Text('${DateFormat.MMMM().format(now)}',
                        style: GoogleFonts.robotoMono(color: Colors.black),
                      ),
                      Text(
                        '${now.day}',
                        style: GoogleFonts.robotoMono(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Text('${DateFormat.EEEE().format(now)}',
                        style: GoogleFonts.robotoMono(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime.now(), //can't select current date
                    maxTime: now.add(Duration(days: 31),
                    ),
                    onConfirm: (date) => context.read(selectedDate).state = date);
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.calendar_today,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(padding:
      const EdgeInsets.only(top: 30)
      ),
      Expanded(
        child: FutureBuilder(
          future: staffHomeViewModel.displayMaxAvailableTimeSlot(context.read(selectedDate).state),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator(),);
            else
            {
              var maxTimeSlot = snapshot.data as int;
              return FutureBuilder(
                future: staffHomeViewModel.displayTimeSlotOfBarber(
                    context, DateFormat('dd_MM_yyyy', ).format(context.read(selectedDate).state)),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),);
                  else {
                    var listTimeSlot = snapshot.data as List<int>;
                    return GridView.builder(
                      key: PageStorageKey('keep'),
                      itemCount: TIME_SLOT.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) => GestureDetector(
                        onTap:
                        !listTimeSlot.contains(index)
                            ? null
                            : () => staffHomeViewModel.processDoneServices(context, index),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Card(
                            elevation: 8,
                            color: staffHomeViewModel.getColorOfThisSlot(context, listTimeSlot, index, maxTimeSlot),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: GridTile(
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${TIME_SLOT.elementAt(index)}'),
                                      Text(listTimeSlot.contains(index)
                                          ? 'מלא'
                                          : maxTimeSlot > index
                                          ? 'לא פנוי'
                                          : 'תור פנוי')
                                    ],
                                  ),
                                ),
                                header:
                                context.read(selectedTime).state == TIME_SLOT.elementAt(index)
                                    ? Icon(Icons.check) : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    ],
  );
}