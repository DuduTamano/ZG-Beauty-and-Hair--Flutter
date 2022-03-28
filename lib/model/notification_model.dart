
class NotificationModel {
  String to='';
  NotificationContent notification = new NotificationContent(title:'', body:'');

  NotificationModel({required this.to, required this.notification});

  NotificationModel.fromJason(Map<String, dynamic> data) {
    to = data['to'];
    notification = data['notification'] != null
        ? NotificationContent.fromJason(data['notification'])
        : NotificationContent(title: '', body: '');
  }

  Map<String, dynamic> toJson() {
    final data = new Map<String, dynamic>();
    data['to'] = to;
    data['notification'] = notification.toJson();
    return data;
  }
}

class NotificationContent {
  String title='', body='';

  NotificationContent({required this.title, required this.body});

  NotificationContent.fromJason(Map<String, dynamic> data) {
    title = data['title'];
    body = data['body'];
  }

  Map<String, dynamic> toJson() {
    final data = new Map<String, dynamic>();
    data['title'] = title;
    data['body'] = body;
    return data;
  }

}