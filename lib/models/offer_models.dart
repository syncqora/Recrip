// Models for Offers App
import 'package:json_annotation/json_annotation.dart';

part 'offer_models.g.dart';

// ============================================
// LOCATION MODEL
// ============================================
@JsonSerializable()
class LocationModel {
  final String id;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String? zipCode;
  final String country;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final DateTime? updatedAt;

  LocationModel({
    required this.id,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    this.zipCode,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    this.updatedAt,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}

// ============================================
// BRAND MODEL
// ============================================
@JsonSerializable()
class BrandModel {
  final String id;
  final String name;
  final String? logoUrl;
  final String? description;
  final String? websiteUrl;
  final double overallRating;
  final int totalReviews;
  final bool isActive;
  final bool isFeatured;

  BrandModel({
    required this.id,
    required this.name,
    this.logoUrl,
    this.description,
    this.websiteUrl,
    this.overallRating = 0.0,
    this.totalReviews = 0,
    this.isActive = true,
    this.isFeatured = false,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      _$BrandModelFromJson(json);

  Map<String, dynamic> toJson() => _$BrandModelToJson(this);
}

// ============================================
// CATEGORY MODEL
// ============================================
@JsonSerializable()
class CategoryModel {
  final String id;
  final String name;
  final String? iconUrl;
  final String? imageUrl;
  final String? description;
  final int orderIndex;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    this.iconUrl,
    this.imageUrl,
    this.description,
    this.orderIndex = 0,
    this.isActive = true,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}

// ============================================
// OFFER MODEL
// ============================================
@JsonSerializable()
class OfferModel {
  final String id;
  final String title;
  final String? description;
  final String offerType;
  final double? discountValue;
  final String? discountUnit;
  final DateTime startDate;
  final DateTime endDate;
  final String? imageUrl;
  final String? targetUrl;
  final String? termsAndConditions;
  final bool isActive;
  final bool isCarouselOffer;
  final bool isBrandAttention;

  OfferModel({
    required this.id,
    required this.title,
    this.description,
    required this.offerType,
    this.discountValue,
    this.discountUnit,
    required this.startDate,
    required this.endDate,
    this.imageUrl,
    this.targetUrl,
    this.termsAndConditions,
    this.isActive = true,
    this.isCarouselOffer = false,
    this.isBrandAttention = false,
  });

  // Check if offer is currently active
  bool get isCurrentlyActive {
    final now = DateTime.now();
    return isActive && now.isAfter(startDate) && now.isBefore(endDate);
  }

  factory OfferModel.fromJson(Map<String, dynamic> json) =>
      _$OfferModelFromJson(json);

  Map<String, dynamic> toJson() => _$OfferModelToJson(this);
}

// ============================================
// STORE MODEL
// ============================================
@JsonSerializable()
class StoreModel {
  final String id;
  final String name;
  final String? description;
  final String? logoUrl;
  final String? imageUrl;
  final String locationId;
  final double rating;
  final int totalReviews;
  final String? phoneNumber;
  final Map<String, dynamic>? operatingHours;
  final bool isActive;
  final double? distanceKm; // Calculated distance from user
  final List<OfferModel>? offers; // Associated offers

  StoreModel({
    required this.id,
    required this.name,
    this.description,
    this.logoUrl,
    this.imageUrl,
    required this.locationId,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.phoneNumber,
    this.operatingHours,
    this.isActive = true,
    this.distanceKm,
    this.offers,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) =>
      _$StoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoreModelToJson(this);
}

// ============================================
// CAROUSEL OFFER MODEL (for RPC response)
// ============================================
@JsonSerializable()
class CarouselOfferModel {
  @JsonKey(name: 'offer_id')
  final String offerId;
  final String title;
  final String? description;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'discount_value')
  final double? discountValue;
  @JsonKey(name: 'discount_unit')
  final String? discountUnit;
  @JsonKey(name: 'target_url')
  final String? targetUrl;
  @JsonKey(name: 'brand_name')
  final String? brandName;
  @JsonKey(name: 'brand_logo_url')
  final String? brandLogoUrl;
  @JsonKey(name: 'store_name')
  final String? storeName;
  @JsonKey(name: 'distance_km')
  final double? distanceKm;

  CarouselOfferModel({
    required this.offerId,
    required this.title,
    this.description,
    this.imageUrl,
    this.discountValue,
    this.discountUnit,
    this.targetUrl,
    this.brandName,
    this.brandLogoUrl,
    this.storeName,
    this.distanceKm,
  });

  factory CarouselOfferModel.fromJson(Map<String, dynamic> json) =>
      _$CarouselOfferModelFromJson(json);

  Map<String, dynamic> toJson() => _$CarouselOfferModelToJson(this);
}

// ============================================
// STORE WITH OFFERS MODEL (for RPC response)
// ============================================
@JsonSerializable()
class StoreWithOffersModel {
  @JsonKey(name: 'store_id')
  final String storeId;
  @JsonKey(name: 'store_name')
  final String storeName;
  @JsonKey(name: 'store_image_url')
  final String? storeImageUrl;
  @JsonKey(name: 'store_logo_url')
  final String? storeLogoUrl;
  @JsonKey(name: 'store_address')
  final String storeAddress;
  @JsonKey(name: 'store_rating')
  final double storeRating;
  @JsonKey(name: 'store_total_reviews')
  final int storeTotalReviews;
  @JsonKey(name: 'distance_km')
  final double distanceKm;
  final List<Map<String, dynamic>> offers; // JSONB array from RPC

  StoreWithOffersModel({
    required this.storeId,
    required this.storeName,
    this.storeImageUrl,
    this.storeLogoUrl,
    required this.storeAddress,
    required this.storeRating,
    required this.storeTotalReviews,
    required this.distanceKm,
    required this.offers,
  });

  // Convert offers JSONB to OfferModel list
  List<OfferModel> get offersList {
    return offers.map((offerJson) {
      // Convert the JSONB offer to OfferModel
      // Note: RPC returns limited fields, so we create a partial model
      return OfferModel(
        id: offerJson['offer_id'] as String,
        title: offerJson['title'] as String? ?? '',
        description: offerJson['description'] as String?,
        offerType: 'percentage_discount', // Default
        discountValue: offerJson['discount_value'] != null
            ? (offerJson['discount_value'] as num).toDouble()
            : null,
        discountUnit: offerJson['discount_unit'] as String?,
        startDate: DateTime.now(), // RPC doesn't return dates
        endDate: DateTime.now(),
        imageUrl: offerJson['image_url'] as String?,
        targetUrl: offerJson['target_url'] as String?,
      );
    }).toList();
  }

  factory StoreWithOffersModel.fromJson(Map<String, dynamic> json) =>
      _$StoreWithOffersModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoreWithOffersModelToJson(this);
}

// ============================================
// BRAND ATTENTION MODEL (for RPC response)
// ============================================
@JsonSerializable()
class BrandAttentionModel {
  @JsonKey(name: 'brand_id')
  final String brandId;
  @JsonKey(name: 'brand_name')
  final String brandName;
  @JsonKey(name: 'brand_logo_url')
  final String? brandLogoUrl;
  @JsonKey(name: 'offer_id')
  final String offerId;
  @JsonKey(name: 'offer_title')
  final String offerTitle;
  @JsonKey(name: 'discount_value')
  final double? discountValue;
  @JsonKey(name: 'discount_unit')
  final String? discountUnit;
  @JsonKey(name: 'distance_km')
  final double? distanceKm;

  BrandAttentionModel({
    required this.brandId,
    required this.brandName,
    this.brandLogoUrl,
    required this.offerId,
    required this.offerTitle,
    this.discountValue,
    this.discountUnit,
    this.distanceKm,
  });

  factory BrandAttentionModel.fromJson(Map<String, dynamic> json) =>
      _$BrandAttentionModelFromJson(json);

  Map<String, dynamic> toJson() => _$BrandAttentionModelToJson(this);
}
