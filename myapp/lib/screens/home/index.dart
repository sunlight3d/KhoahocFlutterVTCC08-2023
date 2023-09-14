import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/blocs/settings/bloc.dart';
import 'package:myapp/blocs/settings/state.dart';
import 'package:myapp/screens/settings/index.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsState) {
            final isDarkMode = state.isDarkMode;
            final isVietnamese = state.isVietnamese;

            return Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Builder(
                          builder: (BuildContext context) {
                            return SettingsScreen();
                          },
                        ),
                      ),
                    );
                  },
                  child: Text('Navigate To Settings'),
                ),
                Text(
                  isVietnamese ? 'Chế độ tối: $isDarkMode' : 'Dark Mode: $isDarkMode',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            );
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }
}

