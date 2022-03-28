import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:zg_beauty_and_hair/model/barber_model.dart';
import 'package:zg_beauty_and_hair/model/salon_model.dart';
import 'package:zg_beauty_and_hair/view_model/booking/booking_view_model.dart';

displayBarber(BookingViewModel bookingViewModel, SalonModel salonModel) {
  return FutureBuilder(
    future: bookingViewModel.displayBarber(salonModel),
    builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting)
        return Center(
          child: CircularProgressIndicator(),
        );
      else {
        var barbers = snapshot.data as List<BarberModel>;
        if(barbers.length == 0)
          return Center(
            child: Text('רשימת ספריות ריקה'),);
        else
          return GridView.builder(
              key: PageStorageKey('keep'),
              itemCount: barbers.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisExtent: 100,
              ),
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: ()=> bookingViewModel.onSelectedBarber(context, barbers[index]),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Card(
                      elevation: 8,
                      child: Center(
                        child: ListTile(
                          leading: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          trailing: bookingViewModel.isBarberSelected(context, barbers[index])
                              ? Icon(Icons.check)
                              : null,
                          title: Text(
                              '${barbers[index].name}'
                          ),
                          subtitle: RatingBar.builder(
                            itemSize: 16,
                            allowHalfRating: true,
                            initialRating: barbers[index].rating,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            ignoreGestures: true,
                            itemBuilder: (context,_) =>
                                Icon(Icons.star, color: Colors.amber),
                            itemPadding: const EdgeInsets.all(4),
                            onRatingUpdate: (value) {},
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
      }
    },
  );
}
