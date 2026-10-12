class Tabs {
  // Main tabs.
  static const int home = 0;
  static const int charging = 1;
  static const int history = 2;
  static const int settings = 3;

  // My profile.
  static const int userName = 1;
  static const int updatePassword = 2;

  static const List<int> defaultList = [
    home,
    charging,
    history,
    settings,
  ];

  static const List<int> bottomTabs = [ home, charging, history, settings ];
  static const List<String> bottomTabsKeys = [ 'home', 'charging', 'history', 'settings' ];

  static const List<int> myProfileTabs = [ home, userName, updatePassword ];
  static const List<String> myProfileTabsKeys = [ 'my_profile', 'data_edit', 'password_change' ];
}
