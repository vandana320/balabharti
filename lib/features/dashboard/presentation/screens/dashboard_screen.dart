import 'package:flutter/material.dart';

import '../../../../core/storage/secure_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../authentication/presentation/screens/login_screen.dart';
import '../../data/datasource/approver_remote_datasource.dart';
import '../../data/models/assigned_document_model.dart';
import '../../data/models/validate_approver_request.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/search_bar.dart';
import '../widgets/filter_chip.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController searchController = TextEditingController();

  String selectedFilter = "All";

  bool isLoading = true;

  List<AssignedDocumentModel> documents = [];

  @override
  void initState() {
    super.initState();
    debugPrint("DashboardScreen initState");
    loadDocuments();
  }

  @override
  Widget build(BuildContext context) {
    List<AssignedDocumentModel> filteredList = documents.where((document) {
      final search = document.documentName.toLowerCase().contains(
        searchController.text.toLowerCase(),
      );

      final filter = selectedFilter == "All"
          ? true
          : document.status == selectedFilter;
      return search && filter;
    }).toList();

    final pendingDocuments = documents
        .where((document) => document.status == "Pending")
        .length;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: Column(
          children: [
            DashboardHeader(
              userName: "Shantanu Rao",
              totalDocuments: documents.length,
              pendingDocuments: pendingDocuments,
              onLogout: logout,
            ),

            DashboardSearchBar(
              controller: searchController,

              onChanged: (_) {
                setState(() {});
              },
            ),

            DashboardFilterChips(
              selected: selectedFilter,

              onSelected: (value) {
                setState(() {
                  selectedFilter = value;
                });
              },
            ),

            const SizedBox(height: 10),

            Expanded(
              child: RefreshIndicator(
                onRefresh: loadDocuments,

                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredList.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 250),

                          Center(
                            child: Text(
                              "No Documents Found",

                              style: TextStyle(
                                fontSize: 18,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),

                        itemCount: filteredList.length,

                        separatorBuilder: (_, __) => const SizedBox(height: 15),

                        itemBuilder: (context, index) {
                          return DashboardCard(
                            document: filteredList[index],
                            onRefresh: loadDocuments,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          loadDocuments();
        },

        icon: const Icon(Icons.refresh),

        label: const Text("Refresh"),
      ),
    );
  }

  @override
  void dispose() {
    debugPrint("DashboardScreen dispose");
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadDocuments() async {
    debugPrint("===== loadDocuments() called =====");

    setState(() {
      isLoading = true;
    });

    try {
      final email = await SecureStorage.getEmail();

      debugPrint("Stored Email: $email");

      if (email == null || email.isEmpty) {
        throw Exception("User email not found.");
      }

      debugPrint("Calling validateApprover...");

      /// Step 1 - Validate Approver
      final validateResponse = await ApproverRemoteDataSource()
          .validateApprover(ValidateApproverRequest(email: email));

      if (!validateResponse.success || validateResponse.data == null) {
        throw Exception(validateResponse.message);
      }

      final int adminId = validateResponse.data!.id;

      /// Step 2 - Fetch Assigned Documents
      final documentResponse = await ApproverRemoteDataSource()
          .getAssignedDocuments(adminId);

      if (!documentResponse.success) {
        throw Exception("Unable to fetch documents.");
      }

      debugPrint("===== loadDocuments() called =====");
      debugPrint("Total Documents: ${documentResponse.data.length}");

      setState(() {
        documents = documentResponse.data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> logout() async {
    final shouldLogout = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 45,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 25),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                // Logout Icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.primary,
                    size: 34,
                  ),
                ),

                const SizedBox(height: 20),

                // Title
                const Text(
                  "Logout from account?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1F2937),
                  ),
                ),

                const SizedBox(height: 10),

                // Description
                Text(
                  "You will be signed out from the Balabharti Approval Management System.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 28),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(sheetContext, true);
                    },
                    icon: const Icon(
                      Icons.logout_rounded,
                      size: 21,
                    ),
                    label: const Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1565C0),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext, false);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xff1565C0),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldLogout != true) {
      return;
    }

    // Clear login/session data
    await SecureStorage.clear();

    if (!mounted) return;

    // Remove Dashboard and all previous authenticated routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
}
