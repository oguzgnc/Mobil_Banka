/// Yeni başvuru formu gönderimi ve başvuru listesi için kullanılan model.
class ApplicationModel {
  final String? id;
  final String tcNo;
  final String fullName;
  final String province;
  final String product;
  final double hectares;
  final bool isContractFarming;
  final DateTime? applicationDate;
  final String? status;

  const ApplicationModel({
    this.id,
    required this.tcNo,
    required this.fullName,
    required this.province,
    required this.product,
    required this.hectares,
    required this.isContractFarming,
    this.applicationDate,
    this.status,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'] as String?,
      tcNo: json['tc_no'] as String,
      fullName: json['full_name'] as String,
      province: json['province'] as String,
      product: json['product'] as String,
      hectares: (json['hectares'] as num).toDouble(),
      isContractFarming: json['is_contract_farming'] as bool,
      applicationDate: json['application_date'] != null
          ? DateTime.parse(json['application_date'] as String)
          : null,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'tc_no': tcNo,
        'full_name': fullName,
        'province': province,
        'product': product,
        'hectares': hectares,
        'is_contract_farming': isContractFarming,
        if (applicationDate != null)
          'application_date': applicationDate!.toIso8601String(),
        if (status != null) 'status': status,
      };

  /// Form'dan yeni başvuru oluştururken kullanılır (id ve tarih olmadan)
  ApplicationModel copyWith({
    String? id,
    String? tcNo,
    String? fullName,
    String? province,
    String? product,
    double? hectares,
    bool? isContractFarming,
    DateTime? applicationDate,
    String? status,
  }) {
    return ApplicationModel(
      id: id ?? this.id,
      tcNo: tcNo ?? this.tcNo,
      fullName: fullName ?? this.fullName,
      province: province ?? this.province,
      product: product ?? this.product,
      hectares: hectares ?? this.hectares,
      isContractFarming: isContractFarming ?? this.isContractFarming,
      applicationDate: applicationDate ?? this.applicationDate,
      status: status ?? this.status,
    );
  }
}
