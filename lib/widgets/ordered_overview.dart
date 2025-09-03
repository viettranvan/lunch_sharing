import 'package:flutter/material.dart';
import 'package:lunch_sharing/src/models/api_models.dart';

class OrderedOverview extends StatefulWidget {
  const OrderedOverview({super.key, required this.invoices});
  final List<ApiInvoice> invoices;

  @override
  State<OrderedOverview> createState() => _OrderedOverviewState();
}

class _OrderedOverviewState extends State<OrderedOverview> {
  List<ApiUser> users = [];

  @override
  void initState() {
    for (var element in widget.invoices) {
      for (var orderer in element.orderers) {
        if (!users.contains(orderer.user)) {
          users.add(orderer.user);
        }
      }
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant OrderedOverview oldWidget) {
    if (oldWidget.invoices != widget.invoices) {
      for (var element in widget.invoices) {
        for (var orderer in element.orderers) {
          if (!users.contains(orderer.user)) {
            users.add(orderer.user);
          }
        }
      }

      for (final user in List<ApiUser>.from(users)) {
        if (buildFinal(user, widget.invoices) == 0) {
          users.remove(user);
        }
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  String buildSum(String userName, List<ApiInvoice> invoices) {
    String result = '';

    for (final invoice in invoices) {
      ApiOrderer orderer = invoice.orderers.firstWhere(
        (orderer) => orderer.user.name == userName,
        orElse: () => ApiOrderer.empty(),
      );
      if (result.isEmpty && orderer.actualPrice != 0 && !orderer.isPaid) {
        result += orderer.actualPrice.toStringAsFixed(2);
      } else if (result.isNotEmpty &&
          orderer.actualPrice != 0 &&
          !orderer.isPaid) {
        result += ' + ${orderer.actualPrice.toStringAsFixed(2)}';
      }
    }

    return result;
  }

  double buildFinal(ApiUser user, List<ApiInvoice> invoices) {
    double result = 0;

    for (final invoice in invoices) {
      final orderer = invoice.orderers.firstWhere(
        (orderer) => orderer.user.name == user.name,
        orElse: () => ApiOrderer.empty(),
      );
      if (!orderer.isPaid) {
        result += orderer.actualPrice;
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        0: const FlexColumnWidth(),
        1: const FlexColumnWidth(3),
        2: const FlexColumnWidth(),
      },
      children: List.generate(users.length, (index) {
        return TableRow(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.grey.withValues(alpha: 0.1) : null,
          ),
          children: [
            // * Name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                users[index].name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            // * Name
            Text(
              buildSum(users[index].name, widget.invoices),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            // * Name
            Text(
              buildFinal(users[index], widget.invoices).toStringAsFixed(2),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            Text(
              'Mark as Paid',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        );
      }),
    );
  }
}
