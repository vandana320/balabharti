import 'package:flutter/material.dart';

class SubmitButtons extends StatelessWidget {
  final VoidCallback onSubmit;
  final VoidCallback onCancel;
  final bool isLoading;

  const SubmitButtons({
    super.key,

    required this.onSubmit,

    required this.onCancel,

    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),

            onPressed: isLoading ? null : onCancel,

            child: const Text("Cancel"),
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),

            onPressed: isLoading ? null : onSubmit,

            child: isLoading
                ? const SizedBox(
                    width: 20,

                    height: 20,

                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text("Submit"),
          ),
        ),
      ],
    );
  }
}
