import 'package:flutter/material.dart';

import '../../data/models/assigned_document_model.dart';

void showConfirmationDialog(
  BuildContext context,
  AssignedDocumentModel document,

  String action,
) {
  showDialog(
    context: context,

    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

        title: Text("$action Document"),

        content: Text(
          "Are you sure you want to $action\n\n${document.documentName} ?",
        ),

        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },

            child: const Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("$action Successfully")));

              /// TODO
              /// Call Approve/Reject API
            },

            child: Text(action),
          ),
        ],
      );
    },
  );
}
