/// Yeni başvuru formu → POST /api/applications payload'ı
/// Python API key uyumu: TCKN, ad_soyad, Il, Urun1_Adi, Urun1_Alan, sozlesmeli_tarim
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

  // ── Python FastAPI key mapping ────────────────────────────────────────────
  //   TCKN             → tcNo
  //   ad_soyad         → fullName
  //   Il               → province
  //   Urun1_Adi        → product
  //   Urun1_Alan       → hectares
  //   sozlesmeli_tarim → isContractFarming
  // ──────────────────────────────────────────────────────────────────────────
  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id:                json['id']?.toString(),
      tcNo:              json['TCKN']            as String? ?? '',
      fullName:          json['ad_soyad']         as String? ?? '',
      province:          json['Il']               as String? ?? '',
      product:           json['Urun1_Adi']        as String? ?? '',
      hectares:          (json['Urun1_Alan']       as num?)?.toDouble() ?? 0.0,
      isContractFarming: _parseBool(json['sozlesmeli_tarim']),
      applicationDate:   json['basvuru_tarihi'] != null
          ? DateTime.tryParse(json['basvuru_tarihi'] as String)
          : null,
      status:            json['onay_durumu']      as String?
                      ?? json['status']           as String?,
    );
  }

  /// POST body — Python API'nin beklediği key'ler ile
  Map<String, dynamic> toJson() => {
        'TCKN':            tcNo,
        'ad_soyad':        fullName,
        'Il':              province,
        'Urun1_Adi':       product,
        'Urun1_Alan':      hectares,
        'sozlesmeli_tarim': isContractFarming,
      };

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
      id:                id               ?? this.id,
      tcNo:              tcNo             ?? this.tcNo,
      fullName:          fullName         ?? this.fullName,
      province:          province         ?? this.province,
      product:           product          ?? this.product,
      hectares:          hectares         ?? this.hectares,
      isContractFarming: isContractFarming ?? this.isContractFarming,
      applicationDate:   applicationDate  ?? this.applicationDate,
      status:            status           ?? this.status,
    );
  }

  static bool _parseBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is int) return v == 1;
    return v.toString().toLowerCase() == 'true' || v.toString() == '1';
  }
}
