import 'package:equatable/equatable.dart';

/// Class representing a Country.
class Country extends Equatable {
  final String code;
  final String name;
  final String phoneCode;
  final String flagUrl;

  const Country({
    required this.code,
    required this.name,
    required this.phoneCode,
    required this.flagUrl,
  });

  String get phoneCodeFormatted => '+$phoneCode';

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        code: json['alpha2Code'] as String,
        name: json['name'] as String,
        phoneCode: '+${(json['callingCode'] as String).replaceAll(' ', '')}',
        flagUrl: json['flags']['png'] as String,
      );

  @override
  String toString() => name;

  @override
  List<Object?> get props => [code, phoneCode];
}
