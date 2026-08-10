import 'package:flutter/material.dart';

import '../../../../core/storage/secure_storage.dart';
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

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: Column(
          children: [
            DashboardHeader(
              userName: "Shantanu Rao",

              totalDocuments: filteredList.length,
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
}
