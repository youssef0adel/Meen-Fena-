import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PlayerNameCard extends StatelessWidget {
  final int playerNumber;
  final TextEditingController controller;

  const PlayerNameCard({
    super.key,
    required this.playerNumber,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.accentRed.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.accentRed,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '$playerNumber',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'اسم اللاعب $playerNumber',
                hintStyle: TextStyle(color: AppTheme.textSecondary.withOpacity(0.5)),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'مطلوب';
                }
                return null;
              },
            ),
          ),
          Icon(
            Icons.person,
            color: AppTheme.textSecondary.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}