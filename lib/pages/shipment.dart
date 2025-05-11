// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shipment/config/api.dart';
import 'package:shipment/models/shipment_model.dart';
import 'package:shipment/utils/helper.dart';

class Shipments extends StatefulWidget {
  final String trackingNumber;
  const Shipments({super.key, required this.trackingNumber});

  @override
  State<Shipments> createState() => _ShipmentsState();
}

class _ShipmentsState extends State<Shipments> {
  final apiService = ApiServices();
  ShipmentModel? shipment;
  bool loading = true;

  Future<void> searchShipment() async {
    try {
      var result =
          await apiService.fetchShipment(widget.trackingNumber.toString());
      setState(() async {
        shipment = result;
      });
    } catch (e) {
      log(e.toString(), name: 'Shipment Search Error');
    } finally {
      setState(() {
        loading = false;
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

  Widget handleShipments() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(8.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${shipment?.item}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'STATUS: ${shipment?.status ?? 'Unknown'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    shipment?.expedition ?? 'Unknown Expedition',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        'Tracking Number: ${shipment?.id ?? 'Unknown'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      IconButton(
                        onPressed: () => copyText(
                          context: context,
                          text: shipment?.id ?? '',
                        ),
                        icon: const Icon(Icons.copy, size: 14),
                      )
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey[200],
                  height: 1,
                ),
                ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  reverse: true,
                  itemCount: shipment?.history?.length ?? 0,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final history = shipment?.history?[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 40,
                            child: Text(
                              formatDate(
                                date:
                                    history?.time ?? DateTime.now().toString(),
                                format: 'dd MMM hh:mm',
                              ),
                              style: TextStyle(
                                fontSize: 11,
                                color: index == 0
                                    ? Colors.black
                                    : Colors.grey[400],
                                fontWeight: index == 0
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                              ),
                              textAlign: TextAlign.end,
                              softWrap: true,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  history?.description ?? 'Unknown',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: index == 0
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    color: index == 0
                                        ? Colors.black
                                        : Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (history?.image != null &&
                                    isValidUrl(history?.image ?? '')) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Proof of delivery:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Image.network(
                                    history?.image ?? '',
                                    width: 200,
                                    fit: BoxFit.contain,
                                    alignment: Alignment.centerLeft,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/not_found.jpg',
            width: 300,
          ),
          const SizedBox(height: 20),
          const Text(
            'Shipment not found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.trackingNumber.isNotEmpty) {
        searchShipment();
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a tracking number'),
          ),
        );
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Shipment Information',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: shipment == null ? Colors.white : Colors.grey[100],
      body: loading
          ? buildLoading()
          : shipment != null
              ? handleShipments()
              : buildEmpty(),
    );
  }
}
