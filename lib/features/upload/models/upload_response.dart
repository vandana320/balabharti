class UploadResponse {
  final bool success;
  final String message;
  final int totalFiles;
  final List<UploadedFile> files;

  UploadResponse({
    required this.success,
    required this.message,
    required this.totalFiles,
    required this.files,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      totalFiles: json["totalFiles"] ?? 0,
      files: (json["files"] as List<dynamic>? ?? [])
          .map((e) => UploadedFile.fromJson(e))
          .toList(),
    );
  }
}

class UploadedFile {
  final String originalName;
  final String fileName;
  final String fileType;
  final int size;
  final String path;

  UploadedFile({
    required this.originalName,
    required this.fileName,
    required this.fileType,
    required this.size,
    required this.path,
  });

  factory UploadedFile.fromJson(Map<String, dynamic> json) {
    return UploadedFile(
      originalName: json["originalName"] ?? "",
      fileName: json["fileName"] ?? "",
      fileType: json["fileType"] ?? "",
      size: json["size"] ?? 0,
      path: json["path"] ?? "",
    );
  }
}
