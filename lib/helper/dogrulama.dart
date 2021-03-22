import 'package:flutter/material.dart';

import '../goruntuleme/kaydol.dart';
import '../goruntuleme/oturumac.dart';

class Dogrulama extends StatefulWidget {
  @override
  _DogrulamaState createState() => _DogrulamaState();
}

class _DogrulamaState extends State<Dogrulama> {
  bool oturumAcGoster = true;

  void toggleView() {
    setState(() {
      oturumAcGoster = !oturumAcGoster;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (oturumAcGoster) {
      return OturumAc(toggleView);
    } else {
      return Kaydol(toggleView);
    }
  }
}
