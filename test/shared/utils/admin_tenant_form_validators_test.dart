import 'package:flutter_test/flutter_test.dart';
import 'package:saas/shared/utils/admin_tenant_form_validators.dart';

void main() {
  group('AdminTenantFormValidators', () {
    test('tenantSlug accepts hyphenated lowercase', () {
      expect(AdminTenantFormValidators.tenantSlug('acme-corp'), isNull);
    });

    test('tenantSlug rejects invalid characters', () {
      expect(AdminTenantFormValidators.tenantSlug('Acme Corp'), isNotNull);
    });

    test('tenantDomain accepts host with subdomain', () {
      expect(
        AdminTenantFormValidators.tenantDomain('acme.example.com'),
        isNull,
      );
    });

    test('logoUrl requires http(s)', () {
      expect(AdminTenantFormValidators.logoUrl('ftp://x.com'), isNotNull);
      expect(
        AdminTenantFormValidators.logoUrl('https://x.com/logo.png'),
        isNull,
      );
    });
  });
}
