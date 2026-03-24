/// Envelope `header` from GET `/schema/asset/subscription`.
class SubscriptionSchemaResponseHeader {
  const SubscriptionSchemaResponseHeader({
    this.source,
    this.code,
    this.message,
    this.systemTime,
    this.trackingId,
  });

  final String? source;
  final int? code;
  final String? message;
  final int? systemTime;
  final String? trackingId;

  factory SubscriptionSchemaResponseHeader.fromJson(Map<String, dynamic> json) {
    return SubscriptionSchemaResponseHeader(
      source: json['source'] as String?,
      code: (json['code'] as num?)?.toInt(),
      message: json['message'] as String?,
      systemTime: (json['system_time'] as num?)?.toInt(),
      trackingId: json['tracking_id'] as String?,
    );
  }
}

/// One subscription asset row from API `data` (object or list element).
class SubscriptionAsset {
  const SubscriptionAsset({
    required this.id,
    required this.key,
    required this.name,
    this.duration,
    this.price,
    this.st,
    this.cty,
    this.urn,
    this.ct,
    this.ut,
    this.prd,
    this.auId,
    this.auR,
    this.auUt,
  });

  final String id;
  final String key;
  final String name;
  final int? duration;
  final double? price;
  final String? st;
  final String? cty;
  final String? urn;
  final String? ct;
  final String? ut;
  final List<String>? prd;
  final String? auId;
  final List<String>? auR;
  final String? auUt;

  factory SubscriptionAsset.fromJson(Map<String, dynamic> json) {
    List<String>? prdList;
    final prdRaw = json['prd'];
    if (prdRaw is List) {
      prdList = prdRaw.map((e) => e.toString()).toList();
    }
    List<String>? auRList;
    final auRRaw = json['au_r'];
    if (auRRaw is List) {
      auRList = auRRaw.map((e) => e.toString()).toList();
    }
    final priceRaw = json['price'];
    double? price;
    if (priceRaw is num) {
      price = priceRaw.toDouble();
    }

    return SubscriptionAsset(
      id: json['id'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      duration: (json['duration'] as num?)?.toInt(),
      price: price,
      st: json['st'] as String?,
      cty: json['cty'] as String?,
      urn: json['urn'] as String?,
      ct: json['ct'] as String?,
      ut: json['ut'] as String?,
      prd: prdList,
      auId: json['au_id'] as String?,
      auR: auRList,
      auUt: json['au_ut'] as String?,
    );
  }
}

/// Parsed GET `/schema/asset/subscription` body.
class SubscriptionSchemaResponse {
  const SubscriptionSchemaResponse({
    required this.header,
    required this.items,
  });

  final SubscriptionSchemaResponseHeader header;
  final List<SubscriptionAsset> items;

  static List<SubscriptionAsset> _parseData(dynamic data) {
    if (data == null) return [];
    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => SubscriptionAsset.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    if (data is Map) {
      final m = Map<String, dynamic>.from(data);
      // Wrapped list
      final items = m['items'] ?? m['content'] ?? m['data'];
      if (items is List) {
        return items
            .whereType<Map>()
            .map((e) => SubscriptionAsset.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      // JSON-Schema style document (properties/meta only) — no rows
      if (m.containsKey('properties') && m.containsKey('type')) {
        return [];
      }
      // Single resource object
      if (m.containsKey('id') ||
          m.containsKey('name') ||
          m.containsKey('urn')) {
        return [SubscriptionAsset.fromJson(m)];
      }
    }
    return [];
  }

  factory SubscriptionSchemaResponse.fromJson(Map<String, dynamic> json) {
    final headerRaw = json['header'];
    final header = headerRaw is Map
        ? SubscriptionSchemaResponseHeader.fromJson(
            Map<String, dynamic>.from(headerRaw),
          )
        : const SubscriptionSchemaResponseHeader();
    final items = _parseData(json['data']);
    return SubscriptionSchemaResponse(header: header, items: items);
  }
}
