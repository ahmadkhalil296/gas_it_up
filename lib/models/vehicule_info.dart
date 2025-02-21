class VehicleInfo{
  String? type;
  String? model;
  int? year;
  int? plateNumber;
  String? color;

  VehicleInfo.defaultConst();

  VehicleInfo({required this.type,required this.model,required this.year,required this.plateNumber,required this.color});

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'model': model,
      'year': year,
      'plateNumber': plateNumber,
      'color': color,
    };
  }

  static VehicleInfo fromMap(Map<String, dynamic> map) {
    return VehicleInfo(
      type: map['type'],
      model: map['model'],
      year: map['year'],
      plateNumber: map['plateNumber'],
      color: map['color'],
    );
  }
}