import 'package:flutter/material.dart';

class DashboardFilterChips extends StatelessWidget {
  final String selected;

  final Function(String) onSelected;

  const DashboardFilterChips({
    super.key,

    required this.selected,

    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = ["All", "Pending", "Approved", "Rejected"];

    return SizedBox(
      height: 50,

      child: ListView.builder(
        scrollDirection: Axis.horizontal,

        padding: const EdgeInsets.symmetric(horizontal: 16),

        itemCount: items.length,

        itemBuilder: (_, index) {
          final value = items[index];

          final isSelected = selected == value;

          return Padding(
            padding: const EdgeInsets.only(right: 10),

            child: ChoiceChip(
              label: Text(value),

              selected: isSelected,

              onSelected: (_) {
                onSelected(value);
              },
            ),
          );
        },
      ),
    );
  }
}
