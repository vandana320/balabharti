import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../data/models/assigned_document_model.dart';
import '../screens/document_details_screen.dart';
import 'status_chip.dart';

class DashboardCard extends StatelessWidget {
  final AssignedDocumentModel document;
  final Future<void> Function() onRefresh;

  const DashboardCard({
    super.key,
    required this.document,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => openDocumentDetailScreen(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.12),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              /// Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf_rounded,
                      color: Colors.red,
                      size: 38,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document.documentName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 15,
                              color: Colors.grey.shade600,
                            ),

                            const SizedBox(width: 5),

                            Expanded(
                              child: Text(
                                document.uploadedBy,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: Color(0xff1565C0),
                      ),
                      onPressed: () {
                        openDocumentDetailScreen(context);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Divider(color: Colors.grey.shade300),

              const SizedBox(height: 10),

              buildInfoRow(
                Icons.person_outline,
                "Uploaded By",
                document.uploadedBy,
              ),

              const SizedBox(height: 14),

              buildInfoRow(
                Icons.calendar_today_outlined,
                "Assigned Date",
                DateFormatter.format(document.assignedDate),
              ),

              const SizedBox(height: 14),

              buildInfoRow(
                Icons.flag_outlined,
                "Approval Step",
                document.approvalStep,
              ),

              const SizedBox(height: 18),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Text(
                      "Current Status",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),

                    const Spacer(),

                    StatusChip(document: document),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, color: const Color(0xff1565C0), size: 17),
        ),

        const SizedBox(width: 12),

        SizedBox(
          width: 110,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),

        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> openDocumentDetailScreen(BuildContext context) async {
    final refresh = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => DocumentDetailsScreen(document: document),
      ),
    );

    if (refresh == true) {
      await onRefresh();
    }
  }
}
