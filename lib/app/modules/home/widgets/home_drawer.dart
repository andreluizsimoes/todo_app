// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/app/core/auth/auth_provider.dart';
import 'package:todo_list_app/app/core/ui/messages.dart';
import 'package:todo_list_app/app/core/ui/theme_extensions.dart';
import 'package:todo_list_app/app/services/tasks/tasks_service.dart';
import 'package:todo_list_app/app/services/user/user_service.dart';

class HomeDrawer extends StatelessWidget {
  final nameVN = ValueNotifier<String>('');

  HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: context.primaryColor.withAlpha(70),
            ),
            child: Row(
              children: [
                Selector<AuthProvider, String>(
                  selector: (context, authProvider) {
                    return authProvider.user?.photoURL ??
                        'https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png';
                  },
                  builder: (_, value, __) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(value),
                      radius: 30,
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Selector<AuthProvider, String>(
                      selector: (context, authProvider) {
                        return authProvider.user?.displayName ??
                            'Não Informado';
                      },
                      builder: (_, value, __) {
                        return Text(
                          value,
                          style: context.textTheme.subtitle2,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Alterar Nome'),
            onTap: () {
              showDialog(
                context: context,
                useRootNavigator: false,
                builder: (BuildContext dialogContext) {
                  return Scaffold(
                    backgroundColor: Colors.transparent,
                    body: AlertDialog(
                      title: Text('Alterar Nome'),
                      content: TextField(
                        onChanged: (value) => nameVN.value = value,
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.red),
                            )),
                        TextButton(
                            onPressed: () async {
                              final nameValue = nameVN.value;
                              if (nameValue.isNotEmpty) {
                                await context
                                    .read<UserService>()
                                    .updateDisplayName(nameValue);
                                nameVN.value = '';
                                Navigator.of(dialogContext).pop();
                              } else {
                                Messages.of(dialogContext)
                                    .showError('Digite um nome válido!');
                              }
                            },
                            child: Text('Alterar')),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            onTap: () {
              context.read<TasksService>().deleteAll();
              context.read<AuthProvider>().logout();
            },
            title: Text('Sair'),
          ),
        ],
      ),
    );
  }
}
