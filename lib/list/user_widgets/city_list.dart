import 'package:flutter/material.dart';
import 'package:zg_beauty_and_hair/model/city_model.dart';
import 'package:zg_beauty_and_hair/string/strings.dart';
import 'package:zg_beauty_and_hair/view_model/booking/booking_view_model.dart';


displayCityList(BookingViewModel bookingViewModel) {
  return FutureBuilder(
    future: bookingViewModel.displayCities(),
    builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting)
        return Center(child: CircularProgressIndicator(),);
      else {
        var cities = snapshot.data as List<CityModel>;
        if(cities.length == 0)
          return Center(child: Text(cannotLoadCity),
          );
        else
          return GridView.builder(
            key: PageStorageKey('keep'),
              itemCount: cities.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisExtent: 100,
              ),
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: ()=> bookingViewModel.onSelectedCity(context, cities[index]),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Card(
                      elevation: 8,
                      shape: bookingViewModel.isCitySelected(context, cities[index]) ?
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ) : null,
                      child: Center(
                        child: ListTile(
                          leading: Icon(
                            Icons.home_work,
                            color: Colors.black,
                          ),
                          trailing: bookingViewModel.isCitySelected(context, cities[index])
                              ? Icon(Icons.check) : null,
                          title: Text('${cities[index].name}',
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