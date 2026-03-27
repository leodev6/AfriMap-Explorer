import 'package:equatable/equatable.dart';

class Region extends Equatable {
  final String id;
  final String name;
  final String countryId;

  const Region({
    required this.id,
    required this.name,
    required this.countryId,
  });

  factory Region.fromMap(Map<String, dynamic> map) {
    return Region(
      id: map['id'] as String,
      name: map['name'] as String,
      countryId: map['country_id'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'country_id': countryId,
    };
  }

  @override
  List<Object?> get props => [id, name, countryId];
}
