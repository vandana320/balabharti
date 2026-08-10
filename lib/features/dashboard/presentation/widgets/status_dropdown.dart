import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatusDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const StatusDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currentDate = DateFormat("dd MMM yyyy").format(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Approval Information",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),

        const SizedBox(height: 20),

        TextFormField(
          initialValue: currentDate,
          readOnly: true,
          decoration: const InputDecoration(
            labelText: "Approval Date",
            prefixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 20),

        DropdownButtonFormField<String>(
          value: value,
          decoration: const InputDecoration(
            labelText: "Status",
            prefixIcon: Icon(Icons.flag),
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: "Pending", child: Text("Pending")),

            DropdownMenuItem(value: "Approved", child: Text("Approved")),

            DropdownMenuItem(value: "Rejected", child: Text("Rejected")),
          ],
          onChanged: onChanged,
          validator: (value) {
            if (value == null) {
              return "Select Status";
            }

            if (value == "Pending") {
              return "Please choose Approve or Reject";
            }

            return null;
          },
        ),
      ],
    );
  }
}
