class MyDocumentModel {
  final int id;

  final String originalFileName;

  final String status;

  final String? signedPdfName;

  final String assignedTo;

  final String assignedDate;

  MyDocumentModel({
    required this.id,

    required this.originalFileName,

    required this.status,

    this.signedPdfName,

    required this.assignedTo,

    required this.assignedDate,
  });

  factory MyDocumentModel.fromJson(Map<String, dynamic> json) {
    return MyDocumentModel(
      id: json["id"],

      originalFileName: json["original_file_name"] ?? "",

      status: json["status"] ?? "",

      signedPdfName: json["signed_pdf_name"],

      assignedTo: json["assigned_to"] ?? "",

      assignedDate: json["assigned_datetime"] ?? "",
    );
  }
}
