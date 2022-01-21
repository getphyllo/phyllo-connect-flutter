enum PhylloEnvironment {
  ///
  development,

  /// Use Sandbox mode to build and test your integration.
  /// In this mode, you must use the test credentials provided to log into platforms.
  /// All API endpoints will return mocked data and no changes are made to any account.
  sandbox,

  /// Use Production mode to go live with your integration.
  /// On production, your users will need to use their real credentials to log in to the diferent platforms.
  /// API endpoints return real data and updates are made to accounts. Note that all API calls are billable in this mode.
  production
}
