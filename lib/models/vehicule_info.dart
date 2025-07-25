class VehicleInfo{
  String? type;
  String? model;
  int? year;
  String? plateNumber;
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
    // Handle case where vehicleInfo might be missing (for admin accounts)
    if (map == null) {
      return VehicleInfo.defaultConst();
    }

    var plateNum = map['plateNumber'];
    String plateNumStr = plateNum is int ? plateNum.toString() : (plateNum?.toString() ?? '');
    
    // Handle potential null or invalid year values
    int? yearValue;
    var yearData = map['year'];
    if (yearData != null) {
      if (yearData is int) {
        yearValue = yearData;
      } else if (yearData is String) {
        yearValue = int.tryParse(yearData);
      }
    }
    
    return VehicleInfo(
      type: map['type']?.toString() ?? '',
      model: map['model']?.toString() ?? '',
      year: yearValue ?? 0,
      plateNumber: plateNumStr,
      color: map['color']?.toString() ?? '',
    );
  }
}