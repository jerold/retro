import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:angular2/platform/common.dart';

import 'package:angular2/platform/browser.dart';

import 'package:retro/client/component.dart';
import 'package:retro/client/client_service.dart';
import 'package:retro/client/firebase_client_service.dart';

main() async {
  bootstrap(RetroComponent, [
      provide(ClientService, useClass: FirebaseClient),
      ROUTER_PROVIDERS,
      provide(LocationStrategy, useClass: HashLocationStrategy),
  ]);
}