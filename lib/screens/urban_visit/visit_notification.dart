import 'package:edukar/modules/notifications/models/notifications_response.dart';
import 'package:edukar/modules/notifications/services/notification_service.dart';
import 'package:edukar/modules/notifications/widgets/card_notifications.dart';
import 'package:edukar/modules/notifications/widgets/skeleaton_notifications.dart';
import 'package:edukar/shared/helpers/responsive.dart';
import 'package:edukar/shared/providers/student_provider.dart';
import 'package:edukar/shared/widgets/home_layout.dart';
import 'package:edukar/shared/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../shared/helpers/global_helper.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key, required this.keyPage});
  final GlobalKey<State<StatefulWidget>> keyPage;

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationService _notificationService = NotificationService();

  NotificationsResponse? notifications;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getNotifications();
    });
    GlobalHelper().trackScreen("Pantalla de Notificaciones");
    super.initState();
  }

  _getNotifications() async {
    DateTime now = DateTime.now();

    String endDate = DateFormat('yyyy-MM-dd').format(now);
    DateTime startDate = now.subtract(const Duration(days: 7));
    String startDateFormat = DateFormat('yyyy-MM-dd').format(startDate);

    final body = {"fechaInicio": startDateFormat, "fechaFin": endDate};

    final response = await _notificationService.getNotification(context, body);

    if (!response.error) {
      notifications = response.data;
      setState(() {});
    }
  }

  List<Widget> cardNotification() {
    return notifications!.notifications
        .map((e) => CardNotifications(notification: e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return HomeLayoutWidget(
      nameInterceptor: 'notification',
      keyDismiss: widget.keyPage,
      requiredStack: false,
      child: Column(
        children: [
          Column(
            children: [
              Text('ddddd'),
              const SizedBox(height: 10),
            ],
          )
        ],
      ),
    );
  }
}
