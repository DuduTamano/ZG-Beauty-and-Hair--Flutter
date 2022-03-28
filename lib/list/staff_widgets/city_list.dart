import 'package:flutter/material.dart';
import 'package:zg_beauty_and_hair/model/city_model.dart';
import 'package:zg_beauty_and_hair/view_model/staff_home/staff_home_view_model.dart';

staffDisplayCity(StaffHomeViewModel staffHomeViewModel) {
  return FutureBuilder(
    future: staffHomeViewModel.displayCities(),
    builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting)
        return Center(child: CircularProgressIndicator(),);
      else {
        var cities = snapshot.data as List<CityModel>;
        if(cities.length == 0)
          return Center(child: Text('לא מצליח לטעון רשימת הערים'),
          );
        else
          return GridView.builder(
              itemCount: cities.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisExtent: 100,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: ()=> staffHomeViewModel.onSelectedCity(context, cities[index]),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Card(
                      elevation: 8,
                      shape: staffHomeViewModel.isCitySelected(context, cities[index])
                          ? RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.black54, width: 4
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ) : null,
                      child: Center(
                        child: ListTile(
                          leading: Icon(
                            Icons.home_work,
                            color: Colors.black,
                          ),
                          title: Text('${cities[index].name}'),
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