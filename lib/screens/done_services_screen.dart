import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zg_beauty_and_hair/model/booking_model.dart';
import 'package:zg_beauty_and_hair/model/services_model.dart';
import 'package:zg_beauty_and_hair/state/state_management.dart';
import 'package:zg_beauty_and_hair/string/strings.dart';

import 'package:zg_beauty_and_hair/view_model/done_service/done_service_view_model_imp.dart';

class DoneServices extends ConsumerWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final doneServiceViewModel = DoneServiceViewModelImp();

  @override
  Widget build(BuildContext context, watch) {
    context.read(selectedServices).state.clear();

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            doneServiceText,
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
            Padding(padding: const EdgeInsets.all(8),
              child: FutureBuilder(
                future: doneServiceViewModel.displayDetailBooking(context, context.read(selectedTimeSlot).state),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator(),
                    );
                  else {
                    var bookingModel = snapshot.data as BookingModel;
                    return Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  child: Icon(Icons.account_box_outlined),
                                  backgroundColor: Colors.red,
                                ),
                                SizedBox(width: 30,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${bookingModel.customerName}',
                                      style: GoogleFonts.robotoMono(fontSize: 22, fontWeight: FontWeight.bold),),
                                    Text('${bookingModel.customerPhone.replaceAll("+972", "0")}',
                                      style: GoogleFonts.robotoMono(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Divider(thickness: 2,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Consumer(builder: (context, watch, _) {
                                  var servicesSelected = watch(selectedServices).state;

                                  return Text(
                                    'מחיר סופי \₪${context.read(selectedBooking).state.totalPrice == 0
                                        ? doneServiceViewModel.calculateTotalPrice(servicesSelected)
                                        : context.read(selectedBooking).state.totalPrice  }',
                                    style: GoogleFonts.robotoMono(fontSize: 22),
                                  );
                                }),
                                context.read(selectedBooking).state.done ? Chip(label: Text('Finished'),) : Container()
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: FutureBuilder(
                    future: doneServiceViewModel.displayServices(context),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      else
                        {
                          var services = snapshot.data as List<ServicesModel>;
                          return Consumer(
                            builder: (context, watch, _){
                              var servicesWatch = watch(selectedServices).state;
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Wrap(
                                      children: services.map((e) => Padding(
                                        padding: const EdgeInsets.all(4),
                                          child: ChoiceChip(
                                            selected: doneServiceViewModel.isSelectedService(context, e),
                                            selectedColor: Colors.blue,
                                            label: Text('${e.name}'),
                                            labelStyle: TextStyle(color: Colors.white),
                                            backgroundColor: Colors.black45,
                                            onSelected: (isSelected) => doneServiceViewModel.onSelectedChip(context, isSelected, e),
                                          ),
                                          )).toList(),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: ElevatedButton(
                                        onPressed:
                                          doneServiceViewModel.isDone(context)
                                            ? null
                                            : servicesWatch.length == 0
                                            ? () => doneServiceViewModel.finishService(context, scaffoldKey)
                                            : null,
                                        child: Text(
                                          'FINISH',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                        }
                    },
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}