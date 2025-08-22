import 'package:flutter/widgets.dart';
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/members/presentation/pages/members_list_page.dart';
import 'package:sonamak_flutter/features/members/presentation/pages/member_profile_page.dart';

/// Registers Members feature routes.
/// Note: MemberProfilePage accepts an optional memberId, so this route works even without args.
class MembersInstaller {
  static void install() {
    RouteHub.register('/members', const RouteEntry(builder: _list));
    RouteHub.register('/members/profile', const RouteEntry(builder: _profile));
  }

  static Widget _list(BuildContext context) => const MembersListPage();
  static Widget _profile(BuildContext context) => const MemberProfilePage();
}
