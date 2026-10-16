class Tabs {
  // Main tabs.
  static const int home = 0;
  static const int charging = 1;
  static const int history = 2;
  static const int settings = 3;

  // Link charger.
  static const int linkStart = 0;
  static const int linkSelectCharger = 1;
  static const int linkSelectNetwork = 2;
  static const int linkConnecting = 3;
  static const int linkConnected = 4;

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

  static const List<int> linkTabs = [ linkStart, linkSelectCharger, linkSelectNetwork, linkConnecting, linkConnected ];
  static const List<int> linkStepTabs = [ linkStart, linkSelectCharger, linkSelectNetwork, linkConnecting ];
  static const List<String> linkTabsKeys = [ 'charger_link_title', 'charger_link_select', 'charger_link_wifi', 'connecting', '' ];

  static const List<int> myProfileTabs = [ home, userName, updatePassword ];
  static const List<String> myProfileTabsKeys = [ 'my_profile', 'data_edit', 'password_change' ];
}
