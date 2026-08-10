import 'package:flutter/material.dart';

import '../../../../core/utils/validators.dart';

import '../../data/datasource/auth_remote_datasource.dart';
import '../../data/models/register_request.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  bool hidePassword = true;

  bool hideConfirm = true;

  bool isAdmin = false;

  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    final response = await AuthRemoteDataSource().register(
      RegisterRequest(
        email: emailController.text.trim(),
        pin: passwordController.text.trim(),
        isAdmin: isAdmin,
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
                    Icons.person_add_alt_1,
                    size: 55,
                    color: Color(0xff1565C0),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Create Account",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                "Register to access the approval portal",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 35),

              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
                decoration: InputDecoration(
                  labelText: "Email Address",
                  hintText: "Enter your email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: passwordController,
                obscureText: hidePassword,
                validator: Validators.password,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: confirmPasswordController,
                obscureText: hideConfirm,
                validator: (value) =>
                    Validators.confirmPassword(value, passwordController.text),
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      hideConfirm ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        hideConfirm = !hideConfirm;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              CheckboxListTile(
                value: isAdmin,

                activeColor: const Color(0xff1565C0),

                contentPadding: EdgeInsets.zero,

                title: const Text(
                  "Register as Admin",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                onChanged: (value) {
                  setState(() {
                    isAdmin = value ?? false;
                  });
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  icon: loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.app_registration),

                  label: const Text(
                    "REGISTER",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),

                  onPressed: loading ? null : register,
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
                icon: const Icon(Icons.login),

                label: const Text("Already have an account? Login"),

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
