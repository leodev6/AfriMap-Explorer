import 'package:equatable/equatable.dart';

class Island extends Equatable {
  final String id;
  final String name;
  final String countryId;

  const Island({
    required this.id,
    required this.name,
    required this.countryId,
  });

  factory Island.fromMap(Map<String, dynamic> map) {
    return Island(
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
