class Tabs {
  // Main tabs.
  static const int home = 0;
  static const int charging = 1;
  static const int history = 2;
  static const int settings = 3;

  static const List<int> defaultList = [
    home,
    charging,
    history,
    settings,
  ];
  static const List<int> bottomTabs = [ home, charging, history, settings ];
  static const List<String> bottomTabsKeys = [ 'home', 'charging', 'history', 'settings' ];
}
