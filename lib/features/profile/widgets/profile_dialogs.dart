import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(
  BuildContext context,
  String title,
  String body,
  String action, {
  bool danger = false,
}) => showDialog<bool>(
  context: context,
  builder: (_) => AlertDialog(
    title: Text(title),
    content: Text(body),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context, true),
        child: Text(
          action,
          style: TextStyle(
            color: danger ? Colors.red : const Color(0xFF3E2723),
          ),
        ),
      ),
    ],
  ),
);

class ProfileSaveAction extends StatelessWidget {
  final bool saving;
  final VoidCallback onSave;

  const ProfileSaveAction({
    super.key,
    required this.saving,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    if (saving) {
      return const Padding(
        padding: EdgeInsets.all(14),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        ),
      );
    }
    return IconButton(
      icon: const Icon(Icons.check, color: Colors.white),
      onPressed: onSave,
    );
  }
}
