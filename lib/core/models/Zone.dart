class Zone {
  String code;
  List<String> slots;
  List<BuyerZone> buyerZones;

  Zone(this.code, this.slots, this.buyerZones);

  factory Zone.fromMap(Map<String, dynamic> map) {
    return Zone(
      map['code'] as String? ?? '',
      (map['slots'] as List<dynamic>?)?.cast<String>() ?? [],
      (map['buyerZones'] as List<dynamic>?)?.map((e) => BuyerZone.fromMap(e as Map<String, dynamic>)).toList() ?? [],
    );
  }
}

class BuyerZone {
  String code;
  List<String> slots;

  BuyerZone(this.code, this.slots);

  factory BuyerZone.fromMap(Map<String, dynamic> map) {
    return BuyerZone(
      map['code'] as String? ?? '',
      (map['slots'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}