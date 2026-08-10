import 'package:flutter/material.dart';

import '../../data/models/assigned_document_model.dart';
import '../screens/document_details_screen.dart';
import 'action_bottom_sheet.dart';

class StatusChip extends StatelessWidget {
  final AssignedDocumentModel document;

  const StatusChip({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.orange;

    if (document.status == "Approved") {
      color = Colors.green;
    }

    if (document.status == "Rejected") {
      color = Colors.red;
    }

    return InkWell(
      onTap: () async {
        if (document.status != "Pending") return;

        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => DocumentDetailsScreen(document: document),
          ),
        );

        if (result == true) {
          Navigator.pop(context, true);
        }
      },

      child: Chip(
        backgroundColor: color,

        label: Text(
          document.status,

          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
