import 'package:flutter/material.dart';

class QaEnv extends BaseConfig{
  @override
  String get appName => 'demoUrban';

  @override
  String get serviceUrl => 'http://192.168.100.8:3000/';

  @override
  Color get primaryColor => AppTheme.error;
}