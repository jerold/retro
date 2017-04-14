import 'dart:async';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:angular2/core.dart';

import 'package:retro/client/client_service.dart';
import 'package:retro/client/firebase_client_service.dart';
import 'package:retro/model/data_model.dart';

@Component(
  selector: 'retro',
  styleUrls: const ['package:retro/bulma.css'],
  templateUrl: 'package:retro/template.html',
)
class RetroComponent {
  ClientService _client = new FirebaseClient();
  ClientService get client => _client;

  RetroComponent();

  // Action shortcuts

  signIn() => _client.actions.signIn();

  signOut() => _client.actions.signOut();

  // Data Formatting

  String fmtDate(String date) => date != null ? new DateFormat.yMEd().add_jms().format(DateTime.parse(date)) : '';

  String fmtAgo(String date) {
    if (date == null) return 'forever ago';
    Duration period = new DateTime.now().difference(DateTime.parse(date));
    int days = period.inDays;
    if (days == 0) {
      int hours = period.inHours;
      if (hours == 0) {
        int minutes = period.inMinutes;
        if (minutes == 0) return "just now";
        if (minutes == 1) return "1 minute ago";
        return "${minutes} minutes ago";
      }
      if (hours == 1) return "1 hour ago";
      return "${hours} hours ago";
    }
    if (days == 1) return "1 day ago";
    return "${days} days ago";
  }
}