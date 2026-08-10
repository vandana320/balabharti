import 'package:bala_bharti_approval_management/core/utils/date_formatter.dart';
import 'package:flutter/material.dart';

import '../../../../core/storage/secure_storage.dart';
import '../../data/datasource/approver_remote_datasource.dart';
import '../../data/models/approve_request.dart';
import '../../data/models/assigned_document_model.dart';
import '../widgets/pdf_preview.dart';
import '../widgets/signature_source.dart';
import '../widgets/signature_widget.dart';
import '../widgets/status_dropdown.dart';
import '../widgets/submit_buttons.dart';
import 'dart:io';

import 'dashboard_screen.dart';

class DocumentDetailsScreen extends StatefulWidget {
  final AssignedDocumentModel document;

  const DocumentDetailsScreen({super.key, required this.document});

  @override
  State<DocumentDetailsScreen> createState() => _DocumentDetailsScreenState();
}

class _DocumentDetailsScreenState extends State<DocumentDetailsScreen> {
  final GlobalKey<SignatureWidgetState> signatureKey =
      GlobalKey<SignatureWidgetState>();
  String? selectedStatus;
  bool isSubmitting = false;
  File? signatureFile;

  String? signatureUrl;
  bool loadingSignature = true;
  SignatureSource selectedSource = SignatureSource.saved;

  late final bool canApprove;

  @override
  void initState() {
    super.initState();

    selectedStatus = widget.document.status;

    canApprove = widget.document.status == "Pending";

    loadSignature();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff1565C0),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Document Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: canApprove
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SubmitButtons(
                  isLoading: isSubmitting,

                  onCancel: () {
                    Navigator.pop(context);
                  },
                  onSubmit: () {
                    showSubmitDialog();
                  },
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff1565C0), Color(0xff42A5F5)],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.picture_as_pdf,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),

                    const SizedBox(width: 18),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.document.documentName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Chip(
                            backgroundColor: Colors.white,
                            label: Text(
                              widget.document.status,
                              style: const TextStyle(
                                color: Color(0xff1565C0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// PDF Preview
              PdfPreviewWidget(
                pdfUrl: widget.document.fileUrl,
                signatureUrl: signatureUrl,
                showSignature: widget.document.status == "Pending",
              ),

              const SizedBox(height: 20),

              buildSectionTitle("Document Information", Icons.description),

              buildInfoCard(),

              const SizedBox(height: 20),

              buildSectionTitle("Approval", Icons.fact_check),

              canApprove ? buildApprovalCard() : Container(),

              const SizedBox(height: 20),

              buildSectionTitle("Signature", Icons.draw),

              loadingSignature
                  ? const Center(child: CircularProgressIndicator())
                  : canApprove
                  ? SignatureWidget(
                      key: signatureKey,
                      signatureUrl: signatureUrl,

                      onImageSelected: (file) {
                        signatureFile = file;
                      },

                      onSourceChanged: (source) {
                        selectedSource = source;
                      },

                      onClear: () {
                        setState(() {
                          signatureFile = null;

                          signatureUrl = null;
                        });
                      },
                    )
                  : Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text(
                              "Digital Signature",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 20),

                            Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: signatureUrl != null
                                  ? Image.network(signatureUrl!)
                                  : const Center(child: Text("No Signature")),
                            ),
                          ],
                        ),
                      ),
                    ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14, top: 5),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blue.shade50,
            child: Icon(icon, color: const Color(0xff1565C0)),
          ),

          const SizedBox(width: 12),

          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildTile(
              Icons.description,
              "Document",
              widget.document.documentName,
            ),
            const Divider(),

            buildTile(Icons.person, "Uploaded By", widget.document.uploadedBy),
            const Divider(),

            buildTile(
              Icons.calendar_today,
              "Assigned Date",
              widget.document.assignedDate,
            ),
            const Divider(),

            buildTile(
              Icons.flag,
              "Approval Step",
              widget.document.approvalStep,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildApprovalCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose Action",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 18),

            StatusDropdown(
              value: selectedStatus,
              onChanged: (value) {
                setState(() {
                  selectedStatus = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blue.shade50,
            child: Icon(icon, size: 18, color: const Color(0xff1565C0)),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade600)),

                const SizedBox(height: 3),

                Text(
                  DateFormatter.format(value),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitApproval() async {
    if (selectedStatus == null || selectedStatus == "Pending") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select Approve or Reject")),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    if (selectedSource == SignatureSource.drawn) {
      signatureFile = await signatureKey.currentState?.exportDrawnSignature();
    }

    final response = await ApproverRemoteDataSource().approveDocument(
      ApproveRequest(
        documentId: widget.document.id,
        status: selectedStatus!,
        signature: signatureFile,
        // null if using saved signature
        approvedBy: await SecureStorage.getEmail() ?? "",
        approvalDateTime: DateTime.now().toUtc().toIso8601String(),
        savedSignatureFilename: selectedSource == SignatureSource.saved
            ? signatureUrl?.split('/').last
            : null,
      ),
    );

    setState(() {
      isSubmitting = false;
    });

    if (!mounted) return;

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));
    }
  }

  void showSubmitDialog() {
    showDialog(
      context: context,

      barrierDismissible: false,

      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: Row(
            children: [
              const Icon(Icons.help_outline, color: Colors.blue),

              const SizedBox(width: 10),

              const Text("Confirmation"),
            ],
          ),

          content: Text(
            "Do you really want to ${selectedStatus?.toLowerCase()} this document?",
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }

  Future<void> loadSignature() async {
    try {
      final adminId = await SecureStorage.getUserId();

      if (adminId == null) return;

      final response = await ApproverRemoteDataSource().getLastSignature(
        adminId,
      );

      if (response.success && response.data != null) {
        setState(() {
          signatureUrl = response.data!.url;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        loadingSignature = false;
      });
    }
  }
}
