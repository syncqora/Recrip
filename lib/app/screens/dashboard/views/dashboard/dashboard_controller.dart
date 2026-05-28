import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas/core/models/member/member_schema_models.dart';
import 'package:saas/app/subscriptions/subscriptions_binding.dart';
import 'package:saas/app/subscriptions/subscriptions_controller.dart';
import '../../../../../core/controllers/app_settings_controller.dart';
import '../../../../../core/di/get_injector.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../network/repo/member_repo.dart';
import '../../../../../shared/utils/uuid_v4.dart';
import '../../../../../routes/app_pages.dart';
import '../members/members_mobile_view.dart';

class DashboardController extends GetxController {
  DashboardController();

  final selectedNavIndex = 0.obs;
  final renewalsScrollController = ScrollController();
  final memberTableData = <MemberRow>[].obs;
  final membersLoading = false.obs;
  final membersErrorMessage = RxnString();

  final activeMemberCount = 0.obs;
  final expiringMemberCount = 0.obs;
  final expiredMemberCount = 0.obs;
  final memberCountsLoading = false.obs;
  final moduleSwitchLoading = false.obs;

  late final MemberRepository _memberRepository;
  late final AuthService _authService;

  @override
  void onInit() {
    super.onInit();
    _memberRepository = Get.find<MemberRepository>();
    _authService = Get.find<AuthService>();
    loadMembers();
    loadMemberCounts();
  }

  /// Fetches active, expiring, and expired counts from `/count/asset/member`.
  ///
  /// Each status is loaded independently so one failure does not block the others.
  Future<void> loadMemberCounts() async {
    memberCountsLoading.value = true;
    await Future.wait([
      _loadCountForStatus('active', activeMemberCount),
      _loadCountForStatus('expiring', expiringMemberCount),
      _loadCountForStatus('expired', expiredMemberCount),
    ]);
    memberCountsLoading.value = false;
  }

  Future<void> _loadCountForStatus(String status, RxInt target) async {
    try {
      final response = await _memberRepository.countMembers(status: status);
      target.value = response.count;
    } catch (_) {
      // Count failures must not surface on the Members tab (it reuses
      // [membersErrorMessage] for the member list API only).
      target.value = 0;
    }
  }

  @override
  void onClose() {
    renewalsScrollController.dispose();
    super.onClose();
  }

  void onNavTap(int index) {
    if (selectedNavIndex.value == index) return;
    selectedNavIndex.value = index;
    _loadModuleDataFor(index);
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

  Future<void> _loadModuleDataFor(int index) async {
    moduleSwitchLoading.value = true;
    try {
      if (index == 1 || index == 3 || index == 4) {
        if (memberTableData.isEmpty || membersErrorMessage.value != null) {
          await loadMembers();
        } else if (membersLoading.value) {
          await _waitUntil(() => !membersLoading.value);
        }
      } else if (index == 2) {
        SubscriptionsBinding.ensureRegistered();
        final subscriptionsController = Get.find<SubscriptionsController>();
        if (subscriptionsController.plans.isEmpty ||
            subscriptionsController.errorMessage.value != null) {
          await subscriptionsController.loadInitialData();
        } else if (subscriptionsController.isLoading.value) {
          await _waitUntil(() => !subscriptionsController.isLoading.value);
        }
      } else {
        await Future<void>.delayed(const Duration(milliseconds: 120));
      }
    } finally {
      moduleSwitchLoading.value = false;
    }
  }

  Future<void> _waitUntil(
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 8),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (!condition()) {
      if (DateTime.now().isAfter(deadline)) break;
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> loadMembers() async {
    membersLoading.value = true;
    membersErrorMessage.value = null;
    try {
      await _memberRepository.getMemberSchema();
      final response = await _memberRepository.getMembers(
        pageNumber: 1,
        pageSize: 20,
      );
      memberTableData.assignAll(
        response.items.map(_memberRowFromAsset).toList(),
      );
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
    await loadMemberCounts();
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

  String _newAssetId() => newUuidV4();

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
