import 'package:equatable/equatable.dart';

class Language extends Equatable {
  final String id;
  final String name;
  final String type; // 'officielle' or 'traditionnelle'

  const Language({
    required this.id,
    required this.name,
    required this.type,
  });

  bool get isOfficial => type == 'officielle';

  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(
      id: map['id'] as String,
      name: map['name'] as String,
      type: map['type'] as String? ?? 'traditionnelle',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }

  @override
  List<Object?> get props => [id, name, type];
}
