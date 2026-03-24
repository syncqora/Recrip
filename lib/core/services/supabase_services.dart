class SupaBaseServices {
  // static bool _isInitialized = false;
  //
  // Future<void> initSupabase() async {
  //   if (_isInitialized) {
  //     debugPrint('Supabase already initialized, skipping...');
  //     return;
  //   }
  //
  //   try {
  //     debugPrint('Initializing Supabase...');
  //     /// supabase setup
  //     await Supabase.initialize(
  //       url: SupabaseConfig.supabaseUrl,
  //       anonKey: SupabaseConfig.supabaseAnonKey,
  //     );
  //     _isInitialized = true;
  //     debugPrint('Supabase initialized successfully');
  //   } catch (e, stackTrace) {
  //     debugPrint('Error initializing Supabase: $e');
  //     debugPrint('Stack trace: $stackTrace');
  //     // Don't mark as initialized if there was an error
  //     _isInitialized = false;
  //     rethrow;
  //   }
  // }
  //
  // /// Check if Supabase is initialized
  // bool get isInitialized => _isInitialized;
}
