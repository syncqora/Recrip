// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'getAllCountriesResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllCountriesResponse _$GetAllCountriesResponseFromJson(
  Map<String, dynamic> json,
) => GetAllCountriesResponse(
  id: (json['id'] as num?)?.toInt(),
  nicename: json['nicename'] as String?,
  iso: json['iso'] as String?,
  phonecode: json['phonecode'] as String?,
  currency: json['currency'] as String?,
  flagsUrl: json['flagsUrl'] as String?,
);

Map<String, dynamic> _$GetAllCountriesResponseToJson(
  GetAllCountriesResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'nicename': instance.nicename,
  'iso': instance.iso,
  'phonecode': instance.phonecode,
  'currency': instance.currency,
  'flagsUrl': instance.flagsUrl,
};
