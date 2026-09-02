import 'dart:io';

class ApproveRequest {
  final int documentId;
  final String status;
  final File? signature;
  final String approvedBy;
  final String approvalDateTime;
  final String? savedSignatureFilename;
  final String? rejectionReason;

  ApproveRequest({
    required this.documentId,
    required this.status,
    this.signature,
    required this.approvedBy,
    required this.approvalDateTime,
    this.savedSignatureFilename,
    this.rejectionReason,
  });
}