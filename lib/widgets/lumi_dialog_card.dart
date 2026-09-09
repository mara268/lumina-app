import 'package:flutter/material.dart';

class LumiDialogCard extends StatelessWidget {
  final String text;

  const LumiDialogCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1EB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFD1C1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFFF8A65),
            radius: 18,
            child: Icon(Icons.auto_awesome, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '“$text”',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.4,
                color: const Color(0xFF2D3142),
              ),
            ),
          ),
        ],
      ),
    );
  }
}