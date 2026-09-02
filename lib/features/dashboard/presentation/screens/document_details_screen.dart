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

  final TextEditingController rejectionReasonController =
  TextEditingController();
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
    if (isSubmitting) return;

    if (selectedStatus == null || selectedStatus == "Pending") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select Approve or Reject"),
        ),
      );
      return;
    }

    final String status = selectedStatus!.trim();
    final bool isRejected = status == "Rejected";

    // Always take the trimmed value that will actually be sent.
    final String rejectionReason =
    rejectionReasonController.text.trim();

    // Client-side validation.
    if (isRejected && rejectionReason.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Rejection reason must contain at least 5 characters.",
          ),
        ),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      // Keep existing drawn signature functionality.
      if (selectedSource == SignatureSource.drawn) {
        signatureFile =
        await signatureKey.currentState?.exportDrawnSignature();
      }

      final request = ApproveRequest(
        documentId: widget.document.id,
        status: status,
        signature: signatureFile,
        approvedBy: await SecureStorage.getEmail() ?? "",
        approvalDateTime:
        DateTime.now().toUtc().toIso8601String(),

        // Keep existing saved signature functionality.
        savedSignatureFilename:
        selectedSource == SignatureSource.saved
            ? signatureUrl?.split('/').last
            : null,

        // Only send reason for rejection.
        rejectionReason:
        isRejected ? rejectionReason : null,
      );

      debugPrint(
        "APPROVAL REQUEST -> "
            "documentId=${request.documentId}, "
            "status=${request.status}, "
            "rejectionReason=${request.rejectionReason}",
      );

      final response =
      await ApproverRemoteDataSource().approveDocument(request);

      if (!mounted) return;

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const DashboardScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint("submitApproval error: $e");
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Unable to complete the action. Please try again.",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  void showSubmitDialog() {
    if (selectedStatus == null || selectedStatus == "Pending") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select Approve or Reject"),
        ),
      );
      return;
    }

    final bool isApproved = selectedStatus == "Approved";
    final bool isRejected = selectedStatus == "Rejected";

    // Clear old rejection reason when opening an approval dialog.
    if (isApproved) {
      rejectionReasonController.clear();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final String rejectionReason =
            rejectionReasonController.text.trim();

            final bool isReasonValid =
                rejectionReason.length >= 5;

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: 650,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 25,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // =========================
                      // HEADER
                      // =========================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(
                          24,
                          24,
                          24,
                          22,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isApproved
                                ? const [
                              Color(0xff1565C0),
                              Color(0xff42A5F5),
                            ]
                                : const [
                              Color(0xffC62828),
                              Color(0xffEF5350),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 64,
                              width: 64,
                              decoration: BoxDecoration(
                                color:
                                Colors.white.withOpacity(0.18),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                  Colors.white.withOpacity(0.35),
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                isApproved
                                    ? Icons.verified_outlined
                                    : Icons.cancel_outlined,
                                color: Colors.white,
                                size: 34,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              "Confirm Action",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              isApproved
                                  ? "Document approval"
                                  : "Document rejection",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // =========================
                      // CONTENT
                      // =========================
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          22,
                          22,
                          22,
                          10,
                        ),
                        child: Column(
                          children: [
                            Text(
                              isApproved
                                  ? "Are you sure you want to approve this document?"
                                  : "Please provide a reason for rejecting this document.",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff1F2937),
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              isApproved
                                  ? "This document will be marked as approved and the signature will be added to the PDF."
                                  : "The rejection reason is required and must contain at least 5 characters.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: Colors.grey.shade600,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // =========================
                            // DOCUMENT INFO
                            // =========================
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius:
                                BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 44,
                                    width: 44,
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius:
                                      BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.picture_as_pdf,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Document",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                            Colors.grey.shade600,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          widget.document.documentName,
                                          maxLines: 2,
                                          overflow:
                                          TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight:
                                            FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // =========================
                            // STATUS
                            // =========================
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isApproved
                                    ? Colors.green.shade50
                                    : Colors.red.shade50,
                                borderRadius:
                                BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isApproved
                                        ? Icons.check_circle_outline
                                        : Icons.cancel_outlined,
                                    size: 20,
                                    color: isApproved
                                        ? Colors.green.shade700
                                        : Colors.red.shade700,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Selected Status",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    selectedStatus!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isApproved
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // =========================
                            // REJECTION REASON
                            // =========================
                            if (isRejected) ...[
                              const SizedBox(height: 16),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Rejection Reason",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              TextField(
                                controller:
                                rejectionReasonController,
                                minLines: 3,
                                maxLines: 5,
                                maxLength: 500,
                                textCapitalization:
                                TextCapitalization.sentences,
                                keyboardType:
                                TextInputType.multiline,
                                onChanged: (_) {
                                  setDialogState(() {});
                                },
                                decoration: InputDecoration(
                                  hintText:
                                  "Enter reason for rejection",
                                  helperText:
                                  "Minimum 5 characters required",
                                  helperStyle: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                  errorText:
                                  rejectionReason.isEmpty ||
                                      isReasonValid
                                      ? null
                                      : "Reason must be at least 5 characters",
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  counterStyle: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 45,
                                    ),
                                    child: Icon(
                                      Icons.comment_outlined,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color:
                                      Colors.grey.shade300,
                                    ),
                                  ),
                                  enabledBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color:
                                      Colors.grey.shade300,
                                    ),
                                  ),
                                  focusedBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color:
                                      Color(0xffC62828),
                                      width: 1.5,
                                    ),
                                  ),
                                  errorBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // =========================
                      // BUTTONS
                      // =========================
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          22,
                          12,
                          22,
                          22,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: OutlinedButton(
                                  onPressed: isSubmitting
                                      ? null
                                      : () {
                                    Navigator.of(
                                      dialogContext,
                                    ).pop();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor:
                                    Colors.grey.shade700,
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1.2,
                                    ),
                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  // IMPORTANT:
                                  // Reject remains disabled until
                                  // minimum 5 characters are entered.
                                  onPressed: isSubmitting ||
                                      (isRejected &&
                                          !isReasonValid)
                                      ? null
                                      : () {
                                    Navigator.of(
                                      dialogContext,
                                    ).pop();

                                    submitApproval();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isApproved
                                        ? const Color(0xff1565C0)
                                        : const Color(0xffC62828),
                                    disabledBackgroundColor:
                                    Colors.grey.shade300,
                                    foregroundColor: Colors.white,
                                    disabledForegroundColor:
                                    Colors.grey.shade600,
                                    elevation: 0,
                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        isApproved
                                            ? Icons.check
                                            : Icons.close,
                                        size: 19,
                                      ),
                                      const SizedBox(width: 7),
                                      Text(
                                        isApproved
                                            ? "Approve"
                                            : "Reject",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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

  @override
  void dispose() {
    rejectionReasonController.dispose();
    super.dispose();
  }
}
