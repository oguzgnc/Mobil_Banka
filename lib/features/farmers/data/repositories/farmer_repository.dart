import '../../../../core/network/api_client.dart';
import '../models/farmer_model.dart';

class FarmerRepository {
  final ApiClient _client;
  FarmerRepository(this._client);

  /// Backend hazır olduğunda: GET /farmers
  Future<List<FarmerModel>> getFarmers() async {
    await Future.delayed(const Duration(milliseconds: 1200));

    // TODO: final response = await _client.dio.get(ApiConstants.farmers);
    // return (response.data as List).map((e) => FarmerModel.fromJson(e)).toList();

    return _dummyFarmers;
  }

  /// Backend hazır olduğunda: GET /farmers/{id}
  Future<FarmerModel> getFarmerById(String id) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // TODO: final response = await _client.dio.get('/farmers/$id');
    // return FarmerModel.fromJson(response.data as Map<String, dynamic>);

    return _dummyFarmers.firstWhere(
      (f) => f.id == id,
      orElse: () => _dummyFarmers.first,
    );
  }

  // ignore: unused_field
  ApiClient get client => _client;
}

// ─── Dummy Veriler ────────────────────────────────────────────────────────────

final _dummyFarmers = [
  FarmerModel(
    id: '1',
    tcNo: '12345678901',
    fullName: 'Ahmet Yıldız',
    province: 'Konya',
    product: 'Buğday',
    hectares: 85.0,
    riskScore: 22.5,
    approvalStatus: ApprovalStatus.approved,
    applicationDate: DateTime(2025, 3, 10),
    isContractFarming: true,
    aiDecisionSummary:
        'Düşük risk profili tespit edildi. Sözleşmeli tarım güvencesi ve sulama altyapısı onayı destekliyor. '
        'Geçmiş 3 yılda %100 geri ödeme performansı mevcut.',
    riskFactors: ['Sözleşmeli tarım güvencesi ✓', 'Sulama altyapısı mevcut ✓', 'Geçmiş ödemeler temiz ✓'],
  ),
  FarmerModel(
    id: '2',
    tcNo: '23456789012',
    fullName: 'Fatma Kaya',
    province: 'Şanlıurfa',
    product: 'Pamuk',
    hectares: 42.0,
    riskScore: 61.8,
    approvalStatus: ApprovalStatus.underReview,
    applicationDate: DateTime(2025, 3, 18),
    isContractFarming: false,
    aiDecisionSummary:
        'Bölgesel su kısıtı nedeniyle orta risk skoru. Sulama kotaları 2025 sezonu için %30 azaltıldı. '
        'Sözleşmeli tarım garantisi olsaydı onay verilecekti.',
    riskFactors: ['Bölgesel su kısıtı ⚠️', 'Sözleşmeli tarım yok ⚠️', 'İklim riski orta ⚠️'],
  ),
  FarmerModel(
    id: '3',
    tcNo: '34567890123',
    fullName: 'Mehmet Demir',
    province: 'İzmir',
    product: 'Mısır',
    hectares: 120.5,
    riskScore: 15.2,
    approvalStatus: ApprovalStatus.approved,
    applicationDate: DateTime(2025, 2, 28),
    isContractFarming: true,
    aiDecisionSummary:
        'Güçlü kredi geçmişi ve sertifikalı organik üretim belgesi. Risk skoru sektör ortalamasının çok altında.',
    riskFactors: ['Organik sertifika ✓', 'Güçlü kredi geçmişi ✓', 'Sözleşmeli tarım ✓'],
  ),
  FarmerModel(
    id: '4',
    tcNo: '45678901234',
    fullName: 'Zeynep Arslan',
    province: 'Adana',
    product: 'Pamuk',
    hectares: 67.0,
    riskScore: 78.4,
    approvalStatus: ApprovalStatus.rejected,
    applicationDate: DateTime(2025, 3, 5),
    isContractFarming: false,
    aiDecisionSummary:
        'Yüksek risk: 2023 yılında ödeme gecikme kaydı ve aktif icra takibi mevcut. '
        'Arazi tapu tescil sorunu tespit edildi.',
    riskFactors: ['Ödeme gecikme kaydı ✗', 'Aktif icra takibi ✗', 'Tapu tescil sorunu ✗'],
  ),
  FarmerModel(
    id: '5',
    tcNo: '56789012345',
    fullName: 'Ali Çelik',
    province: 'Ankara',
    product: 'Arpa',
    hectares: 33.0,
    riskScore: 44.7,
    approvalStatus: ApprovalStatus.pending,
    applicationDate: DateTime(2025, 3, 22),
    isContractFarming: false,
    aiDecisionSummary:
        'Başvuru değerlendirme kuyruğunda. İlk analiz: orta risk, ek belge talep edildi. '
        'Toprak analiz raporu bekleniyor.',
    riskFactors: ['Ek belge bekleniyor ⏳', 'Toprak analiz raporu eksik ⏳'],
  ),
  FarmerModel(
    id: '6',
    tcNo: '67890123456',
    fullName: 'Hatice Şahin',
    province: 'Konya',
    product: 'Ayçiçeği',
    hectares: 95.5,
    riskScore: 28.1,
    approvalStatus: ApprovalStatus.approved,
    applicationDate: DateTime(2025, 3, 1),
    isContractFarming: true,
    aiDecisionSummary:
        'Kooperatif üyesi ve sözleşmeli tarım yapıyor. Sulama sistemi modernize edilmiş. '
        'Düşük risk profili, hızlı onay verildi.',
    riskFactors: ['Kooperatif üyeliği ✓', 'Modern sulama sistemi ✓', 'Sözleşmeli tarım ✓'],
  ),
  FarmerModel(
    id: '7',
    tcNo: '78901234567',
    fullName: 'Mustafa Öztürk',
    province: 'Gaziantep',
    product: 'Buğday',
    hectares: 210.0,
    riskScore: 52.3,
    approvalStatus: ApprovalStatus.underReview,
    applicationDate: DateTime(2025, 3, 19),
    isContractFarming: true,
    aiDecisionSummary:
        'Büyük ölçekli başvuru nedeniyle detaylı inceleme yapılıyor. '
        'Sözleşmeli tarım puanı olumlu, ancak arazi parçalanma riski değerlendiriliyor.',
    riskFactors: ['Büyük ölçekli arazi ⚠️', 'Arazi parçalanma riski ⚠️', 'Sözleşmeli tarım ✓'],
  ),
  FarmerModel(
    id: '8',
    tcNo: '89012345678',
    fullName: 'Ayşe Yılmaz',
    province: 'Mersin',
    product: 'Mısır',
    hectares: 55.0,
    riskScore: 19.8,
    approvalStatus: ApprovalStatus.approved,
    applicationDate: DateTime(2025, 2, 15),
    isContractFarming: true,
    aiDecisionSummary:
        'Tarımsal destekleme ödemelerini düzenli alan, sicili temiz çiftçi. '
        'Seracılık yatırımı yapması risk skorunu olumlu etkiliyor.',
    riskFactors: ['Temiz sicil ✓', 'Düzenli destek ödemeleri ✓', 'Sera yatırımı ✓'],
  ),
];
