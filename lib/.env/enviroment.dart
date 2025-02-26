import 'package:flutter/material.dart';
import 'package:enviroment_config/config/base_config.dart';
import 'package:enviroment_config/config/prod_env.dart';


class Environment{
  static final Environment _environment = Environment._internal();

  factory Environment()=>_environment;

  Environment._internal();

  // static const String dev='DEV';
  // static const String qa='QA';
  static const String prod='PROD';

  BaseConfig? config;

  initConfig(String environment){
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment){
    ProdEnv();
    // switch(environment){
    //   case Environment.qa:
    //   return QaEnv();
    //   case Environment.prod:
    //   return ProdEnv();
    //   default:
    //   return DevEnv();
    // }
  }
}