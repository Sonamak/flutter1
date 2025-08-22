import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

Future<void> announce(BuildContext context, String message) async {
  final dir = Directionality.of(context);
  await SemanticsService.announce(message, dir);
}
