
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:zg_beauty_and_hair/model/booking_model.dart';
import 'package:zg_beauty_and_hair/state/state_management.dart';
import 'package:zg_beauty_and_hair/utils/utils.dart';
import 'package:zg_beauty_and_hair/view_model/user_history/user_history_view_model_imp.dart';

class UserHistory extends ConsumerWidget {
  final scaffoldKey = GlobalKey<ScaffoldState> ();
  final userHistoryViewModel = UserHistoryViewModelImp();

  @override
  Widget build(BuildContext context, watch) {
    var watchRefresh = watch(deleteFlagRefresh).state;

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'History',
          style: TextStyle(color: Colors.black),),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,

        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(IconlyBroken.arrowLeft2, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            }
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: FutureBuilder(
          future: userHistoryViewModel.displayUserHistory(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator(),);
            else {
              var userBookings = snapshot.data as List<BookingModel>;
              if(userBookings.length == 0)
                return Center(
                  child: Text('cannot load booking information'),
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
                              var isExpried = DateTime.fromMillisecondsSinceEpoch(userBookings[index].timeStamp)
                                  .isBefore(syncTime);
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
                                    GestureDetector(
                                      onTap: (userBookings[index].done || isExpried)
                                          ? null
                                          : (){
                                        Alert(
                                            context: context,
                                            type: AlertType.warning,
                                            title: 'ביטול תור קיים',
                                            desc: 'את עומדת לבטל את התור הקיים',
                                            buttons: [
                                              DialogButton(child: Text('ביטול', style: TextStyle(color: Colors.black),), onPressed: ()=> Navigator.of(context).pop(),
                                                color: Colors.white,),
                                              DialogButton(child: Text('מחיקה', style: TextStyle(color: Colors.black),),
                                                onPressed: () {
                                                  Navigator.of(context).pop(); //ok
                                                  userHistoryViewModel.userCancelBooking(context, userBookings[index]);
                                                },
                                                color: Colors.white,)
                                            ]
                                        ).show();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(padding: const EdgeInsets.symmetric(vertical: 10),
                                              child: Text(
                                                userBookings[index].done
                                                    ? 'FINISH'
                                                    : isExpried
                                                    ? 'לא ניתן לבטל עבר הזמן'
                                                    : 'ביטול',
                                                style: TextStyle(color: isExpried ? Colors.grey[400] : Colors.white),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                        );
                      }
                    });
            }
          },

        ),
      ),
    );
  }
}