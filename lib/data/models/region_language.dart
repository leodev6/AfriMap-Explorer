import 'package:equatable/equatable.dart';

class RegionLanguage extends Equatable {
  final String id;
  final String regionId;
  final String languageId;

  const RegionLanguage({
    required this.id,
    required this.regionId,
    required this.languageId,
  });

  factory RegionLanguage.fromMap(Map<String, dynamic> map) {
    return RegionLanguage(
      id: map['id'] as String,
      regionId: map['region_id'] as String,
      languageId: map['language_id'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'region_id': regionId,
      'language_id': languageId,
    };
  }

  @override
  List<Object?> get props => [id, regionId, languageId];
}
