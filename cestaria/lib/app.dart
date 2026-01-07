import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';

class App extends ConsumerWidget {
	const App({super.key});

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final router = ref.watch(routerProvider);
		
		return MaterialApp.router(
			title: 'Cestaria',
			theme: ThemeData(
				colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
				useMaterial3: true,
			),
			routerConfig: router,
		);
	}
}
