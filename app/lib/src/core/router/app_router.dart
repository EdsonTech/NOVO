import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ai/presentation/ai_chat_screen.dart';
import '../../features/ai/presentation/receipt_scan_screen.dart';
import '../../features/challenge/presentation/challenge_screen.dart';
import '../../features/dashboard/presentation/home_screen.dart';
import '../../features/family/presentation/family_screen.dart';
import '../../features/finances/presentation/add_transaction_screen.dart';
import '../../features/finances/presentation/cashflow_screen.dart';
import '../../features/finances/presentation/debts_screen.dart';
import '../../features/finances/presentation/finances_screen.dart';
import '../../features/goals/presentation/create_goal_screen.dart';
import '../../features/goals/presentation/goals_screen.dart';
import '../../features/goals/presentation/simulator_screen.dart';
import '../../features/more/presentation/journey_placeholder_screen.dart';
import '../../features/more/presentation/more_screen.dart';
import '../../features/onboarding/presentation/diagnostic_screen.dart';
import '../../features/onboarding/presentation/family_situation_screen.dart';
import '../../features/onboarding/presentation/persona_screen.dart';
import '../../features/onboarding/presentation/splash_screen.dart';
import '../widgets/maju_shell.dart';
import 'routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(path: Routes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: Routes.persona, builder: (_, __) => const PersonaScreen()),
      GoRoute(
        path: Routes.family,
        builder: (_, __) => const FamilySituationScreen(),
      ),
      GoRoute(
        path: Routes.diagnostic,
        builder: (_, __) => const DiagnosticScreen(),
      ),
      GoRoute(
        path: Routes.addTransaction,
        builder: (_, state) =>
            AddTransactionScreen(isIncome: state.uri.queryParameters['type'] == 'income'),
      ),
      GoRoute(path: Routes.cashflow, builder: (_, __) => const CashflowScreen()),
      GoRoute(path: Routes.debts, builder: (_, __) => const DebtsScreen()),
      GoRoute(path: Routes.createGoal, builder: (_, __) => const CreateGoalScreen()),
      GoRoute(path: Routes.simulator, builder: (_, __) => const SimulatorScreen()),

      // Desafio 1 Milhão (implementado)
      GoRoute(path: Routes.challenge, builder: (_, __) => const ChallengeScreen()),

      // MAJU IA (implementado): chat + digitalizar comprovante
      GoRoute(path: Routes.aiChat, builder: (_, __) => const AiChatScreen()),
      GoRoute(path: Routes.aiScan, builder: (_, __) => const ReceiptScanScreen()),

      // Journeys scaffolded as placeholders (owned by later sprints).
      GoRoute(path: Routes.academy, builder: (_, __) => const JourneyPlaceholderScreen(title: 'Academia MAJU', sprint: 'Sprint 8', icon: Icons.school_outlined)),
      GoRoute(path: Routes.patrimony, builder: (_, __) => const JourneyPlaceholderScreen(title: 'Meus Activos', sprint: 'Sprint 10', icon: Icons.home_outlined)),
      GoRoute(path: Routes.score, builder: (_, __) => const JourneyPlaceholderScreen(title: 'Score MAJU', sprint: 'Sprint 11', icon: Icons.star_outline)),
      GoRoute(path: Routes.settings, builder: (_, __) => const JourneyPlaceholderScreen(title: 'Configurações', sprint: 'Sprint 2', icon: Icons.settings_outlined)),

      // Bottom-tab shell (Início · Finanças · Família · Sonhos · Mais)
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => MajuShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.home, builder: (_, __) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.finances,
              builder: (_, __) => const FinancesScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.familyHub,
              builder: (_, __) => const FamilyScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.goals, builder: (_, __) => const GoalsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.more, builder: (_, __) => const MoreScreen()),
          ]),
        ],
      ),
    ],
  );
});
