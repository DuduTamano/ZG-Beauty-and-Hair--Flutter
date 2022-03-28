import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:zg_beauty_and_hair/state/state_management.dart';
import 'package:zg_beauty_and_hair/view_model/booking/booking_view_model.dart';

displayConfirm(BookingViewModel bookingViewModel, BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        height: 90,
        child: Expanded(
          child: Image.asset('assets/images/zglogo.png'),
        ),
      ),
      Expanded(
        child: Container(
          padding: EdgeInsets.only(left: 9, right: 9),
          width: MediaQuery.of(context).size.width,
          child: Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                children: [
                  Text('Thank you for booking our services!'.toUpperCase(),
                    style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold),),
                  Text(
                    'Booking Information'.toUpperCase(),
                    style: GoogleFonts.robotoMono(),
                  ),
                  Padding(padding: EdgeInsets.only(top: 5)),
                  Divider(thickness: 1,),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(right: 9),),
                      Icon(Icons.calendar_today),
                      SizedBox(width: 20,),
                      Text('${context.read(selectedTime).state} - ${DateFormat('dd/MM/yyyy').format(context.read(selectedDate).state)}'.toUpperCase(),)
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(right: 9),),
                      Icon(Icons.person),
                      SizedBox(width: 20,),
                      Text('${context.read(selectedBarber).state.name}'.toUpperCase(),
                        style: GoogleFonts.robotoMono(),
                      ),
                    ],
                  ),
                  Divider(thickness: 1,),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(right: 9),),
                      Icon(Icons.home),
                      SizedBox(width: 20,),
                      Text('${context.read(selectedSalon).state.name}'.toUpperCase(),
                        style: GoogleFonts.robotoMono(),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(right: 9),),
                      Icon(Icons.location_on),
                      SizedBox(width: 20,),
                      Text('${context.read(selectedSalon).state.address}'.toUpperCase(),
                        style: GoogleFonts.robotoMono(),
                      ),
                    ],
                  ),

                  Divider(thickness: 1,),
                  Padding(padding: EdgeInsets.only(top: 30)),
                  ElevatedButton(
                    onPressed: () => bookingViewModel.confirmBooking(context, scaffoldKey),
                    child: Text('Confirm'),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(5),
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Padding(padding: EdgeInsets.only(bottom: 20),)
    ],
  );
}