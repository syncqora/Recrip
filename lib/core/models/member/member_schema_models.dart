/// Envelope `header` for member schema/content responses.
class MemberResponseHeader {
  const MemberResponseHeader({
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

  factory MemberResponseHeader.fromJson(Map<String, dynamic> json) {
    return MemberResponseHeader(
      source: json['source'] as String?,
      code: (json['code'] as num?)?.toInt(),
      message: json['message'] as String?,
      systemTime: (json['system_time'] as num?)?.toInt(),
      trackingId: json['tracking_id'] as String?,
    );
  }
}

/// One member asset row from API `data`.
class MemberAsset {
  const MemberAsset({
    required this.id,
    required this.key,
    required this.name,
    this.email,
    this.phone,
    this.plan,
    this.expiresAt,
    this.status,
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
  final String? email;
  final String? phone;
  final String? plan;
  final String? expiresAt;
  final String? status;
  final String? st;
  final String? cty;
  final String? urn;
  final String? ct;
  final String? ut;
  final List<String>? prd;
  final String? auId;
  final List<String>? auR;
  final String? auUt;

  factory MemberAsset.fromJson(Map<String, dynamic> json) {
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

    return MemberAsset(
      id: json['id'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      plan: json['plan'] as String?,
      expiresAt: json['expiresAt'] as String?,
      status: json['status'] as String?,
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

class MemberSchemaResponse {
  const MemberSchemaResponse({
    required this.header,
    required this.items,
  });

  final MemberResponseHeader header;
  final List<MemberAsset> items;

  static List<MemberAsset> _parseData(dynamic data) {
    if (data == null) return [];
    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => MemberAsset.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    if (data is Map) {
      final m = Map<String, dynamic>.from(data);
      final items = m['items'] ?? m['content'] ?? m['data'];
      if (items is List) {
        return items
            .whereType<Map>()
            .map((e) => MemberAsset.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      if (m.containsKey('properties') && m.containsKey('type')) {
        return [];
      }
      if (m.containsKey('id') || m.containsKey('name') || m.containsKey('urn')) {
        return [MemberAsset.fromJson(m)];
      }
    }
    return [];
  }

  factory MemberSchemaResponse.fromJson(Map<String, dynamic> json) {
    final headerRaw = json['header'];
    final header = headerRaw is Map
        ? MemberResponseHeader.fromJson(Map<String, dynamic>.from(headerRaw))
        : const MemberResponseHeader();
    return MemberSchemaResponse(header: header, items: _parseData(json['data']));
  }
}
