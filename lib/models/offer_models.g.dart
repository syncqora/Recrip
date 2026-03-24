// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    LocationModel(
      id: json['id'] as String,
      addressLine1: json['addressLine1'] as String,
      addressLine2: json['addressLine2'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String?,
      country: json['country'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'addressLine1': instance.addressLine1,
      'addressLine2': instance.addressLine2,
      'city': instance.city,
      'state': instance.state,
      'zipCode': instance.zipCode,
      'country': instance.country,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

BrandModel _$BrandModelFromJson(Map<String, dynamic> json) => BrandModel(
  id: json['id'] as String,
  name: json['name'] as String,
  logoUrl: json['logoUrl'] as String?,
  description: json['description'] as String?,
  websiteUrl: json['websiteUrl'] as String?,
  overallRating: (json['overallRating'] as num?)?.toDouble() ?? 0.0,
  totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
  isActive: json['isActive'] as bool? ?? true,
  isFeatured: json['isFeatured'] as bool? ?? false,
);

Map<String, dynamic> _$BrandModelToJson(BrandModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logoUrl': instance.logoUrl,
      'description': instance.description,
      'websiteUrl': instance.websiteUrl,
      'overallRating': instance.overallRating,
      'totalReviews': instance.totalReviews,
      'isActive': instance.isActive,
      'isFeatured': instance.isFeatured,
    };

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconUrl: json['iconUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String?,
      orderIndex: (json['orderIndex'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'iconUrl': instance.iconUrl,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'orderIndex': instance.orderIndex,
      'isActive': instance.isActive,
    };

OfferModel _$OfferModelFromJson(Map<String, dynamic> json) => OfferModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  offerType: json['offerType'] as String,
  discountValue: (json['discountValue'] as num?)?.toDouble(),
  discountUnit: json['discountUnit'] as String?,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  imageUrl: json['imageUrl'] as String?,
  targetUrl: json['targetUrl'] as String?,
  termsAndConditions: json['termsAndConditions'] as String?,
  isActive: json['isActive'] as bool? ?? true,
  isCarouselOffer: json['isCarouselOffer'] as bool? ?? false,
  isBrandAttention: json['isBrandAttention'] as bool? ?? false,
);

Map<String, dynamic> _$OfferModelToJson(OfferModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'offerType': instance.offerType,
      'discountValue': instance.discountValue,
      'discountUnit': instance.discountUnit,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'imageUrl': instance.imageUrl,
      'targetUrl': instance.targetUrl,
      'termsAndConditions': instance.termsAndConditions,
      'isActive': instance.isActive,
      'isCarouselOffer': instance.isCarouselOffer,
      'isBrandAttention': instance.isBrandAttention,
    };

StoreModel _$StoreModelFromJson(Map<String, dynamic> json) => StoreModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  logoUrl: json['logoUrl'] as String?,
  imageUrl: json['imageUrl'] as String?,
  locationId: json['locationId'] as String,
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
  phoneNumber: json['phoneNumber'] as String?,
  operatingHours: json['operatingHours'] as Map<String, dynamic>?,
  isActive: json['isActive'] as bool? ?? true,
  distanceKm: (json['distanceKm'] as num?)?.toDouble(),
  offers: (json['offers'] as List<dynamic>?)
      ?.map((e) => OfferModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StoreModelToJson(StoreModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'logoUrl': instance.logoUrl,
      'imageUrl': instance.imageUrl,
      'locationId': instance.locationId,
      'rating': instance.rating,
      'totalReviews': instance.totalReviews,
      'phoneNumber': instance.phoneNumber,
      'operatingHours': instance.operatingHours,
      'isActive': instance.isActive,
      'distanceKm': instance.distanceKm,
      'offers': instance.offers,
    };

CarouselOfferModel _$CarouselOfferModelFromJson(Map<String, dynamic> json) =>
    CarouselOfferModel(
      offerId: json['offer_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      discountValue: (json['discount_value'] as num?)?.toDouble(),
      discountUnit: json['discount_unit'] as String?,
      targetUrl: json['target_url'] as String?,
      brandName: json['brand_name'] as String?,
      brandLogoUrl: json['brand_logo_url'] as String?,
      storeName: json['store_name'] as String?,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CarouselOfferModelToJson(CarouselOfferModel instance) =>
    <String, dynamic>{
      'offer_id': instance.offerId,
      'title': instance.title,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'discount_value': instance.discountValue,
      'discount_unit': instance.discountUnit,
      'target_url': instance.targetUrl,
      'brand_name': instance.brandName,
      'brand_logo_url': instance.brandLogoUrl,
      'store_name': instance.storeName,
      'distance_km': instance.distanceKm,
    };

StoreWithOffersModel _$StoreWithOffersModelFromJson(
  Map<String, dynamic> json,
) => StoreWithOffersModel(
  storeId: json['store_id'] as String,
  storeName: json['store_name'] as String,
  storeImageUrl: json['store_image_url'] as String?,
  storeLogoUrl: json['store_logo_url'] as String?,
  storeAddress: json['store_address'] as String,
  storeRating: (json['store_rating'] as num).toDouble(),
  storeTotalReviews: (json['store_total_reviews'] as num).toInt(),
  distanceKm: (json['distance_km'] as num).toDouble(),
  offers: (json['offers'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
);

Map<String, dynamic> _$StoreWithOffersModelToJson(
  StoreWithOffersModel instance,
) => <String, dynamic>{
  'store_id': instance.storeId,
  'store_name': instance.storeName,
  'store_image_url': instance.storeImageUrl,
  'store_logo_url': instance.storeLogoUrl,
  'store_address': instance.storeAddress,
  'store_rating': instance.storeRating,
  'store_total_reviews': instance.storeTotalReviews,
  'distance_km': instance.distanceKm,
  'offers': instance.offers,
};

BrandAttentionModel _$BrandAttentionModelFromJson(Map<String, dynamic> json) =>
    BrandAttentionModel(
      brandId: json['brand_id'] as String,
      brandName: json['brand_name'] as String,
      brandLogoUrl: json['brand_logo_url'] as String?,
      offerId: json['offer_id'] as String,
      offerTitle: json['offer_title'] as String,
      discountValue: (json['discount_value'] as num?)?.toDouble(),
      discountUnit: json['discount_unit'] as String?,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BrandAttentionModelToJson(
  BrandAttentionModel instance,
) => <String, dynamic>{
  'brand_id': instance.brandId,
  'brand_name': instance.brandName,
  'brand_logo_url': instance.brandLogoUrl,
  'offer_id': instance.offerId,
  'offer_title': instance.offerTitle,
  'discount_value': instance.discountValue,
  'discount_unit': instance.discountUnit,
  'distance_km': instance.distanceKm,
};
