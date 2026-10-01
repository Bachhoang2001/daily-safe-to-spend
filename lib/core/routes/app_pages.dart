import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_to_spend/core/routes/app_routes.dart';

/// Central route table configuration for GetX.
abstract class AppPages {
  AppPages._();

  static const String initial = AppRoutes.root;

  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.root,
      page: () => const Scaffold(body: Center(child: Text('Safe to Spend'))),
    ),
  ];
}
