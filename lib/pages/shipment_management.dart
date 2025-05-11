import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shipment/config/api.dart';
import 'package:shipment/config/routes.dart';
import 'package:shipment/models/shipment_model.dart';

class ShipmentManagement extends StatefulWidget {
  const ShipmentManagement({super.key});

  @override
  State<ShipmentManagement> createState() => _ShipmentManagementState();
}

class _ShipmentManagementState extends State<ShipmentManagement> {
  final apiServices = ApiServices();
  bool isLoading = true;
  List<ShipmentModel> shipments = [];

  Future<void> loadShipments() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      var result = await apiServices.fetchShipments();
      setState(() {
        shipments = result;
      });
    } catch (e) {
      log('Error: $e', name: 'shipmentManagement');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(
        color: Colors.lightBlue,
      ),
    );
  }

  Widget buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/delivery.jpg',
            width: 300,
          ),
          const Text(
            'No shipments found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Add a new shipment to get started',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildList() {
    return ListView.builder(
      itemCount: shipments.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final shipment = shipments[index];
        return ListTile(
          leading: const Icon(
            Icons.local_shipping,
            color: Colors.blue,
            size: 40,
          ),
          title: Text(
            '${shipment.item} - ${shipment.id}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            '${shipment.expedition} - ${shipment.status}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.shipmentUpdate,
              arguments: shipment,
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    loadShipments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Shipment Management',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: isLoading
          ? buildLoading()
          : shipments.isEmpty
              ? buildEmpty()
              : buildList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.pushNamed(context, Routes.shipmentCreate);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
