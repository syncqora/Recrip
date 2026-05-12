import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/models/admin/create_admin_user_request.dart';
import '../../../../core/models/admin/create_tenant_request.dart';
import '../../../../core/models/admin/link_tenant_user_request.dart';
import '../../../../network/api/admin_platform_api_services.dart';
import '../../../../shared/constants/admin_constants.dart';
import '../../../../shared/utils/app_exceptions.dart';

/// Form state and chained API calls: create tenant → user → link to tenant.
class AdminTenantUserController extends GetxController {
  AdminTenantUserController({AdminPlatformServices? api})
    : _api = api ?? Get.find<AdminPlatformServices>();

  final AdminPlatformServices _api;

  final tenantName = TextEditingController();
  final tenantSlug = TextEditingController();
  final tenantDomain = TextEditingController();
  final tenantDescription = TextEditingController();
  final tenantLogoUrl = TextEditingController();

  final userUsername = TextEditingController();
  final userEmail = TextEditingController();
  final userPassword = TextEditingController();
  final userFirstName = TextEditingController();
  final userLastName = TextEditingController();

  final isSubmitting = false.obs;
  final isPasswordVisible = false.obs;
  final selectedTenantRole = AdminConstants.tenantUserRoles.first.obs;

  /// Validates [TextFormField]s under the tenant onboarding [Form].
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    tenantName.dispose();
    tenantSlug.dispose();
    tenantDomain.dispose();
    tenantDescription.dispose();
    tenantLogoUrl.dispose();
    userUsername.dispose();
    userEmail.dispose();
    userPassword.dispose();
    userFirstName.dispose();
    userLastName.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Clears all fields and resets role to the default option.
  void resetForm() {
    tenantName.clear();
    tenantSlug.clear();
    tenantDomain.clear();
    tenantDescription.clear();
    tenantLogoUrl.clear();
    userUsername.clear();
    userEmail.clear();
    userPassword.clear();
    userFirstName.clear();
    userLastName.clear();
    isPasswordVisible.value = false;
    selectedTenantRole.value = AdminConstants.tenantUserRoles.first;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      formKey.currentState?.reset();
    });
  }

  /// Runs tenant create, then user create, then tenant-user link.
  ///
  /// Returns `0` on success, `1` on validation or API failure.
  Future<int> submitOnboard() async {
    if (isSubmitting.value) return 1;
    if (!(formKey.currentState?.validate() ?? false)) {
      Get.snackbar(
        'Check the form',
        'Fix the highlighted fields and try again.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return 1;
    }

    isSubmitting.value = true;
    try {
      final tenant = await _api.createTenant(
        CreateTenantRequest(
          name: tenantName.text.trim(),
          slug: tenantSlug.text.trim().toLowerCase(),
          domain: tenantDomain.text.trim(),
          description: tenantDescription.text.trim(),
          logoUrl: tenantLogoUrl.text.trim(),
        ),
      );
      if (tenant.id.isEmpty) {
        Get.snackbar(
          'Error',
          'Tenant created but response had no ID.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return 1;
      }

      final user = await _api.createUser(
        CreateAdminUserRequest(
          username: userUsername.text.trim(),
          email: userEmail.text.trim(),
          password: userPassword.text,
          firstName: userFirstName.text.trim(),
          lastName: userLastName.text.trim(),
          isActive: true,
        ),
      );
      if (user.id.isEmpty) {
        Get.snackbar(
          'Error',
          'User created but response had no ID.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return 1;
      }

      await _api.linkTenantUser(
        tenantId: tenant.id,
        request: LinkTenantUserRequest(
          userId: user.id,
          role: selectedTenantRole.value,
        ),
      );

      Get.snackbar(
        'Success',
        'Tenant ${tenant.name}, user ${user.username}, linked as ${selectedTenantRole.value}.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
      return 0;
    } on ApiException catch (e) {
      Get.snackbar(
        'Request failed',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return 1;
    } on JSONException catch (e) {
      Get.snackbar(
        'Invalid response',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return 1;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return 1;
    } finally {
      isSubmitting.value = false;
    }
  }
}
