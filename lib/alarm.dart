import 'dart:async';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Alarm {
  List<Offset> alarms = [];
  List<Offset> get_notify(int num) {
    if (alarms.isEmpty) return alarms;
    if (num < alarms.length)
      return alarms.sublist(alarms.length - num, alarms.length);
    return alarms;
  }
}//这个是时钟类，需要全局的存活时间，必要的话可以写到文件里

Alarm _alarm = Alarm();

class ShowRow extends StatefulWidget {
  ShowRow({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ShowRowState createState() => _ShowRowState();
}//这里是闹钟界面

class _ShowRowState extends State<ShowRow> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class NotifyPage extends StatefulWidget {
  NotifyPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NotifyPageState createState() => _NotifyPageState();
}//主页的最近几条闹钟的提醒页面

class _NotifyPageState extends State<NotifyPage> with AutomaticKeepAliveClientMixin<NotifyPage>{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Timer timer;
  bool pressed = false;

  DateTime datetime;
  DateTime lastTime = DateTime.now();
  DateTime curTime;

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
        actions: <Widget>[
          FlatButton(
              onPressed: (){
                pressed = true;
                Navigator.of(context).pop();
              },
              child: Text('OK')
          )
        ],
      ),
    );
  }

  showNotification(String str) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High,importance: Importance.Max
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'Alarm', '$str', platform,
        payload: '$str');
  }

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings, onSelectNotification: onSelectNotification);
    datetime = DateTime.now();
    timer = Timer.periodic(Duration(seconds: 1), (timer){
      setState(() {

      });
      datetime = DateTime.now();
      curTime = DateTime.now();
      bool flag = false;
      for(int i = 0; i < _alarm.alarms.length;++i)
        if(_alarm.alarms[i].dx == datetime.hour&&_alarm.alarms[i].dy == datetime.minute)
          flag = true;
      if(flag)
      {
        if(lastTime.year!=curTime.year||lastTime.month!=curTime.month||lastTime.day!=curTime.day||lastTime.hour!=curTime.hour||lastTime.minute!=curTime.minute)
        {
          pressed = false;
          lastTime = curTime;
        }
        if(!pressed)
          {
            showNotification(datetime.hour.toString().padLeft(2,'0')+':'+datetime.minute.toString().padLeft(2,'0'));
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var c = _alarm.get_notify(_alarm.alarms.length);
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        if (c.length > index)
          return ListTile(
            title: Row(
              children: <Widget>[

                Text(
                  '${c[c.length - index-1].dx.toInt()}:${c[c.length - index-1].dy.toInt()}',
                  style: TextStyle(color: Colors.white70),
                ),
                Spacer(),
                FlatButton(
                    onPressed: (){
                      _alarm.alarms.remove(Offset(_alarm.alarms[index].dx,_alarm.alarms[index].dy));
                      setState(() {

                      });
                    },
                    child: Text('删除',style: TextStyle(fontSize: 20.0),),)
              ],
            )
          );
        else
          return Text(//TODO这里可以优化文本显示
            "empty",
            style: TextStyle(color: Colors.white70),
          );
      },
      separatorBuilder: (BuildContext context, int index) {
        return index % 2 == 0
            ? Divider(
          color: Colors.blue,
        )
            : Divider(
          color: Colors.green,
        );
      },
      itemCount: _alarm.alarms.length,
    );
  }
  @override
  bool get wantKeepAlive => true;
}

class AlarmCreatePage extends StatefulWidget {
  AlarmCreatePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AlarmCreatePageState createState() => _AlarmCreatePageState();
}

class _AlarmCreatePageState extends State<AlarmCreatePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int inhour = 0;
    int inminute = 0;
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                });
          },
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text(
          "新建闹钟",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          FlatButton(
              onPressed: () {

                bool flag = true;
                for(int i = 0; i < _alarm.alarms.length; ++i)
                  if(inhour == _alarm.alarms[i].dx&&inminute == _alarm.alarms[i].dy)
                    flag = false;
                if(flag)
                  _alarm.alarms.add(Offset(inhour.toDouble(),inminute.toDouble()));
                Navigator.pop(context);
                },
              child: Icon(Icons.done)
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NumberPicker.integer(
                  initialValue: 0,
                  minValue: 0,
                  maxValue: 23,
                  onChanged: (newValue){
                    inhour = newValue;
                  }),
              NumberPicker.integer(
                  initialValue: 0,
                  minValue: 0,
                  maxValue: 59,
                  onChanged: (newValue){
                    inminute = newValue;
                  }
              )

            ],
          )
        ],
      ),
    );
  }
}