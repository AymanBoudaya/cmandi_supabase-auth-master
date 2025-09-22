import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../features/personalization/models/user_model.dart';
import '../../../utils/exceptions/supabase_auth_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../repositories/authentication/authentication_repository.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final SupabaseClient _client = Supabase.instance.client;
  final _table = 'users';

  /// Sauvegarder ou mettre à jour un utilisateur
  Future<void> saveUserRecord(UserModel user) async {
    try {
      print('🔁 UserRepository.saveUserRecord → ${user.toJson()}');

      final resp = await _client
          .from(_table)
          .upsert(user.toJson(), onConflict: 'id')
          .select()
          .maybeSingle();

      print('✅ User upsert OK: $resp');
    } on PostgrestException catch (e) {
      print('❌ PostgrestException saveUserRecord: ${e.message}');
      rethrow;
    } catch (e, st) {
      print('❌ Unknown error saveUserRecord: $e\n$st');
      rethrow;
    }
  }

  /// Récupérer les infos utilisateur (par défaut l’utilisateur connecté)
  Future<UserModel?> fetchUserDetails([String? userId]) async {
    try {
      final authUser = Supabase.instance.client.auth.currentUser;
      final targetId = userId ?? authUser?.id;

      if (targetId == null) throw 'No authenticated user.';

      final response =
          await _client.from(_table).select().eq('id', targetId).maybeSingle();

      print('📥 fetchUserDetails($targetId) response: $response');

      if (response == null) return null;

      return UserModel.fromJson({
        ...response,
        'id': targetId,
        'email': response['email'] ?? authUser?.email,
      });
    } on AuthException catch (e) {
      throw SupabaseAuthException(
        e.message,
        statusCode: int.tryParse(e.statusCode ?? ''),
      );
    } on FormatException {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e, stack) {
      print("❌ fetchUserDetails error: $e");
      print(stack);
      rethrow;
    }
  }

  /// Mettre à jour un utilisateur
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      final response = await _client
          .from(_table)
          .update(updatedUser.toJson())
          .eq('id', updatedUser.id)
          .select();

      if (response.isEmpty) throw 'Update failed.';
      print("✅ updateUserDetails OK: ${updatedUser.id}");
    } on AuthException catch (e) {
      throw SupabaseAuthException(
        e.message,
        statusCode: int.tryParse(e.statusCode ?? ''),
      );
    } on FormatException {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw '❌ Something went wrong in updateUserDetails: $e';
    }
  }

  /// Mettre à jour un champ spécifique
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      print('🔄 updateSingleField: $json');

      final userId = AuthenticationRepository.instance.authUser?.id;
      if (userId == null) throw 'No authenticated user.';

      final response =
          await _client.from(_table).update(json).eq('id', userId).select();

      if (response.isEmpty) throw 'Update failed.';
      print('✅ updateSingleField OK: $response');
    } on AuthException catch (e) {
      throw SupabaseAuthException(
        e.message,
        statusCode: int.tryParse(e.statusCode ?? ''),
      );
    } on FormatException {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw '❌ Something went wrong in updateSingleField: $e';
    }
  }

  /// Supprimer un utilisateur
  Future<void> removeUserRecord(String userId) async {
    try {
      final response = await _client.from(_table).delete().eq('id', userId);

      if (response.isEmpty) throw 'Delete failed.';
      print("🗑 removeUserRecord OK: $userId");
    } on AuthException catch (e) {
      throw SupabaseAuthException(
        e.message,
        statusCode: int.tryParse(e.statusCode ?? ''),
      );
    } on FormatException {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw '❌ Something went wrong in removeUserRecord: $e';
    }
  }
}
