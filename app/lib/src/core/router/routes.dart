/// Centralised route paths. Use these constants instead of raw strings.
abstract class Routes {
  // Onboarding
  static const splash = '/';
  static const persona = '/onboarding/persona';
  static const family = '/onboarding/family';
  static const diagnostic = '/onboarding/diagnostic';

  // Shell tabs
  static const home = '/home';
  static const finances = '/finances';
  static const familyHub = '/family';
  static const goals = '/goals';
  static const more = '/more';

  // Finance sub-routes
  static const addTransaction = '/finances/add';
  static const cashflow = '/finances/cashflow';
  static const debts = '/finances/debts';

  // Goals sub-routes
  static const createGoal = '/goals/new';
  static const simulator = '/goals/simulator';

  // More / journeys
  static const challenge = '/more/challenge';
  static const academy = '/more/academy';
  static const aiChat = '/more/ai';
  static const patrimony = '/more/patrimony';
  static const score = '/more/score';
  static const settings = '/more/settings';
}
