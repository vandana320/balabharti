class AssignedDocumentModel {
  final int id;

  final String originalFileName;
  final String storedFileName;
  final String? signedPdfName;

  final String uploadedByEmail;

  final String assignedDateTime;

  final String status;

  final int approvalOrder;

  final int totalApprovers;

  final int completedApprovals;

  final String fileUrl;

  final List<dynamic> approvalBoxConfig;

  AssignedDocumentModel({
    required this.id,
    required this.originalFileName,
    required this.storedFileName,
    this.signedPdfName,
    required this.uploadedByEmail,
    required this.assignedDateTime,
    required this.status,
    required this.approvalOrder,
    required this.totalApprovers,
    required this.completedApprovals,
    required this.fileUrl,
    required this.approvalBoxConfig,
  });

  factory AssignedDocumentModel.fromJson(Map<String, dynamic> json) {
    return AssignedDocumentModel(
      id: json["id"],
      originalFileName: json["original_file_name"] ?? "",
      storedFileName: json["stored_file_name"] ?? "",
      signedPdfName: json["signed_pdf_name"],
      uploadedByEmail: json["uploaded_by_email"] ?? "",
      assignedDateTime: json["assigned_datetime"] ?? "",
      status: json["status"] ?? "",
      approvalOrder: json["approval_order"] ?? 0,
      totalApprovers: json["total_approvers"] ?? 0,
      completedApprovals: json["completed_approvals"] ?? 0,
      fileUrl: json["file_url"] ?? "",
      approvalBoxConfig: json["approval_box_config"] ?? [],
    );
  }

  // ==========================
  // Compatibility Getters
  // ==========================

  String get documentName => originalFileName;

  String get uploadedBy => uploadedByEmail;

  String get assignedDate => assignedDateTime;

  String get approvalStep => "$approvalOrder / $totalApprovers";
}
