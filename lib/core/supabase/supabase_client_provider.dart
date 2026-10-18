import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provides the initialized Supabase client instance.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provides the Supabase GoTrue auth client.
final supabaseAuthProvider = Provider<GoTrueClient>((ref) {
  return ref.watch(supabaseClientProvider).auth;
});

/// Stream provider — emits the current Supabase user (null = signed out).
/// Starts with the current user immediately, then listens for auth changes.
final currentSupabaseUserProvider = StreamProvider<User?>((ref) async* {
  final client = ref.watch(supabaseClientProvider);
  yield client.auth.currentUser;
  await for (final event in client.auth.onAuthStateChange) {
    yield event.session?.user;
  }
});

/// Synchronous provider for the current user (for quick reads).
/// Reactively follows currentSupabaseUserProvider.
final currentUserProvider = Provider<User?>((ref) {
  final asyncUser = ref.watch(currentSupabaseUserProvider);
  return asyncUser.value ?? Supabase.instance.client.auth.currentUser;
});

/// Whether the user is signed in to the cloud.
final isCloudSignedInProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});
