import 'package:flutter/material.dart';

import '../../../../core/storage/secure_storage.dart';
import '../../../../core/utils/validators.dart';
import '../../data/datasource/auth_remote_datasource.dart';
import '../../data/models/change_password_request.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool currentVisible = false;
  bool newVisible = false;
  bool confirmVisible = false;

  bool loading = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final email = await SecureStorage.getEmail();

    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User session expired. Please login again."),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    final response = await AuthRemoteDataSource().changePassword(
      ChangePasswordRequest(
        email: email,
        currentPassword: currentPasswordController.text.trim(),
        newPassword: newPasswordController.text.trim(),
      ),
    );

    setState(() {
      loading = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(response.message)));

    if (response.success) {
      Navigator.pop(context);
    }
  }

  Widget buildPasswordField({
    required TextEditingController controller,
    required String title,
    required bool visible,
    required VoidCallback onPressed,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !visible,
      validator: validator,
      decoration: InputDecoration(
        labelText: title,
        hintText: title,
        filled: true,
        fillColor: Colors.grey.shade50,
        prefixIcon: const Icon(Icons.lock_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        suffixIcon: IconButton(
          icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
          onPressed: onPressed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.lock_reset,
                    size: 55,
                    color: Color(0xff1565C0),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Change Password",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                "Update your account password",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 35),

              buildPasswordField(
                controller: currentPasswordController,
                title: "Current Password",
                visible: currentVisible,
                validator: Validators.password,
                onPressed: () {
                  setState(() {
                    currentVisible = !currentVisible;
                  });
                },
              ),

              const SizedBox(height: 20),

              buildPasswordField(
                controller: newPasswordController,
                title: "New Password",
                visible: newVisible,
                validator: Validators.password,
                onPressed: () {
                  setState(() {
                    newVisible = !newVisible;
                  });
                },
              ),

              const SizedBox(height: 20),

              buildPasswordField(
                controller: confirmPasswordController,
                title: "Confirm Password",
                visible: confirmVisible,
                validator: (value) => Validators.confirmPassword(
                  value,
                  newPasswordController.text,
                ),
                onPressed: () {
                  setState(() {
                    confirmVisible = !confirmVisible;
                  });
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: loading ? null : changePassword,
                  icon: loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: const Text(
                    "UPDATE PASSWORD",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "OR",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 20),

              TextButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text("Back", style: TextStyle(fontSize: 16)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
