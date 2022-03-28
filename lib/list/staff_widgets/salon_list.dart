import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zg_beauty_and_hair/model/salon_model.dart';
import 'package:zg_beauty_and_hair/state/state_management.dart';
import 'package:zg_beauty_and_hair/view_model/staff_home/staff_home_view_model.dart';

staffDisplaySalon(StaffHomeViewModel staffHomeViewModel, String name) {
  return FutureBuilder(
    future: staffHomeViewModel.displaySalon(name),
    builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting)
        return Center(child: CircularProgressIndicator(),);
      else {
        var salons = snapshot.data as List<SalonModel>;
        if(salons.length == 0)
          return Center(child: Text('לא מצליח לטעון רשימת סלונים'),);
        else
          return GridView.builder(
              itemCount: salons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisExtent: 100,
              ),
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: ()=> staffHomeViewModel.onSelectedSalon(context, salons[index]),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Card(
                      elevation: 8,
                      child: Center(
                        child: ListTile(
                          shape: staffHomeViewModel.isSalonSelected(context, salons[index])
                              ? RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.black54, width: 4
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ) : null,
                          leading: Icon(
                            Icons.home_outlined,
                            color: Colors.black,
                          ),
                          trailing: context.read(selectedSalon).state.docId ==
                          salons[index].docId
                          ? Icon(Icons.check)
                          : null,
                          title: Text(
                              '${salons[index].name}'
                          ),
                          subtitle: Text(
                            '${salons[index].address}',
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