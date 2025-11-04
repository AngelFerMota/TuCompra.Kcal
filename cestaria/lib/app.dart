import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/product_search/product_search_screen.dart';
import 'features/cart/cart_screen.dart';
import 'features/shared_cart/shared_cart_screen.dart';
import 'features/history/history_screen.dart';
import 'features/settings/settings_screen.dart';

class App extends StatelessWidget {
	const App({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp.router(
			title: 'Cestaria',
			theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
			routerConfig: _router,
		);
	}
}

final GoRouter _router = GoRouter(
	initialLocation: '/search',
	routes: [
		ShellRoute(
			builder: (context, state, child) => _AppShell(child: child),
			routes: [
				GoRoute(
					path: '/search',
					name: 'search',
					builder: (context, state) => const ProductSearchScreen(),
				),
				GoRoute(
					path: '/cart',
					name: 'cart',
					builder: (context, state) => const CartScreen(),
				),
				GoRoute(
					path: '/shared',
					name: 'shared',
					builder: (context, state) => const SharedCartScreen(),
				),
				GoRoute(
					path: '/history',
					name: 'history',
					builder: (context, state) => const HistoryScreen(),
				),
				GoRoute(
					path: '/settings',
					name: 'settings',
					builder: (context, state) => const SettingsScreen(),
				),
			],
		),
	],
);

class _AppShell extends StatelessWidget {
	const _AppShell({required this.child});
	final Widget child;

	static const _tabs = [
		_TabMeta('/search', Icons.search, 'Buscar'),
		_TabMeta('/cart', Icons.shopping_cart_outlined, 'Carrito'),
		_TabMeta('/shared', Icons.group_outlined, 'Compartido'),
		_TabMeta('/history', Icons.history, 'Historial'),
		_TabMeta('/settings', Icons.settings_outlined, 'Ajustes'),
	];

	int _indexFromLocation(BuildContext context) {
		final loc = GoRouterState.of(context).uri.toString();
		final idx = _tabs.indexWhere((t) => loc.startsWith(t.path));
		return idx == -1 ? 0 : idx;
	}

	@override
	Widget build(BuildContext context) {
		final index = _indexFromLocation(context);
		return Scaffold(
			// AppBar global; las pantallas internas ya incluyen AppBar propio si lo prefieres,
			// pero para evitar doble AppBar, dejamos sólo el body del child.
			body: child,
			bottomNavigationBar: NavigationBar(
				selectedIndex: index,
				onDestinationSelected: (i) => context.go(_tabs[i].path),
				destinations: [
					for (final t in _tabs)
						NavigationDestination(icon: Icon(t.icon), label: t.label),
				],
			),
		);
	}
}

class _TabMeta {
	const _TabMeta(this.path, this.icon, this.label);
	final String path;
	final IconData icon;
	final String label;
}
