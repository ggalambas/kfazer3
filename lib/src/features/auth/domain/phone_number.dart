import 'package:equatable/equatable.dart';

class PhoneNumber with EquatableMixin {
  final String code;
  final String number;
  PhoneNumber(this.code, this.number);

  String get full => '$code$number';

  @override
  String toString() => '$code $number';

  @override
  List<Object?> get props => [code, number];
}
