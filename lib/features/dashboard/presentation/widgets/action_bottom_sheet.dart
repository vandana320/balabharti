import 'package:flutter/material.dart';

import '../../data/models/assigned_document_model.dart';
import '../screens/document_details_screen.dart';
import 'confirmation_dialog.dart';

class ActionBottomSheet extends StatelessWidget {
  final AssignedDocumentModel document;

  const ActionBottomSheet({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              height: 5,

              width: 60,

              decoration: BoxDecoration(
                color: Colors.grey.shade400,

                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Select Action",

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,

                child: Icon(Icons.check, color: Colors.white),
              ),

              title: const Text("Approve"),

              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DocumentDetailsScreen(
                      document: document,
                    ),
                  ),
                );
              },
            ),

            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.red,

                child: Icon(Icons.close, color: Colors.white),
              ),

              title: const Text("Reject"),

              onTap: () {
                Navigator.pop(context);

                showConfirmationDialog(context, document, "Reject");
              },
            ),
          ],
        ),
      ),
    );
  }
}
