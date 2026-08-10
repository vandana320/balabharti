class ApprovalBoxConfig {
  final String type;

  final double x;
  final double y;

  final double width;
  final double height;

  final List<String> fields;

  final double? xRatio;
  final double? yRatio;

  final double? widthRatio;
  final double? heightRatio;

  ApprovalBoxConfig({
    required this.type,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.fields,
    this.xRatio,
    this.yRatio,
    this.widthRatio,
    this.heightRatio,
  });

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "x": x,
      "y": y,
      "width": width,
      "height": height,
      "fields": fields,
      "xRatio": xRatio,
      "yRatio": yRatio,
      "widthRatio": widthRatio,
      "heightRatio": heightRatio,
    };
  }

  factory ApprovalBoxConfig.fromJson(Map<String, dynamic> json) {
    return ApprovalBoxConfig(
      type: json["type"] ?? "",
      x: (json["x"] ?? 0).toDouble(),
      y: (json["y"] ?? 0).toDouble(),
      width: (json["width"] ?? 0).toDouble(),
      height: (json["height"] ?? 0).toDouble(),
      fields: List<String>.from(json["fields"] ?? []),
      xRatio: json["xRatio"]?.toDouble(),
      yRatio: json["yRatio"]?.toDouble(),
      widthRatio: json["widthRatio"]?.toDouble(),
      heightRatio: json["heightRatio"]?.toDouble(),
    );
  }
}
