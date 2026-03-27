import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String id;
  final String name;
  final String flagUrl;
  final String capital;

  const Country({
    required this.id,
    required this.name,
    required this.flagUrl,
    required this.capital,
  });

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      id: map['id'] as String,
      name: map['name'] as String,
      flagUrl: map['flag_url'] as String? ?? '',
      capital: map['capital'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'flag_url': flagUrl,
      'capital': capital,
    };
  }

  @override
  List<Object?> get props => [id, name, flagUrl, capital];
}
