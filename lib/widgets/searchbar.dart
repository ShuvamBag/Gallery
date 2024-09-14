import 'dart:ui';
import 'package:flutter/material.dart';

class Searchbar extends StatelessWidget {
  final TextEditingController controller;

  const Searchbar({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: Colors.black87.withOpacity(0.3), // Dark grey background with opacity for glass effect
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(
            width: 1.5,
            color: Colors.black.withOpacity(0.2),
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.2), // Subtle shadow for depth
          //     offset: Offset(0, 4),
          //     blurRadius: 10,
          //   ),
          // ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Search images...',
                  hintStyle: TextStyle(
                    color: Colors.white60, // Light grey hint text color
                  ),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  color: Colors.white, // White input text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
