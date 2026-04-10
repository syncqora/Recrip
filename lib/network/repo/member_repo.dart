import '../../core/models/member/member_schema_models.dart';
import '../api/member_api_services.dart';

abstract class MemberRepository {
  Future<MemberSchemaResponse> getMemberSchema();
  Future<MemberSchemaResponse> getMembers({
    int pageNumber,
    int pageSize,
  });
  Future<MemberAsset?> createMember({required Map<String, dynamic> body});
  Future<MemberAsset?> updateMember({
    required String contentId,
    required Map<String, dynamic> body,
  });
}

class MemberRepo implements MemberRepository {
  MemberRepo({required this.services});

  final MemberServices services;

  @override
  Future<MemberSchemaResponse> getMemberSchema() => services.getMemberSchema();

  @override
  Future<MemberSchemaResponse> getMembers({
    int pageNumber = 1,
    int pageSize = 20,
  }) => services.getMembers(pageNumber: pageNumber, pageSize: pageSize);

  @override
  Future<MemberAsset?> createMember({required Map<String, dynamic> body}) =>
      services.createMember(body: body);

  @override
  Future<MemberAsset?> updateMember({
    required String contentId,
    required Map<String, dynamic> body,
  }) => services.updateMember(contentId: contentId, body: body);
}
