import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/blocs/settings/bloc.dart';
import 'package:myapp/blocs/settings/event.dart';
import 'package:myapp/blocs/settings/state.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: BlocProvider(
        create: (context) => SettingsBloc(),
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsState) {
              final isDarkMode = state.isDarkMode;
              final isVietnamese = state.isVietnamese;

              return Column(
                children: [
                  SwitchListTile(
                    title: Text('Enable Dark Mode'),
                    value: isDarkMode,
                    onChanged: (_) {
                      BlocProvider.of<SettingsBloc>(context).add(ToggleDarkModeEvent(!isDarkMode));
                    },
                  ),

                  RadioListTile<bool>(
                    title: Text('English'),
                    value: false,
                    groupValue: !isVietnamese,
                    onChanged: (value) {
                      BlocProvider.of<SettingsBloc>(context).add(LanguageChangedEvent(!value!));
                    },
                  ),
                  RadioListTile<bool>(
                    title: Text('Vietnamese'),
                    value: true,
                    groupValue: isVietnamese,
                    onChanged: (value) {
                      BlocProvider.of<SettingsBloc>(context).add(LanguageChangedEvent(value!));
                    },
                  ),
                ],
              );
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
