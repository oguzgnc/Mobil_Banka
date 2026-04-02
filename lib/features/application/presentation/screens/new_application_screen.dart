import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../application/data/models/application_model.dart';
import '../../../application/domain/providers/application_providers.dart';

// ─── Sabitler ─────────────────────────────────────────────────────────────────

const _provinces = [
  'Adana', 'Adıyaman', 'Afyonkarahisar', 'Ağrı', 'Aksaray', 'Amasya',
  'Ankara', 'Antalya', 'Bursa', 'Çorum', 'Denizli', 'Diyarbakır',
  'Erzurum', 'Eskişehir', 'Gaziantep', 'Hatay', 'İstanbul', 'İzmir',
  'Kayseri', 'Konya', 'Malatya', 'Manisa', 'Mardin', 'Mersin',
  'Muş', 'Nevşehir', 'Niğde', 'Samsun', 'Şanlıurfa', 'Siirt',
  'Tekirdağ', 'Tokat', 'Trabzon', 'Van', 'Yozgat',
];

const _products = [
  'Arpa', 'Ayçiçeği', 'Buğday', 'Çeltik', 'Domates',
  'Fasulye', 'Mısır', 'Nohut', 'Pamuk', 'Patates',
  'Şeker Pancarı', 'Zeytin',
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class NewApplicationScreen extends ConsumerStatefulWidget {
  const NewApplicationScreen({super.key});

  @override
  ConsumerState<NewApplicationScreen> createState() =>
      _NewApplicationScreenState();
}

class _NewApplicationScreenState extends ConsumerState<NewApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tcController = TextEditingController();
  final _nameController = TextEditingController();
  final _hectaresController = TextEditingController();

  String? _selectedProvince;
  String? _selectedProduct;
  bool _isContractFarming = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _tcController.dispose();
    _nameController.dispose();
    _hectaresController.dispose();
    super.dispose();
  }

  // ── Submit ──────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final model = ApplicationModel(
        tcNo: _tcController.text.trim(),
        fullName: _nameController.text.trim(),
        province: _selectedProvince!,
        product: _selectedProduct!,
        hectares: double.parse(_hectaresController.text.trim()),
        isContractFarming: _isContractFarming,
      );

      await ref.read(applicationRepositoryProvider).submitApplication(model);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Başvuru başarıyla sisteme kaydedildi!',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.statusApproved,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );

      _resetForm();
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _tcController.clear();
    _nameController.clear();
    _hectaresController.clear();
    setState(() {
      _selectedProvince = null;
      _selectedProduct = null;
      _isContractFarming = false;
    });
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Bölüm 1: Kimlik Bilgileri ──────────────────────────────────
            _FormSection(
              title: 'Kimlik Bilgileri',
              icon: Icons.badge_outlined,
              children: [
                _AppFormField(
                  label: 'TC Kimlik No',
                  hint: '12345678901',
                  controller: _tcController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  prefixIcon: Icons.fingerprint,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'TC Kimlik No boş bırakılamaz.';
                    if (v.length != 11) return 'TC Kimlik No tam 11 haneli olmalıdır.';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                _AppFormField(
                  label: 'Ad Soyad',
                  hint: 'Ahmet Yıldız',
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  prefixIcon: Icons.person_outlined,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Ad Soyad boş bırakılamaz.';
                    if (v.trim().split(' ').length < 2) return 'Lütfen ad ve soyadı birlikte girin.';
                    return null;
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // ── Bölüm 2: Tarım Bilgileri ───────────────────────────────────
            _FormSection(
              title: 'Tarım Bilgileri',
              icon: Icons.agriculture_outlined,
              children: [
                _AppDropdownField<String>(
                  label: 'İl',
                  hint: 'İl seçin',
                  value: _selectedProvince,
                  prefixIcon: Icons.location_on_outlined,
                  items: _provinces
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedProvince = v),
                  validator: (v) =>
                      v == null ? 'Lütfen bir il seçin.' : null,
                ),
                const SizedBox(height: 14),
                _AppDropdownField<String>(
                  label: 'Ekilecek Ürün',
                  hint: 'Ürün seçin',
                  value: _selectedProduct,
                  prefixIcon: Icons.grass_outlined,
                  items: _products
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedProduct = v),
                  validator: (v) =>
                      v == null ? 'Lütfen bir ürün seçin.' : null,
                ),
                const SizedBox(height: 14),
                _AppFormField(
                  label: 'Arazi Büyüklüğü (Hektar)',
                  hint: '0.0',
                  controller: _hectaresController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  prefixIcon: Icons.crop_square_outlined,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Hektar alanı boş bırakılamaz.';
                    final parsed = double.tryParse(v);
                    if (parsed == null) return 'Geçerli bir sayı girin.';
                    if (parsed <= 0) return 'Hektar değeri 0\'dan büyük olmalıdır.';
                    return null;
                  },
                ),
                const SizedBox(height: 4),
                // ── Sözleşmeli Tarım Toggle ─────────────────────────────────
                _ContractFarmingToggle(
                  value: _isContractFarming,
                  onChanged: (v) => setState(() => _isContractFarming = v),
                ),
              ],
            ),
            const SizedBox(height: 28),
            // ── Gönder Butonu ─────────────────────────────────────────────
            _SubmitButton(
              isSubmitting: _isSubmitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Form Section ─────────────────────────────────────────────────────────────

class _FormSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _FormSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyles.headlineSmall),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

// ─── Text Form Field ──────────────────────────────────────────────────────────

class _AppFormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final IconData prefixIcon;
  final String? Function(String?) validator;

  const _AppFormField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.prefixIcon,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon, size: 18),
      ),
      validator: validator,
    );
  }
}

// ─── Dropdown Field ───────────────────────────────────────────────────────────

class _AppDropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final IconData prefixIcon;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? Function(T?) validator;

  const _AppDropdownField({
    required this.label,
    required this.hint,
    required this.value,
    required this.prefixIcon,
    required this.items,
    required this.onChanged,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon, size: 18),
      ),
      isExpanded: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      items: items,
      onChanged: onChanged,
      validator: validator,
    );
  }
}

// ─── Contract Farming Toggle ──────────────────────────────────────────────────

class _ContractFarmingToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ContractFarmingToggle({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: value
            ? AppColors.statusApproved.withValues(alpha: 0.06)
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: value
              ? AppColors.statusApproved.withValues(alpha: 0.4)
              : AppColors.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.handshake_outlined,
            size: 18,
            color: value ? AppColors.statusApproved : AppColors.textSecondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sözleşmeli Tarım', style: AppTextStyles.titleSmall),
                Text(
                  value
                      ? 'Çiftçi sözleşmeli tarım yapıyor'
                      : 'Sözleşmeli tarım yapılmıyor',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: value
                        ? AppColors.statusApproved
                        : AppColors.textDisabled,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.statusApproved,
          ),
        ],
      ),
    );
  }
}

// ─── Submit Button ────────────────────────────────────────────────────────────

class _SubmitButton extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onPressed;

  const _SubmitButton({
    required this.isSubmitting,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isSubmitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.send_rounded, size: 18),
                  SizedBox(width: 10),
                  Text(
                    'Başvuruyu Yapay Zeka Onayına Gönder',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }
}
