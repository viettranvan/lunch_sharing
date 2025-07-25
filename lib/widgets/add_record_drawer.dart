import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lunch_sharing/models/index.dart';
import 'package:uuid/uuid.dart';

class AddRecordDrawer extends StatefulWidget {
  const AddRecordDrawer({super.key, this.onConfirm, required this.users});
  final List<String> users;

  final Function(List<Orderers>)? onConfirm;
  @override
  State<AddRecordDrawer> createState() => _AddRecordDrawerState();
}

class _AddRecordDrawerState extends State<AddRecordDrawer> {
  late final List<Orderers> orderers;
  List<Orderers> selected = [];

  @override
  void initState() {
    orderers =
        widget.users.map((e) => Orderers(id: Uuid().v4(), name: e)).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        Text(
          'Select Users',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          children: orderers.map((e) {
            return InkWell(
              onTap: () {
                setState(() {
                  if (selected.contains(e)) {
                    selected.remove(e);
                  } else {
                    selected.add(e);
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                decoration: BoxDecoration(
                  color: selected.any((item) => item.name == e.name)
                      ? Colors.blue.withValues(alpha: 0.7)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.6),
                    width: 1,
                  ),
                ),
                child: Text(e.name),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: selected.length,
          padding: EdgeInsets.zero,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(
                      '${selected[index].name}:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 6,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        selected[index] = selected[index].copyWith(
                          itemPrice: double.tryParse(value) ?? 0,
                        );
                      });
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}'),
                      ),
                    ],
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  onPressed: () {
                    setState(() {
                      if (selected.contains(selected[index])) {
                        selected.remove(selected[index]);
                      } else {
                        selected.add(selected[index]);
                      }
                    });
                  },
                  icon: Icon(Icons.delete_forever),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        Visibility(
          visible: selected.isNotEmpty,
          child: Text(
            "Total: ${selected.fold(0.0, (sum, item) => sum + item.itemPrice).toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
        Visibility(
          visible: selected.isNotEmpty,
          child: InkWell(
            onTap: () {
              bool isAnyEmpty = selected.any((e) => e.itemPrice == 0);
              if (isAnyEmpty) {
                EasyLoading.showError('Please fill all fields');

                return;
              }

              final total = selected.fold(
                0.0,
                (sum, item) => sum + item.itemPrice,
              );
              selected = selected
                  .map((e) => e.copyWith(percentage: (e.itemPrice / total)))
                  .toList();

              Navigator.of(context).pop();
              widget.onConfirm?.call(selected);
            },
            child: Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.lightBlueAccent,
              ),
              constraints: BoxConstraints(maxWidth: 200),
              child: Center(
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
