import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:flutter_installer/core/fi_theme.dart';
import 'package:flutter_installer/core/fi_window_border.dart';
import 'package:flutter_installer/core/repository/repository.dart';
import 'package:flutter_installer/core/router/fi_router.dart';
import 'package:flutter_installer/customize/bloc/customize_bloc.dart';

class FIApp extends StatefulWidget {
  const FIApp({Key? key}) : super(key: key);

  @override
  State<FIApp> createState() => _FIAppState();
}

class _FIAppState extends State<FIApp> {
  late FIRouter _fiRouter;

  @override
  void initState() {
    super.initState();

    _fiRouter = FIRouter();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _fiRouter.delegate(),
      routeInformationParser: _fiRouter.defaultRouteParser(),
      routeInformationProvider: _fiRouter.routeInfoProvider(),
      theme: FITheme.lightTheme,
      builder: (BuildContext context, Widget? child) {
        return FLWindowBorder(
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider<FIRouter>.value(value: _fiRouter),
            ],
            child: RepositoryProvider<FileSystemRepository>(
              create: (BuildContext context) => FileSystemRepository(),
              child: MultiBlocProvider(
                providers: [
                  BlocProvider<CustomizeBloc>(
                    create: (BuildContext context) {
                      final CustomizeBloc customizeBloc = CustomizeBloc(
                        fileSystemRepository:
                            context.read<FileSystemRepository>(),
                      );
                      customizeBloc.add(const CustomizeInitializeEvent());
                      return customizeBloc;
                    },
                  ),
                ],
                child: child!,
              ),
            ),
          ),
        );
      },
    );
  }
}