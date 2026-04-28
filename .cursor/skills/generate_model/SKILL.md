---
name: generate_model
description: Generates data models with proper JSON serialization following the project's model patterns
---

# Generate Model Skill

This skill automates the creation of data models for API responses, requests, and local data structures following the CoffeeWeb-App's patterns.

## Model Patterns in This Project

Based on codebase analysis:

### Location
- **API Response Models**: `lib/core/models/{feature}/response/`
- **API Request Models**: `lib/core/models/{feature}/request/`
- **Shared Models**: `lib/shared/models/`
- **Feature-Specific Models**: `lib/app/{feature}/{feature}_model.dart`

### Common Patterns
1. Models use JSON serialization (typically with `json_annotation` or manual)
2. Models have `fromJson` and `toJson` methods
3. Models use nullable fields with `?` where appropriate
4. Models include DartDoc comments
5. Some models use `@JsonKey` annotations for custom serialization

## Usage Instructions

### Step 1: Gather Requirements
Ask the user for:
1. **Model name** (e.g., "UserProfile", "CoffeePrice")
2. **Model type** (Request/Response/Local)
3. **Fields** with types and nullability
4. **Location** (which feature it belongs to)

### Step 2: Generate Model Class

**Basic Model Template:**
```dart
/// Model representing {description}
class {ModelName} {
  final String? id;
  final String? name;
  final int? count;
  final bool? isActive;
  
  {ModelName}({
    this.id,
    this.name,
    this.count,
    this.isActive,
  });
  
  /// Creates a {ModelName} instance from JSON
  factory {ModelName}.fromJson(Map<String, dynamic> json) {
    return {ModelName}(
      id: json['id'] as String?,
      name: json['name'] as String?,
      count: json['count'] as int?,
      isActive: json['isActive'] as bool?,
    );
  }
  
  /// Converts this {ModelName} instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'count': count,
      'isActive': isActive,
    };
  }
  
  /// Creates a copy of this {ModelName} with updated fields
  {ModelName} copyWith({
    String? id,
    String? name,
    int? count,
    bool? isActive,
  }) {
    return {ModelName}(
      id: id ?? this.id,
      name: name ?? this.name,
      count: count ?? this.count,
      isActive: isActive ?? this.isActive,
    );
  }
}
```

### Step 3: Add to Barrel File (if applicable)
If the model is in a shared location, add export to the appropriate barrel file.

## Field Type Mapping

Common JSON to Dart type mappings:
- `string` → `String?`
- `number` (int) → `int?`
- `number` (decimal) → `double?`
- `boolean` → `bool?`
- `array` → `List<T>?`
- `object` → Custom model or `Map<String, dynamic>?`
- `date/datetime` → `DateTime?` (parse with `DateTime.parse()`)

## Best Practices

1. **Always use nullable types** unless the field is guaranteed to be present
2. **Add DartDoc comments** for the class and complex fields
3. **Include `copyWith`** method for immutability patterns
4. **Use proper JSON key mapping** if API keys differ from Dart naming
5. **Handle nested objects** by creating separate model classes
6. **Add validation** in factory constructors if needed

## Example Usage

**User**: "Create a model for coffee price data with fields: id (string), price (double), currency (string), timestamp (datetime)"

**Generated Model**:
```dart
/// Model representing coffee price data from the API
class CoffeePriceModel {
  final String? id;
  final double? price;
  final String? currency;
  final DateTime? timestamp;
  
  CoffeePriceModel({
    this.id,
    this.price,
    this.currency,
    this.timestamp,
  });
  
  /// Creates a CoffeePriceModel instance from JSON
  factory CoffeePriceModel.fromJson(Map<String, dynamic> json) {
    return CoffeePriceModel(
      id: json['id'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'] as String)
          : null,
    );
  }
  
  /// Converts this CoffeePriceModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'currency': currency,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
  
  /// Creates a copy of this CoffeePriceModel with updated fields
  CoffeePriceModel copyWith({
    String? id,
    double? price,
    String? currency,
    DateTime? timestamp,
  }) {
    return CoffeePriceModel(
      id: id ?? this.id,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
```

## Advanced Patterns

### Nested Objects
```dart
class UserProfile {
  final String? userId;
  final Address? address; // Nested object
  
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] as String?,
      address: json['address'] != null 
          ? Address.fromJson(json['address'] as Map<String, dynamic>)
          : null,
    );
  }
}
```

### Lists
```dart
class NewsResponse {
  final List<NewsFeed>? newsFeeds;
  
  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    return NewsResponse(
      newsFeeds: (json['newsFeeds'] as List<dynamic>?)
          ?.map((e) => NewsFeed.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
```

### Custom JSON Keys
```dart
class ApiResponse {
  @JsonKey(name: 'user_id')
  final String? userId;
  
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
}
```
