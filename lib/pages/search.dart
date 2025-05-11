import 'package:flutter/material.dart';
import 'package:shipment/components/button.dart';
import 'package:shipment/config/routes.dart';
import 'package:shipment/models/shipment_model.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  ShipmentModel? shipment;
  TextEditingController trackingNumberController = TextEditingController();
  bool isLoading = false;
  String trackingNumber = '';

  void searchShipment() {
    if (trackingNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a tracking number'),
        ),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      Routes.shipment,
      arguments: trackingNumber,
    );
  }

  Widget buildSearchForm() {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      child: TextFormField(
        controller: trackingNumberController,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        maxLength: 10,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        textCapitalization: TextCapitalization.characters,
        decoration: InputDecoration(
          counterText: '',
          hintText: 'Enter your tracking number',
          suffixIcon: trackingNumber.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      trackingNumberController.clear();
                      trackingNumber = '';
                    });
                  },
                )
              : null,
          hintStyle: const TextStyle(
            fontSize: 16,
            color: Colors.black38,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 0.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 0.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 0.0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    trackingNumberController.addListener(() {
      setState(() {
        trackingNumber = trackingNumberController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/tracking.png',
              width: 300,
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Shipment Tracker',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Track Your Shipment',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            // input field for tracking number
            buildSearchForm(),
            const SizedBox(height: 20),
            buildButton(
              title: 'Search',
              color: Colors.blue,
              onPressed: () {
                searchShipment();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.pushNamed(
            context,
            Routes.shipmentManagement,
          );
        },
        tooltip: 'Shipment Management',
        child: const Icon(
          Icons.local_shipping,
          color: Colors.white,
        ),
      ),
    );
  }
}
