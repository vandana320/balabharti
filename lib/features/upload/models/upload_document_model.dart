import 'dart:io';

import 'approval_box_config.dart';

class UploadDocumentModel {
  final File file;

  final List<String> approverEmails;

  final List<ApprovalBoxConfig> approvalBoxConfig;

  UploadDocumentModel({
    required this.file,
    required this.approverEmails,
    required this.approvalBoxConfig,
  });
}
