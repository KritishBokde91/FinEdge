import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/sms_intelligence/domain/services/contacts_resolver_service.dart';
import 'repository_providers.dart';

/// Provider exposing the singleton contacts resolver service.
final contactsResolverProvider = Provider<ContactsResolverService>((ref) {
  final permService = ref.watch(permissionServiceProvider);
  return ContactsResolverService(permService);
});
