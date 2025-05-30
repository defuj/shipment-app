// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shipment/components/button.dart';
import 'package:shipment/config/api.dart';
import 'package:shipment/models/shipment_model.dart';

class UpdateShipment extends StatefulWidget {
  final ShipmentModel shipment;
  const UpdateShipment({super.key, required this.shipment});

  @override
  State<UpdateShipment> createState() => _UpdateShipmentState();
}

class _UpdateShipmentState extends State<UpdateShipment> {
  final historyDescriptionController = TextEditingController();
  final apiServices = ApiServices();
  bool isLoading = false;
  List<String> status = [
    'IN PROCESS',
    'ON DELIVERY',
    'ARRIVED',
    'CANCELED',
    'FINISHED'
  ];
  String? selectedStatus;

  void updateStatus() async {
    if (selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a status'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiServices.updateShipment(
        id: widget.shipment.id,
        status: selectedStatus!,
      );
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Shipment status updated successfully'),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update shipment status'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update shipment status'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void addHistory() async {
    if (historyDescriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a history description'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var result = await apiServices.addHistory(
        id: widget.shipment.id,
        description: historyDescriptionController.text,
      );
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('History added successfully'),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add history'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add history'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteShipment() async {
    // show confirm dialog
    setState(() {
      isLoading = true;
    });
    try {
      var result = await apiServices.deleteShipments(widget.shipment.id);
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Shipment deleted successfully'),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete shipment'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete shipment'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
            'No Shipments History Found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Update your shipment history',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> updateStatusForm() {
    return [
      TextField(
        decoration: InputDecoration(
          labelText: 'Item Description',
          border: OutlineInputBorder(),
        ),
        controller: TextEditingController(
          text: widget.shipment.item,
        ),
        enabled: false,
      ),
      const SizedBox(height: 16),
      TextField(
        decoration: InputDecoration(
          labelText: 'Expedition',
          border: OutlineInputBorder(),
        ),
        controller: TextEditingController(
          text: widget.shipment.expedition,
        ),
        enabled: false,
      ),
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Status',
          border: OutlineInputBorder(),
        ),
        items: status.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        value: widget.shipment.status,
        onChanged: (String? newValue) {
          setState(() {
            selectedStatus = newValue;
          });
        },
      ),
      const SizedBox(height: 16),
      buildButton(
        title: 'Update Status',
        onPressed: () {
          updateStatus();
        },
      ),
      const SizedBox(height: 16),
    ];
  }

  List<Widget> addHistoryForm() {
    return [
      TextField(
        decoration: InputDecoration(
          labelText: 'Description',
          border: OutlineInputBorder(),
        ),
        controller: historyDescriptionController,
      ),
      const SizedBox(height: 16),
      buildButton(
        title: 'Add History',
        onPressed: () {
          addHistory();
        },
      ),
      const SizedBox(height: 16),
    ];
  }

  @override
  void initState() {
    setState(() {
      selectedStatus = widget.shipment.status;
    });
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
          widget.shipment.id,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteShipment();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ...updateStatusForm(),
            ...addHistoryForm(),
          ],
        ),
      ),
    );
  }
}
