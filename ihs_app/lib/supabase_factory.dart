// ignore_for_file: avoid_classes_with_only_static_members

import 'package:settings_yaml/settings_yaml.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFactory {
  static late SupabaseClient client;

  static Future<void> initialise() async {
    final settings = SettingsYaml.load(pathToSettings: 'settings.yaml');
    final supaBaseKey = settings.asString('SUPABASE_KEY');

    final supabase = await Supabase.initialize(
      url: 'https://lejhshocbcaovlktmgyb.supabase.co',
      anonKey: supaBaseKey,
    );
    client = supabase.client;
  }
}
