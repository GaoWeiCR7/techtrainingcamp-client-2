import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import 'package:flare_dart/math/mat2d.dart';

const PI = 3.1415926;

class SimulationPage extends StatefulWidget {
  SimulationPage({Key key, this.title}) : super(key: key) {}
  final String title;
  @override
  _SimulationPageState createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> with FlareController {
  ActorNode _hour_ptr;
  ActorNode _min_ptr;
  ActorNode _sec_ptr;
  @override
  void initState() {
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return FlareActor("assets/simulationClock.flr",
        alignment: Alignment.center, fit: BoxFit.contain, controller: this);
  }
}
