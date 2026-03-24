import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'getAllCountriesResponse.g.dart';

@JsonSerializable()
class GetAllCountriesResponse {
  GetAllCountriesResponse({
    this.id,
    String? nicename,
    this.iso,
    this.phonecode,
    this.currency,
    String? flagsUrl,
  }) : nicename = nicename ?? "India",
       flagsUrl =
           flagsUrl ??
           "https://coffeeweb.s3.ap-south-1.amazonaws.com/Masters/Flags/IND.svg";

  factory GetAllCountriesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllCountriesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllCountriesResponseToJson(this);

  int? id;
  String? nicename;
  String? iso;
  String? phonecode;
  String? currency;
  String? flagsUrl;
}

List<GetAllCountriesResponse> allCountriesListResponseFromJson(String str) =>
    List<GetAllCountriesResponse>.from(
      json.decode(str).map((x) => GetAllCountriesResponse.fromJson(x)),
    );

String menuToJson(List<GetAllCountriesResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

GetAllCountriesResponse getAllCountriesResponseFromJson(String str) =>
    GetAllCountriesResponse.fromJson(json.decode(str));
