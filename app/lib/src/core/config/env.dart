/// Environment configuration.
///
/// Values are injected at build time via `--dart-define` so that secrets never
/// live in the repo:
///
/// ```sh
/// flutter run \
///   --dart-define=SUPABASE_URL=https://xyz.supabase.co \
///   --dart-define=SUPABASE_ANON_KEY=eyJhbGci...
/// ```
///
/// When the keys are absent the app boots in **offline/mock mode** (in-memory
/// repositories), so the team can develop UI without a live backend.
class Env {
  const Env._();

  static const String supabaseUrl =
      String.fromEnvironment('SUPABASE_URL', defaultValue: '');

  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

  /// Azure OpenAI proxy endpoint (served via a Supabase Edge Function in MVP).
  static const String aiEndpoint =
      String.fromEnvironment('MAJU_AI_ENDPOINT', defaultValue: '');

  /// True when a real Supabase project is wired up.
  static bool get hasBackend =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
