import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/env.dart';

class SupabaseClientFactory {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
