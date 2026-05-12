import 'package:flutter_test/flutter_test.dart';
import 'package:saas/core/models/admin/tenant_response_model.dart';

void main() {
  test('TenantResponseModel.fromJson parses PascalCase API payload', () {
    final m = TenantResponseModel.fromJson({
      'ID': '01dd960c-0b47-485e-8057-d2d845a1adec',
      'Name': 'Acme Corporation',
      'Slug': 'acme-corp',
      'Domain': 'acme.example.com',
      'Description': 'Acme Corporation tenant',
      'LogoURL': 'https://example.com/logo.png',
      'IsActive': true,
    });
    expect(m.id, '01dd960c-0b47-485e-8057-d2d845a1adec');
    expect(m.slug, 'acme-corp');
    expect(m.isActive, isTrue);
  });
}
