import 'package:flutter/material.dart';
import 'package:shipment/models/shipment_model.dart';
import 'package:shipment/pages/create.dart';
import 'package:shipment/pages/search.dart';
import 'package:shipment/pages/shipment.dart';
import 'package:shipment/pages/shipment_management.dart';
import 'package:shipment/pages/update.dart';
import 'package:shipment/pages/fcm.dart';

class Routes {
  static const search = '/';
  static const fcm = '/fcm';
  static const shipment = '/shipment';
  static const shipmentManagement = '/shipment_management';
  static const shipmentCreate = '/shipment_create';
  static const shipmentUpdate = '/shipment_update';

  static Map<String, Widget Function(BuildContext)> routes = {
    search: (context) => const Search(),
    fcm: (context) => const FirebaseCloudMessagingMain(),
    shipmentManagement: (context) => const ShipmentManagement(),
    shipmentCreate: (context) => const CreateShipment(),
    shipment: (context) => Shipments(
          trackingNumber:
              ModalRoute.of(context)?.settings.arguments as String? ?? '',
        ),
    shipmentUpdate: (context) => UpdateShipment(
        shipment: ModalRoute.of(context)!.settings.arguments as ShipmentModel),
  };
}
