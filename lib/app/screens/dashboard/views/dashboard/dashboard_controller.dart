import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas/core/models/member/member_schema_models.dart';
import '../../../../../core/controllers/app_settings_controller.dart';
import '../../../../../core/di/get_injector.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../network/repo/member_repo.dart';
import '../../../../../routes/app_pages.dart';
import '../members/members_mobile_view.dart';

class DashboardController extends GetxController {
  DashboardController();

  final selectedNavIndex = 0.obs;
  final renewalsScrollController = ScrollController();
  final memberTableData = <MemberRow>[].obs;
  final membersLoading = false.obs;
  final membersErrorMessage = RxnString();

  late final MemberRepository _memberRepository;
  late final AuthService _authService;

  @override
  void onInit() {
    super.onInit();
    _memberRepository = Get.find<MemberRepository>();
    _authService = Get.find<AuthService>();
    loadMembers();
  }

  @override
  void onClose() {
    renewalsScrollController.dispose();
    super.onClose();
  }

  void onNavTap(int index) {
    selectedNavIndex.value = index;
    if (index == 1 && memberTableData.isEmpty && !membersLoading.value) {
      loadMembers();
    }
  }

  Future<void> onLogout() async {
    await Get.find<AuthService>().logout();
    Get.find<AppSettingsController>().isUserLoggedIn.value = false;
    appNav.changePage(AppRoutes.home);
  }

  void onAddMember() {}
  void onViewAllRenewals() {
    selectedNavIndex.value = 3;
  }
  void onSendRemindersNow() {}

  Future<void> loadMembers() async {
    membersLoading.value = true;
    membersErrorMessage.value = null;
    try {
      await _memberRepository.getMemberSchema();
      final response = await _memberRepository.getMembers(
        pageNumber: 1,
        pageSize: 20,
      );
      memberTableData.assignAll(response.items.map(_memberRowFromAsset).toList());
    } catch (e) {
      membersErrorMessage.value = _authService.messageForError(e);
      memberTableData.clear();
    } finally {
      membersLoading.value = false;
    }
  }

  Future<void> addMember({
    required String name,
    required String email,
    required String phone,
    required String plan,
    required DateTime startDate,
    required DateTime expiresAt,
  }) async {
    final normalizedPlan = _normalizePlanForApi(plan);
    final id = _newAssetId();
    final now = DateTime.now().toUtc().toIso8601String();
    final body = <String, dynamic>{
      'urn': 'urn:resource:asset:member',
      'st': 'published',
      'id': id,
      'key': id,
      'cty': 'member',
      'status': 'active',
      'prd': ['recrip'],
      'ct': _toIsoUtc(startDate),
      'ut': _toIsoUtc(expiresAt),
      'name': name.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'plan': normalizedPlan,
      'expiresAt': _toIsoUtc(expiresAt),
      'au_ut': now,
    };

    final created = await _memberRepository.createMember(body: body);
    final row = created != null
        ? _memberRowFromAsset(created)
        : MemberRow(
            contentId: id,
            name: name.trim(),
            phone: phone.trim(),
            email: email.trim(),
            plan: _capitalize(normalizedPlan),
            startDate: _formatDate(_toIsoUtc(startDate)),
            expiry: _formatDate(_toIsoUtc(expiresAt)),
            status: MemberStatus.active,
          );
    memberTableData.insert(0, row);
  }

  Future<void> updateMember({
    required String contentId,
    required String name,
    required String email,
    required String phone,
    required String plan,
    required DateTime startDate,
    required DateTime expiresAt,
  }) async {
    final normalizedPlan = _normalizePlanForApi(plan);
    final body = <String, dynamic>{
      'urn': 'urn:resource:asset:member',
      'st': 'published',
      'id': contentId,
      'key': contentId,
      'cty': 'member',
      'status': 'active',
      'prd': ['recrip'],
      'ct': _toIsoUtc(startDate),
      'ut': _toIsoUtc(expiresAt),
      'name': name.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'plan': normalizedPlan,
      'expiresAt': _toIsoUtc(expiresAt),
    };

    final updated = await _memberRepository.updateMember(
      contentId: contentId,
      body: body,
    );
    final nextRow = updated != null
        ? _memberRowFromAsset(updated)
        : MemberRow(
            contentId: contentId,
            name: name.trim(),
            phone: phone.trim(),
            email: email.trim(),
            plan: _capitalize(normalizedPlan),
            startDate: _formatDate(_toIsoUtc(startDate)),
            expiry: _formatDate(_toIsoUtc(expiresAt)),
            status: MemberStatus.active,
          );

    final idx = memberTableData.indexWhere((e) => e.contentId == contentId);
    if (idx >= 0) {
      memberTableData[idx] = nextRow;
    } else {
      memberTableData.insert(0, nextRow);
    }
  }

  MemberRow _memberRowFromAsset(MemberAsset m) {
    return MemberRow(
      contentId: (m.id.isNotEmpty ? m.id : m.key),
      name: m.name.trim().isNotEmpty ? m.name : m.key,
      phone: (m.phone ?? '').trim().isNotEmpty ? m.phone!.trim() : '—',
      email: (m.email ?? '').trim().isNotEmpty ? m.email!.trim() : '—',
      plan: _capitalize((m.plan ?? '').trim()),
      startDate: _formatDate(m.ut),
      expiry: _formatDate(m.expiresAt),
      status: _mapStatus(m.status),
    );
  }

  String _capitalize(String input) {
    if (input.isEmpty) return '—';
    final lower = input.toLowerCase();
    return '${lower[0].toUpperCase()}${lower.substring(1)}';
  }

  String _normalizePlanForApi(String value) => value.trim().toLowerCase();

  String _toIsoUtc(DateTime date) => date.toUtc().toIso8601String();

  String _newAssetId() {
    final micros = DateTime.now().microsecondsSinceEpoch;
    return 'MEMBER-$micros';
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.trim().isEmpty) return '—';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final d = dt.day.toString().padLeft(2, '0');
      final m = dt.month.toString().padLeft(2, '0');
      final y = dt.year.toString();
      return '$d/$m/$y';
    } catch (_) {
      return iso;
    }
  }

  MemberStatus _mapStatus(String? value) {
    switch ((value ?? '').toLowerCase()) {
      case 'active':
        return MemberStatus.active;
      case 'expired':
        return MemberStatus.expired;
      default:
        return MemberStatus.expiring;
    }
  }
}
