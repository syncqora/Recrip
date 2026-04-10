/// Member asset paths (relative to [ApiEndPoints.dataManagementBaseUrl]).
abstract final class MemberEndPoints {
  MemberEndPoints._();

  static const String schemaMember = '/schema/asset/member';
  static const String contentMember = '/content/asset/member';

  static String contentMemberById(String contentId) =>
      '/content/asset/member/$contentId';
}
