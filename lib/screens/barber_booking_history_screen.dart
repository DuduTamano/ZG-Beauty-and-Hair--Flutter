import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:zg_beauty_and_hair/model/booking_model.dart';
import 'package:zg_beauty_and_hair/state/staff_user_history_state.dart';
import 'package:zg_beauty_and_hair/utils/utils.dart';
import 'package:zg_beauty_and_hair/view_model/barber_booking_history/barber_booking_history_view_model_imp.dart';

class BarberHistoryScreen extends ConsumerWidget {
  final barberHistoryViewModel = BarberBookingHistoryViewModelImp();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var dateWatch = watch(barberHistorySelectedDate).state;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Barber History',
            style: TextStyle(
                color: Colors.black
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(
              color: Colors.black
          ),
        ),
        body: Column(
          children: [
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
                            Text('${DateFormat.MMMM().format(dateWatch)}',
                              style: GoogleFonts.robotoMono(color: Colors.black),
                            ),
                            Text(
                              '${dateWatch.day}',
                              style: GoogleFonts.robotoMono(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            Text('${DateFormat.EEEE().format(dateWatch)}',
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
                          onConfirm: (date) => context.read(barberHistorySelectedDate).state = date);
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
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: FutureBuilder(
                      future: barberHistoryViewModel.getBarberBookingHistory(context, dateWatch),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting)
                          return Center(child: CircularProgressIndicator(),);
                        else {
                          var userBookings = snapshot.data as List<BookingModel>;
                          if(userBookings.length == 0)
                            return Center(
                              child: Text('You have no booking in this date'),
                            );
                          else
                            return FutureBuilder(
                                future: syncTime(),
                                builder:(context, snapshot) {
                                  if(snapshot.connectionState == ConnectionState.waiting)
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  else {
                                    var syncTime = snapshot.data as DateTime;

                                    return ListView.builder(
                                        itemCount: userBookings.length,
                                        itemBuilder: (context, index) {

                                          return Card(
                                            elevation: 8,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(20),
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                            ),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(12),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Text(':תאריך התור'),
                                                              Text(DateFormat('dd/MM/yyyy').format(
                                                                  DateTime.fromMillisecondsSinceEpoch(userBookings[index].timeStamp)
                                                              )),
                                                            ],
                                                          ),
                                                          Column(
                                                            children: [
                                                              Text(':שעת התור'),
                                                              Text(TIME_SLOT.elementAt(userBookings[index].slot)
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Divider(thickness: 1,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Text(':ספרית'),
                                                              Text('${userBookings[index].barberName}'),
                                                            ],
                                                          ),
                                                          Column(
                                                            children: [
                                                              Text('שם המספרה'),
                                                              Text('${userBookings[index].salonName}'),
                                                              Text('${userBookings[index].salonAddress}'),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  }
                                });
                        }
                      }),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
