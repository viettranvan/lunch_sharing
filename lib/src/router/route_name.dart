part of 'router.dart';

enum RouterName {

  home('/'),
  addRecord('/add-record'),
  markPaid('/mark-paid'),
  ;

  final String path;
  const RouterName(this.path);
}
