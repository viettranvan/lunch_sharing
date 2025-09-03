part of 'router.dart';

enum RouterName {

  home('/'),
  addInvoice('/add-invoice'),
  markPaid('/mark-paid'),
  manageUser('/manage-user'),
  ;

  final String path;
  const RouterName(this.path);
}
