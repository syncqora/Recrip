import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas/core/models/member/member_schema_models.dart';
import 'package:saas/core/services/auth_service.dart';
import 'package:saas/network/repo/member_repo.dart';

import 'members_mobile_view.dart';

class MembersController extends GetxController {
  late final MemberRepository _memberRepository;
  late final AuthService _authService;

  final selectedPlan = RxnString();
  final selectedStatus = RxnString();
  final tableData = <MemberRow>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    _memberRepository = Get.find<MemberRepository>();
    _authService = Get.find<AuthService>();
  }

  @override
  void onReady() {
    super.onReady();
    loadMembers();
  }

  Future<void> loadMembers() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      // await _memberRepository.getMemberSchema();
      // final response = await _memberRepository.getMembers(
      //   pageNumber: 1,
      //   pageSize: 20,
      // );
      // tableData.assignAll(response.items.map(_memberRowFromAsset).toList());
      tableData.assignAll([_dummyMember(), _dummyMember(), _dummyMember()]);
    } catch (e) {
      errorMessage.value = _authService.messageForError(e);
      tableData.clear();
      tableData.assignAll([_dummyMember(), _dummyMember(), _dummyMember()]);
    } finally {
      isLoading.value = false;
    }
  }

  void setSelectedPlan(String? value) {
    selectedPlan.value = value;
  }

  void setSelectedStatus(String? value) {
    selectedStatus.value = value;
  }

  Color statusColor(String value) {
    switch (value) {
      case 'Active':
        return const Color(0xFF166534);
      case 'Expiring':
        return const Color(0xFF92400E);
      case 'Expired':
        return const Color(0xFF991B1B);
      default:
        return const Color(0xFF0F172A);
    }
  }

  MemberRow _memberRowFromAsset(MemberAsset m) {
    return MemberRow(
      name: m.name.trim().isNotEmpty ? m.name : m.key,
      phone: (m.phone ?? '').trim().isNotEmpty ? m.phone!.trim() : '—',
      email: (m.email ?? '').trim().isNotEmpty ? m.email!.trim() : '—',
      plan: _capitalize((m.plan ?? '').trim()),
      expiry: _formatDate(m.expiresAt),
      status: _mapStatus(m.status),
    );
  }

  MemberRow _dummyMember() {
    return MemberRow(
      name: 'Test Member',
      phone: '9876543210',
      email: 'test@example.com',
      plan: 'Basic',
      expiry: '31/12/2026',
      status: MemberStatus.active,
    );
  }

  String _capitalize(String input) {
    if (input.isEmpty) return '—';
    final lower = input.toLowerCase();
    return '${lower[0].toUpperCase()}${lower.substring(1)}';
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
