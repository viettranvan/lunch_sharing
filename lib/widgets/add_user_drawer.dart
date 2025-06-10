import 'package:flutter/material.dart';
import 'package:lunch_sharing/services/user_order_service.dart';

class AddUserDrawer extends StatefulWidget {
  const AddUserDrawer({super.key});

  @override
  State<AddUserDrawer> createState() => _AddUserDrawerState();
}

class _AddUserDrawerState extends State<AddUserDrawer> {
  final TextEditingController _userController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 20),
        Text(
          'Add Users',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _userController,
          decoration: InputDecoration(
            hintText: 'Enter users',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.6)),
            ),
          ),
          onChanged: (value) {
            // Implement search functionality here
          },
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: () async {
            final sts = await UserOrderService().addUser(
              userName: _userController.text,
            );
            if (sts && context.mounted) {
              _userController.clear();
              Navigator.pop(context);
            } else if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Failed to add user')));
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue.withValues(alpha: 0.7),
            ),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
