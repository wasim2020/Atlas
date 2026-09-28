// Public site configuration. The Supabase "anon" key is designed to be public;
// security comes from the database's row-level security policies (see supabase/feedback.sql).
window.ATLAS_CONFIG = {
  feedback: {
    url: "",      // e.g. "https://abcdefghijk.supabase.co"
    anonKey: ""   // Supabase project's anon / publishable key
  }
};
