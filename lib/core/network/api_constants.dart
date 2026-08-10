class ApiConstants {
  ApiConstants._();

  static const baseUrl = "https://document-assess-system.onrender.com/api";

  /*
  -------------------------
  Authentication
  -------------------------
  */

  static const login = "/auth/login";

  static const register = "/auth/register";

  static const changePassword = "/auth/change-password";

  /*
-----------------------
Approver
-----------------------
*/

  static const validateApprover = "/approver/validate";

  static const assignedDocuments = "/admin/documents";

  static const signature = "/admin/signature";

  static const approveDocument = "/admin/document/approve";

  /*
-------------------------
Documents
-------------------------
*/

  static const myDocuments = "/document/my-documents";

  static const downloadPdf = "/document/download";

  static const uploadDocument = "/upload";
}
