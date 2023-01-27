import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/app/core/auth/auth_provider.dart';
import 'package:todo_list_app/app/core/ui/theme_extensions.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Selector<AuthProvider, String>(
        selector: (context, authProvider) =>
            authProvider.user?.displayName ?? 'altere seu nome no Menu',
        builder: (_, value, __) {
          return Text(
            'Olá, $value!',
            style: context.textTheme.headline5
                ?.copyWith(fontWeight: FontWeight.bold),
          );
        },
      ),
    );
  }
}
