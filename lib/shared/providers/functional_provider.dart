import 'package:demo_urban/.env/theme/app_theme.dart';
import 'package:demo_urban/shared/widgets/cards/alerts_template.dart';
import 'package:flutter/material.dart';

class FunctionalProvider extends ChangeNotifier {
  List<Widget> alerts = [];
  List<Widget> alertLoading = [];
  String nameUser = '';
  String namesSurnames = '';
  String imageUser = '';

  showAlert(
      {required GlobalKey key,
      required Widget content,
      bool closeAlert = false,
      bool animation = true,
      double padding = 20}) {

    final newAlert = Container(
        key: key,
        color: AppTheme.transparent,
        child: AlertTemplate(
            content: content,
            keyToClose: key,
            dismissAlert: closeAlert,
            animation: animation,
            padding: padding));
    alerts.add(newAlert);
    notifyListeners();
  }

  showAlertLoading(
      {required GlobalKey key,
      required Widget content,
      bool closeAlert = false,
      bool animation = true}) {

    final newAlert = Container(
        key: key,
        color: Colors.transparent,
        child: AlertTemplate(
            content: content,
            keyToClose: key,
            dismissAlert: closeAlert,
            animation: animation));
    alertLoading.add(newAlert);
    alerts.add(newAlert);
    notifyListeners();
  }

  addPage({required GlobalKey key, required Widget content}) {
    alerts.add(content);
    notifyListeners();
  }

  dismissAlert({required GlobalKey key}) {
    alerts.removeWhere((alert) => key == alert.key);
    notifyListeners();
  }

  clearAllAlert() {
    alerts = [];
    notifyListeners();
  }

  dismissAlertLoading({required GlobalKey key}) {
    alertLoading.removeWhere((alert) => key == alert.key);
    alerts.removeWhere((alert) => key == alert.key);
    notifyListeners();
  }

  saveUserName(String value) {
    nameUser = value;
    notifyListeners();
  }

  String getUserName() {
    return nameUser;
  }

  saveNamesSurnames(String value) {
    namesSurnames = value;
    notifyListeners();
  }

  String getNamesSurnames() {
    return namesSurnames;
  }


  
SaveUserImage(String userImage) {
    imageUser = userImage;
    notifyListeners();
  }

  String getUserImage() {
    return imageUser;
  }
}
