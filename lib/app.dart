import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmf/core/theme/app_theme.dart';
import 'core/di/injection_container.dart' as di;
import 'presentation/cubits/main_form_cubit.dart';
import 'presentation/pages/mahalla_form.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<MainFormCubit>(),
      child: MaterialApp(
        title: 'Mahalla Members Form',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MahallaForm(),
      ),
    );
  }
}