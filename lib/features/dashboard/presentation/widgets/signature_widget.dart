import 'dart:io';

import 'package:bala_bharti_approval_management/features/dashboard/presentation/widgets/signature_source.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

class SignatureWidget extends StatefulWidget {
  final Function(File?)? onImageSelected;
  final VoidCallback? onClear;
  final String? signatureUrl;
  final Function(SignatureSource)? onSourceChanged;

  const SignatureWidget({
    super.key,
    this.onImageSelected,
    this.signatureUrl,
    this.onClear,
    this.onSourceChanged,
  });

  @override
  State<SignatureWidget> createState() => SignatureWidgetState();
}

class SignatureWidgetState extends State<SignatureWidget> {
  final SignatureController controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
  );

  String? originalSignatureUrl;

  String? currentSignatureUrl;

  final ImagePicker picker = ImagePicker();
  File? selectedImage;
  SignatureSource selectedSource = SignatureSource.saved;

  @override
  void initState() {
    super.initState();

    originalSignatureUrl = widget.signatureUrl;
    currentSignatureUrl = widget.signatureUrl;
  }

  Future<void> pickSignature() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      selectedImage = File(image.path);
    });

    widget.onImageSelected?.call(selectedImage);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,

                  backgroundColor: Colors.blue.shade50,

                  child: const Icon(Icons.draw, color: Color(0xff1565C0)),
                ),

                const SizedBox(width: 12),

                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Digital Signature",

                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    Text(
                      "Choose one signature method",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: SegmentedButton<SignatureSource>(
                segments: const [
                  ButtonSegment(
                    value: SignatureSource.saved,
                    icon: Icon(Icons.bookmark),
                    label: Text("Saved"),
                  ),

                  ButtonSegment(
                    value: SignatureSource.uploaded,
                    icon: Icon(Icons.upload),
                    label: Text("Upload"),
                  ),

                  ButtonSegment(
                    value: SignatureSource.drawn,
                    icon: Icon(Icons.draw),
                    label: Text("Draw"),
                  ),
                ],

                selected: {selectedSource},

                onSelectionChanged: (value) {
                  setState(() {
                    selectedSource = value.first;

                    if (selectedSource == SignatureSource.saved) {
                      currentSignatureUrl = originalSignatureUrl;
                    }

                    if (selectedSource == SignatureSource.drawn) {
                      controller.clear();
                    }
                  });

                  widget.onSourceChanged?.call(selectedSource);
                },
              ),
            ),

            const SizedBox(height: 15),

            AnimatedContainer(
              duration: const Duration(milliseconds: 300),

              height: 240,

              width: double.infinity,

              decoration: BoxDecoration(
                color: Colors.grey.shade50,

                borderRadius: BorderRadius.circular(18),

                border: Border.all(color: Colors.blue.shade100),
              ),

              child: Builder(
                builder: (_) {
                  switch (selectedSource) {
                    case SignatureSource.saved:
                      if (currentSignatureUrl != null &&
                          currentSignatureUrl!.isNotEmpty) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(18),

                          child: Image.network(
                            currentSignatureUrl!,

                            fit: BoxFit.contain,
                          ),
                        );
                      }

                      return buildEmptyState(
                        Icons.bookmark_border,
                        "No Saved Signature",
                      );

                    case SignatureSource.uploaded:
                      if (selectedImage != null) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(18),

                          child: Image.file(
                            selectedImage!,
                            fit: BoxFit.contain,
                          ),
                        );
                      }

                      return buildEmptyState(
                        Icons.upload_file,
                        "Upload your Signature",
                      );

                    case SignatureSource.drawn:
                      return Signature(
                        controller: controller,
                        backgroundColor: Colors.white,
                      );
                  }
                },
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                if (selectedSource == SignatureSource.uploaded)
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.upload),

                      label: const Text("Choose Image"),

                      onPressed: pickSignature,
                    ),
                  ),

                if (selectedSource == SignatureSource.uploaded)
                  const SizedBox(width: 12),

                if (selectedSource != SignatureSource.saved)
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.delete_outline),

                      label: const Text("Clear"),

                      onPressed: () {
                        controller.clear();

                        setState(() {
                          selectedImage = null;
                        });

                        widget.onImageSelected?.call(null);

                        widget.onClear?.call();
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<File?> exportDrawnSignature() async {
    if (controller.isEmpty) {
      return null;
    }

    final bytes = await controller.toPngBytes();

    if (bytes == null) {
      return null;
    }

    final directory = await getTemporaryDirectory();

    final file = File(
      "${directory.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png",
    );

    await file.writeAsBytes(bytes);

    return file;
  }

  Widget buildEmptyState(IconData icon, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Icon(icon, size: 70, color: Colors.grey.shade400),

        const SizedBox(height: 15),

        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
