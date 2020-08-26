import 'package:flutter/material.dart';
import 'clock.dart';
import 'stopwatch.dart';
import 'alarm.dart';
import 'simulationClock.dart';
import 'world.dart';

void main() {
  runApp(MyApp());
}

var _stopWatchPage = new StopWatchPage();
var _simulationPage = new SimulationPage();
var _alarmCreatePage = new AlarmCreatePage();
var _notifyPage = new NotifyPage();
var _worldClockPage = new WorldCLockPage();
const CLOCK_EVENT = "clockEvent";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        "StopWatch": (context) => _stopWatchPage,
        "Simulation": (context) => _simulationPage,
        "AlarmCreate": (context) => _alarmCreatePage,
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  CLockPage _mainpage = CLockPage();
  TabController _tabController; //需要定义一个Controller
  List tabs = ["闹钟", "秒表", "世界时钟"];

  AlarmCreatePage _alarmCreatePage = AlarmCreatePage();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    // _tabController.addListener(() {
    //   switch (_tabController.index) {
    //     case 1:
    //       print(1);
    //       Navigator.pushNamed(context, "StopWatch");
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: ExactAssetImage('assets/background.gif'),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          bottom: TabBar(
              //生成Tab菜单
              controller: _tabController,
              tabs: tabs.map((e) => Tab(text: e)).toList()),
        ),
        body: TabBarView(
          controller: _tabController,
          children: tabs.map((e) {
            if (e == "闹钟")
              return Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(child: _mainpage),
                    Positioned(
                      bottom: 50,
                      child: Container(
                        height: 100,
                        width: 300,
                        child: _notifyPage,
                      ),
                    ),
                    Positioned(
                        top: 50,
                        child: FlatButton(
                          height: 300,
                          minWidth: 300,
                          shape: CircleBorder(),
                          splashColor: Colors.white24,
                          color: Colors.transparent,
                          child: Text(""),
                          onPressed: () {
                            _mainpage.changeState();
                          },
                        )),
                    Positioned(
                        bottom: 50,
                        child: FlatButton(
                          height: 50,
                          minWidth: 50,
                          color: Colors.white10,
                          splashColor: Colors.white30,
                          shape: CircleBorder(),
                          onPressed: () {
                            Navigator.pushNamed(context, "AlarmCreate");
                          },
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ))
                  ],
                ),
              );
            if (e == "秒表")
              return _stopWatchPage;
            else
              return _worldClockPage; //todo
          }).toList(),
        ),
        drawer: _mainpage.getDrawer(),
      ),
    );
  }
}

/* 
Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(child: _mainpage),
              Positioned(
                bottom: 50,
                child: Container(
                  height: 100,
                  width: 300,
                  child: NotifyPage(),
                ),
              ),
              Positioned(
                  top: 50,
                  child: FlatButton(
                    height: 300,
                    minWidth: 300,
                    shape: CircleBorder(),
                    splashColor: Colors.white10,
                    color: Colors.transparent,
                    child: Text(""),
                    onPressed: () {
                      //Navigator.pushNamed(context, "StopWatch");
                    },
                  )),
            ],
          ),
        ),


Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [

      ],),
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
            decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://img.zcool.cn/community/0372d195ac1cd55a8012062e3b16810.jpg'),
            fit: BoxFit.cover,
          ),
        )),
            Positioned(child: _mainpage),
            Positioned(
              bottom: 50,
              child: Container(
                height: 100,
                width: 300,
                child: NotifyPage(),
              ),
            ),
            Positioned(
                child: FlatButton(
              height: 300,
              minWidth: 300,
              shape: CircleBorder(),
              splashColor: Colors.white10,
              color: Colors.transparent,
              child: Text(""),
              onPressed: () {
                //Navigator.pushNamed(context, "StopWatch");
                _mainpage.change_state();
              },
            )),
          ],
        ),
      ),
      drawer: _mainpage.getDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white70,
        onPressed: () {
          Navigator.pushNamed(context, "Alarm");
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }*/
