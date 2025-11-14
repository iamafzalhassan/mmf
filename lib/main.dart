import 'package:flutter/material.dart';
import 'package:mmf/app.dart';
import 'package:mmf/core/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  run();
}

void run() {
  runApp(const App());
}