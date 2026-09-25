/// Corner-radius scale. Smaller elements get tighter radii, larger
/// containers get softer ones, so nothing in the app looks arbitrarily
/// rounded relative to its neighbors.
class AppRadii {
  AppRadii._();

  static const double xs = 8; // chips, badges
  static const double sm = 12; // inputs, small controls
  static const double md = 16; // buttons, list tiles
  static const double lg = 20; // cards
  static const double xl = 28; // sheets, hero surfaces
}
