import 'dart:core';
import 'dart:async';
import 'dart:convert';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_icons/flutter_weather_icons.dart';
import 'package:http/http.dart' as http;
import 'package:flare_dart/math/mat2d.dart';

const key = 'a17d10bd349e432d99228b4331ed7628';
const PI = 3.1415926;

//实况天气  https://devapi.heweather.net/v7/weather/now?{请求参数}
const baseurl = "https://devapi.heweather.net/v7/weather/now?";
WeatherData weather = WeatherData.empty();
bool webRequest = false;

String cityname = '';
String cityid = '';

class CLockPage extends StatefulWidget {
  CLockPage({Key key, this.title}) : super(key: key) {}
  _ClockPageState _state;
  final String title;
  @override
  _ClockPageState createState() {
    print("create");
    return _state = _ClockPageState();
  }

  void changeState() {
    _state.state == 0 ? _state.state = 1 : _state.state = 0;
  }
  // _update(Timer _timer) {
  //   //_pState.setTime();
  // }

  Widget getDrawer() => _ClockPageState().buildCityList();
}

class _ClockPageState extends State<CLockPage> with FlareController {
  Timer timer;
  int state = 0;
  String _time = "00:00";
  String _date = "0000-00-00";
  String _weekday = "";
  String errorinfo = "";
  ActorNode _hour_ptr;
  ActorNode _min_ptr;
  ActorNode _sec_ptr;
  List<String> _chinacitys = [
    "北京 101010100",
    "重庆 101040100",
    "上海 101020100",
    "天津 101030100",
    "香港 101320101",
    "九龙 101320102",
    "新界 101320103",
    "澳门 101330101",
    "氹仔岛 101330102",
    "路环岛 101330103",
    "石家庄 101090101",
    "唐山 101090501",
    "秦皇岛 101091101",
    "邯郸 101091001",
    "邢台 101090901",
    "保定 101090201",
    "张家口 101090301",
    "承德 101090402",
    "沧州 101090701",
    "廊坊 101090601",
    "衡水 101090801",
    "雄安 101091201",
    "太原 101100101",
    "大同 101100201",
    "阳泉 101100301",
    "长治 101100501",
    "晋城 101100601",
    "朔州 101100901",
    "晋中 101100401",
    "运城 101100801",
    "忻州 101101001",
    "临汾 101100701",
    "吕梁 101101101",
    "呼和浩特 101080101",
    "包头 101080201",
    "乌海 101080301",
    "赤峰 101080601",
    "通辽 101080501",
    "鄂尔多斯 101080701",
    "呼伦贝尔 101081013",
    "巴彦淖尔 101080811",
    "乌兰察布 101080401",
    "兴安盟 101081108",
    "锡林郭勒 101080902",
    "阿拉善盟 101081213",
    "沈阳 101070101",
    "大连 101070201",
    "鞍山 101070301",
    "抚顺 101070401",
    "本溪 101070501",
    "丹东 101070601",
    "锦州 101070701",
    "营口 101070801",
    "阜新 101070901",
    "辽阳 101071001",
    "盘锦 101071301",
    "铁岭 101071101",
    "辽宁朝阳 101071201",
    "葫芦岛 101071401",
    "长春 101060101",
    "吉林市 101060201",
    "四平 101060401",
    "辽源 101060701",
    "通化 101060501",
    "白山 101060901",
    "松原 101060801",
    "白城 101060601",
    "延边朝鲜自治州 101060301",
    "哈尔滨 101050101",
    "大庆 101050901",
    "佳木斯 101050401",
    "鹤岗 101051201",
    "双鸭山 101051301",
    "牡丹江 101050301",
    "伊春 101050801",
    "七台河 101051002",
    "黑河 101050601",
    "绥化 101050501",
    "阿城 101050104",
    "双城 101050102",
    "尚志 101050111",
    "五常 101050112",
    "齐齐哈尔 101050201",
    "鸡西 101051101",
    "虎林 101051102",
    "密山 101051103",
    "大兴安岭 101050701",
    "南京 101190101",
    "无锡 101190201",
    "徐州 101190801",
    "苏州 101190401",
    "常州 101191101",
    "南通 101190501",
    "连云港 101191001",
    "淮安 101190901",
    "盐城 101190701",
    "扬州 101190601",
    "镇江 101190301",
    "泰州 101191201",
    "宿迁 101191301",
    "杭州 101210101",
    "宁波 101210401",
    "温州 101210701",
    "嘉兴 101210301",
    "湖州 101210201",
    "绍兴 101210501",
    "金华 101210901",
    "衢州 101211001	",
    "舟山 101211101	",
    "台州 101210601",
    "丽水 101210801",
    "合肥 101220101",
    "芜湖 101220301",
    "蚌埠 101220201",
    "淮南 101220401",
    "马鞍山 101220501",
    "淮北 101221201",
    "铜陵 101221301",
    "安庆 101220601",
    "黄山 101221001",
    "滁州 101221101",
    "阜阳 101220801",
    "宿州 101220701",
    "六安 101221501",
    "亳州 101220901",
    "池州 101221701",
    "宣城 101221401",
    "福州 101230101",
    "厦门 101230201",
    "莆田 101230401",
    "三明 101230801",
    "泉州 101230501",
    "漳州 101230601",
    "南平 101230901",
    "龙岩 101230701",
    "宁德 101230301",
    "南昌 101240101",
    "景德镇 101240801",
    "萍乡 101240901",
    "九江 101240201",
    "新余 101241001",
    "鹰潭 101241101",
    "赣州 101240701",
    "吉安 101240601",
    "宜春 101240501",
    "抚州 101240401",
    "上饶 101240301",
    "济南 101120101",
    "青岛 101120201",
    "淄博 101120301",
    "德州 101120401",
    "烟台 101120501",
    "枣庄 101121401",
    "东营 101121201",
    "潍坊 101120601",
    "济宁 101120701",
    "泰安 101120801",
    "威海 101121301",
    "日照 101121501",
    "莱芜 101121601",
    "临沂 101120901",
    "聊城 101121701",
    "滨州 101121101",
    "菏泽 101121001",
    "郑州 101180101",
    "开封 101180801",
    "洛阳 101180901",
    "平顶山 101180501",
    "安阳 101180201",
    "鹤壁 101181201",
    "新乡 101180301",
    "焦作 101181101",
    "濮阳 101181301",
    "许昌 101180401",
    "漯河 101181501",
    "三门峡 101181701",
    "南阳 101180701",
    "商丘 101181001",
    "信阳 101180601",
    "周口 101181401",
    "驻马店 101181601",
    "武汉 101200101",
    "襄阳 101200201",
    "黄石 101200601",
    "十堰 101201101",
    "神农架 101201201",
    "宜昌 101200901",
    "鄂州 101200301",
    "荆门 101201401",
    "孝感 101200401",
    "荆州 101200801",
    "黄冈 101200501",
    "咸宁 101200701",
    "随州 101201301",
    "恩施 101201001",
    "天门 101201501",
    "仙桃 101201601",
    "潜江 101201701",
    "长沙 101250101",
    "株洲 101250301",
    "湘潭 101250201",
    "衡阳 101250401",
    "邵阳 101250901",
    "岳阳 101251001",
    "常德 101250601",
    "张家界 101251101",
    "益阳 101250700",
    "郴州 101250501",
    "永州 101251401",
    "怀化 101251201",
    "娄底 101250801",
    "广州 101280101",
    "韶关 101280201",
    "深圳 101280601",
    "珠海 101280701",
    "汕头 101280501",
    "佛山 101280100",
    "江门 101281101",
    "湛江 101281001",
    "茂名 101282001",
    "肇庆 101280901",
    "惠州 101280301",
    "梅州 101280401",
    "汕尾 101282101",
    "河源 101281201",
    "阳江 101281801",
    "清远 101281301",
    "东莞 101281601",
    "中山 101281701",
    "潮州 101281501",
    "揭阳 101281901",
    "云浮 101281401",
    "南宁 101300101",
    "柳州 101300301",
    "桂林 101300501",
    "梧州 101300601",
    "北海 101301301",
    "防城港 101301401",
    "钦州 101301101",
    "贵港 101300801",
    "玉林 101300901",
    "百色 101301001",
    "贺州 101300701",
    "河池 101301201",
    "来宾 101300401",
    "崇左 101300201",
    "海口 101310101",
    "三亚 101310201",
    "东方 101310202",
    "文昌 101310212",
    "五指山 101310222",
    "三沙 101310301",
    "成都 101270101",
    "自贡 101270301",
    "攀枝花 101270201",
    "泸州 101271001",
    "德阳 101272001",
    "绵阳 101270301",
    "广元 101272101",
    "遂宁 101270701",
    "内江 101271201",
    "乐山 101271401",
    "南充 101270501",
    "眉山 101271501",
    "凉山 101271601",
    "宜宾 101271101",
    "甘孜 101271801",
    "阿坝 101271901",
    "广安 101270801",
    "达州 101270601",
    "雅安 101271701",
    "巴中 101270901",
    "资阳 101271301",
    "贵阳 101260101",
    "六盘水 101260801",
    "遵义 101260201",
    "安顺 101260301",
    "铜仁 101260601",
    "毕节 101260701",
    "昆明 101290101",
    "曲靖 101290401",
    "玉溪 101290701",
    "保山 101290501",
    "文山 101290601",
    "楚雄 101290801",
    "昭通 101291001",
    "丽江 101291401",
    "普洱 101290901",
    "临沧 101291101",
    "西双版纳 101291601",
    "大理 101290201",
    "红河 101290301",
    "德宏 101291501",
    "怒江 101291201",
    "迪庆 101291301",
    "拉萨 101140101",
    "昌都 101140501",
    "山南地区 101140301",
    "日喀则 101140201",
    "那曲 101140601",
    "林芝 101140401",
    "阿里 101140701",
    "西安 101110101",
    "铜川 101111001",
    "杨凌 101111101",
    "宝鸡 101110901",
    "咸阳 101110200",
    "渭南 101110501",
    "延安 101110300",
    "汉中 101110801",
    "榆林 101110401",
    "安康 101110701",
    "商洛 101110601",
    "兰州 101160101",
    "嘉峪关 101161401",
    "金昌 101160601",
    "白银 101161301",
    "天水 101160901",
    "武威 101160501",
    "张掖 101160701",
    "平凉 101160301",
    "酒泉 101160801",
    "庆阳 101160401",
    "定西 101160201",
    "陇南 101161001",
    "临夏 101161101",
    "甘南 101161201",
    "西宁 101150101",
    "海东 101150201",
    "海北 101150801",
    "黄南 101150301",
    "青海海南 101150401",
    "果洛 101150501",
    "玉树 101150601",
    "海西 101150701",
    "银川 101170101",
    "石嘴山 101170201",
    "吴忠 101170301",
    "固原 101170401",
    "中卫 101170501",
    "乌鲁木齐 101130101",
    "克拉玛依 101130201",
    "吐鲁番 101130501",
    "哈密 101131201",
    "昌吉 101130401",
    "博尔塔拉 101131601",
    "巴音郭楞 101130601",
    "阿克苏 101130801",
    "克孜勒苏柯尔克孜",
    "喀什 101130901",
    "和田 101131301",
    "伊犁 101131001",
    "塔城 101131101",
    "阿勒泰 101131401",
    "石河子 101130301",
    "铁门关 101131901",
    "昆玉 101131920",
    "北屯 101132101",
    "双河 101132201",
    "可克达拉 101132301",
    "五家渠 101131801",
    "台北 101340101",
    "桃园 101340102",
    "新竹 101340103",
    "宜兰 101340104",
    "高雄 101340201",
    "嘉义 101340202",
    "台南 101340203",
    "台东 101340204",
    "屏东 101340205",
    "台中 101340401",
    "苗栗 101340402",
    "彰化 101340403",
    "南投 101340404",
    "花莲 101340405",
    "云林 101340406"
  ];

