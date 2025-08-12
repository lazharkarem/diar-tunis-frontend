import 'package:diar_tunis/features/host/presentation/pages/host_dashboard_page.dart';
import 'package:diar_tunis/features/host/presentation/providers/host_property_provider.dart';
import 'package:diar_tunis/features/properties/domain/repositories/property_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HostDashboardWrapper extends StatelessWidget {
  const HostDashboardWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PropertyRepository>(
          create: (context) => context.read<PropertyRepository>(),
        ),
        ChangeNotifierProvider<HostPropertyProvider>(
          create: (context) => HostPropertyProvider(
            context.read<PropertyRepository>(),
          )..loadProperties(),
        ),
      ],
      child: const HostDashboardPage(),
    );
  }
}
