import 'package:flutter/material.dart';

class FilterCard extends StatefulWidget {
  const FilterCard({super.key});

  @override
  State<FilterCard> createState() => _FilterCardState();
}

class _FilterCardState extends State<FilterCard> {
  final List<String> _labels = [
    'All (7)',
    'Pending (7)',
    'Submitted (7)',
    'Overdue (7)',
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Container(
      padding: const EdgeInsets.all(30),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_labels.length, (index) {
            final selected = index == _selectedIndex;
            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: ChoiceChip(
                label: Text(
                  _labels[index],
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                selected: selected,
                onSelected: (v) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                backgroundColor: Colors.grey.shade200,
                selectedColor: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 8.0,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