  @override
  void initialize(FlutterActorArtboard artboard) {
    _hour_ptr = artboard.getNode("hour");
    _min_ptr = artboard.getNode("minute");
    _sec_ptr = artboard.getNode("seconds");
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    _sec_ptr.rotation = DateTime.now().second / 60.0 * 2 * PI;
    _min_ptr.rotation = DateTime.now().minute / 60.0 * 2 * PI;
    _hour_ptr.rotation = DateTime.now().hour / 24.0 * 4 * PI;
    return true;
  }

  _getWeather() async {
    WeatherData data = await _fetchWeather();
    weather = data;
  }

  Future<WeatherData> _fetchWeather() async {
    final response = await http.get(
        // 'https://devapi.heweather.net/v7/weather/now?location=${cityid}&key=${key}');
        '${baseurl}location=${cityid}&key=${key}');
    if (response.statusCode == 200) {
      webRequest = true;
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      errorinfo = "获取天气信息失败";
      webRequest = false;
      return new WeatherData();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
    print("dispose");
  }

  @override
  void initState() {
    super.initState();
    timer = new Timer.periodic(Duration(milliseconds: 10), _setTime);
  }

  _setTime(Timer timer) {
    setState(() {
      int h = DateTime.now().hour.truncate();
      int m = DateTime.now().minute.truncate();
      _date = DateTime.now().toString().split(" ")[0];
      String twd = DateTime.now().weekday.toString();
      if (twd == '1')
        _weekday = "周一";
      else if (twd == '2')
        _weekday = "周二";
      else if (twd == '3')
        _weekday = "周三";
      else if (twd == '4')
        _weekday = "周四";
      else if (twd == '5')
        _weekday = "周五";
      else if (twd == '6')
        _weekday = "周六";
      else if (twd == '7') _weekday = "周日";
      String hStr = (h % 100).toString().padLeft(2, '0');
      String mStr = (m % 60).toString().padLeft(2, '0');
      _time = '$hStr:$mStr ';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (state == 0)
      return Stack(alignment: Alignment.center, children: [
        Positioned(
            bottom: 300,
            child: Column(children: [
              Row(
                children: <Widget>[
                  Column(children: <Widget>[
                    Text(cityname,
                        style: TextStyle(color: Colors.white70, fontSize: 20)),
                    Text(_time,
                        style: TextStyle(color: Colors.white70, fontSize: 65)),
                  ]),
                  SizedBox(
                    width: 1,
                    height: 90,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.grey),
                    ),
                  ),
                  Container(
                    child: _chooseweatherinfo(),
                  ),
                ],
              ),
            ])),
        Positioned(
          bottom: 270,
          child: Text("${_date} ${_weekday}",
              style: TextStyle(color: Colors.white70, fontSize: 20)),
        ),
      ]);
    else
      return FlareActor("assets/simulationClock.flr",
          alignment: Alignment.center, fit: BoxFit.contain, controller: this);
  }

  Widget _chooseweatherinfo() {
    if (webRequest) {
      return Column(children: <Widget>[
        Row(children: <Widget>[
          Container(
            child: _chooseicon(),
          ),
          Text(weather.cond,
              style: TextStyle(color: Colors.white70, fontSize: 20)),
        ]),
        Text(weather.tmp,
            style: TextStyle(color: Colors.white70, fontSize: 20)),
        Text(weather.win,
            style: TextStyle(color: Colors.white70, fontSize: 15)),
      ]);
    } else {
      return Column(children: <Widget>[
        Text("暂无天气信息", style: TextStyle(color: Colors.white70, fontSize: 15))
      ]);
    }
  }

  Widget _chooseicon() {
    if (weather.cond == "晴") {
      if ((DateTime.now().hour.truncate()) % 100 > 5 &&
          (DateTime.now().hour.truncate()) % 100 < 20)
        return Icon(
          WeatherIcons.wiDaySunny,
          color: Colors.red,
        );
      else
        return Icon(
          WeatherIcons.wiMoonAltFull,
          color: Colors.green,
        );
    } else if (weather.cond == "阴")
      return Icon(
        WeatherIcons.wiCloud,
        color: Colors.green,
      );
    else if (weather.cond == "多云")
      return Icon(
        WeatherIcons.wiCloudy,
        color: Colors.green,
      );
    else if (weather.cond == "雨" ||
        weather.cond == "小雨" ||
        weather.cond == "中雨" ||
        weather.cond == "大雨")
      return Icon(
        WeatherIcons.wiDayRain,
        color: Colors.green,
      );
    else if (weather.cond == "雪" || weather.cond == "大雪")
      return Icon(
        WeatherIcons.wiDaySnow,
        color: Colors.green,
      );
    else
      return Icon(
        WeatherIcons.wiCloud,
        color: Colors.green,
      );
  }

  Widget buildCityList() {
    return new ListView.builder(
      itemCount: _chinacitys.length,
      itemBuilder: (context, i) {
        return _buildRow(_chinacitys[i].split(" ")[0], i);
      },
    );
  }

  Widget _buildRow(String city, int i) {
    return new ListTile(
      title: new Text(
        city,
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
      onTap: () {
        cityname = _chinacitys[i].split(" ")[0];
        print("ontap: cityname = ${cityname}");
        cityid = _chinacitys[i].split(" ")[1];
        _getWeather();
      },
    );
  }
}

class WeatherData {
  String cond; //天气
  String tmp; //温度
  String hum; //湿度
  String win;

  WeatherData({this.cond, this.tmp, this.hum, this.win});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cond: json['now']['text'],
      tmp: json['now']['temp'] + "°",
      hum: "湿度  " + json['now']['humidity'] + "%",
      win:
          "   " + json['now']['windDir'] + " " + json['now']['windScale'] + "级",
    );
  }

  factory WeatherData.empty() {
    return WeatherData(
      cond: "",
      tmp: "",
      hum: "",
    );
  }
}
