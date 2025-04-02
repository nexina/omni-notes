// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:intl/intl.dart';
// import 'package:omni_notes/backup/ReminderView.dart';
// import 'package:omni_notes/main.dart';
// import 'package:flutter/material.dart';
// import 'package:omni_notes/reminder.dart';

// class NotificationService {
//   static Future<void> initilizeNotification() async {
//     await AwesomeNotifications().initialize(
//       null,
//       [
//         NotificationChannel(
//           channelGroupKey: "hight_importance_channel",
//           channelKey: 'high_importance_channel',
//           channelName: 'Basic notifications',
//           channelDescription: 'Notification channel for basic tests',
//           defaultColor: Colors.teal,
//           ledColor: Colors.teal,
//           playSound: true,
//           enableVibration: true,
//           importance: NotificationImportance.High,
//           channelShowBadge: true,
//           onlyAlertOnce: true,
//           //criticalAlerts: true,
//         )
//       ],
//       channelGroups: [
//         NotificationChannelGroup(
//             channelGroupKey: 'high_importance_channel_group',
//             channelGroupName: 'Grouped notifications')
//       ],
//       //debug: true
//     );

//     await AwesomeNotifications()
//         .isNotificationAllowed()
//         .then((isAllowed) async {
//       if (!isAllowed) {
//         await AwesomeNotifications().requestPermissionToSendNotifications();
//       }
//     });

//     await AwesomeNotifications().setListeners(
//         onActionReceivedMethod: onActionReceivedMethod,
//         onNotificationCreatedMethod: onNotificationCeatedMethod,
//         onDismissActionReceivedMethod: onDismissActionReceivedMethod,
//         onNotificationDisplayedMethod: onNotificationDisplayedMethod);
//   }

//   static Future<void> onNotificationCeatedMethod(
//       ReceivedNotification receivedNotification) async {
//     debugPrint(
//         'onNotificationCreatedMethod: ${receivedNotification.toString()}');
//   }

//   static Future<void> onActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     debugPrint('onNotificationCreatedMethod: ${receivedAction.toString()}');
//     final payload = receivedAction.payload ?? {};
//     if (payload["navigate"] == "true") {
//       app.navigatorKey.currentState?.push(
//         MaterialPageRoute(
//           builder: (context) => const ReminderView(),
//         ),
//       );
//     }
//   }

//   static Future<void> onDismissActionReceivedMethod(
//       ReceivedAction receivedAction) async {}

//   static Future<void> onNotificationDisplayedMethod(
//       ReceivedNotification receivedNotification) async {
//     print('onNotificationDisplayedMethod called');
//     print('ReceivedNotification id: ${receivedNotification.id}');
//     ReminderListState().changeStatus(receivedNotification.id!);
//     print('changeStatus called');
//     print('remList value: ${remList[receivedNotification.id!][2]}');
//   }

//   static Future<void> showNotification({
//     required final int id,
//     required final String title,
//     final String? sumamry,
//     final Map<String, String>? payload,
//     final ActionType actionType = ActionType.Default,
//     final NotificationLayout notificationLayout = NotificationLayout.Default,
//     final NotificationCategory? category,
//     final String? bigPicture,
//     final List<NotificationActionButton>? actionButtons,
//     final bool scheduled = false,
//     final DateTime? scheduledTime,
//     final Function? onNotificationDisplayedMethod,
//   }) async {
//     assert(!scheduled || (scheduled && scheduledTime != null));
//     await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id: id,
//           channelKey: 'high_importance_channel',
//           title: title,
//           summary: sumamry,
//           payload: payload,
//           actionType: actionType,
//           notificationLayout: notificationLayout,
//           category: category,
//           bigPicture: bigPicture,
//           fullScreenIntent: true,
//           //body: "You have a new Reminder !",
//           wakeUpScreen: true,
//           showWhen: true,
//         ),
//         actionButtons: actionButtons,
//         schedule: scheduled
//             ? NotificationCalendar(
//                 year: scheduledTime!.year,
//                 month: scheduledTime.month,
//                 day: scheduledTime.day,
//                 hour: scheduledTime.hour,
//                 minute: scheduledTime.minute,
//                 second: 0,
//                 millisecond: 0,
//                 timeZone:
//                     await AwesomeNotifications().getLocalTimeZoneIdentifier(),
//                 repeats: false,
//                 allowWhileIdle: true,
//                 preciseAlarm: true)
//             : null);

//     print("Create : " + scheduledTime.toString());
//   }

//   static Future<void> updateScheduledNotification({
//     required final int id,
//     required final String newTitle,
//     required final String newTime,
//   }) async {
//     await AwesomeNotifications().cancel(id);
//     await showNotification(
//       id: id,
//       title: newTitle,
//       scheduled: true,
//       category: NotificationCategory.Reminder,
//       scheduledTime: DateFormat("dd MMM yyyy, hh:mm a").parse(newTime),
//     );

//     print("Update : " + newTime);
//   }

//   static Future<void> cancelNotification({
//     required final int id,
//   }) async {
//     await AwesomeNotifications().cancel(id);
//   }

//   static Future<void> clearAllScheduledNotifications() async {
//     await AwesomeNotifications().cancelAllSchedules();
//   }
// }
