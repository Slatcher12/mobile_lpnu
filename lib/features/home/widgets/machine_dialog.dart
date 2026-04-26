import 'package:flutter/material.dart';

import '../../../core/models/coffee_machine.dart';
import '../../../core/validators/validators.dart';

typedef MachineFormResult = ({String name, String model});

class MachineDialog extends StatefulWidget {
  final CoffeeMachine? machine;

  const MachineDialog({super.key, this.machine});

  @override
  State<MachineDialog> createState() => _MachineDialogState();
}

class _MachineDialogState extends State<MachineDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _modelCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.machine?.name ?? '');
    _modelCtrl = TextEditingController(text: widget.machine?.model ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _modelCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.pop<MachineFormResult>(context, (
      name: _nameCtrl.text.trim(),
      model: _modelCtrl.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.machine != null;
    return AlertDialog(
      title: Text(isEdit ? 'Edit Machine' : 'Add Machine'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameCtrl,
              validator: Validators.machineName,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Kitchen Pro',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _modelCtrl,
              validator: Validators.machineName,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: 'Model',
                hintText: 'Jura E8',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3E2723),
            foregroundColor: Colors.white,
          ),
          child: Text(isEdit ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}
