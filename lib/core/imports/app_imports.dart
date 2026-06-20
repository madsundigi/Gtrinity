// Dart
export 'dart:io';
export 'dart:async';

// Flutter & Third-party Packages
export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:dio/dio.dart';
export 'package:equatable/equatable.dart';
export 'package:get_it/get_it.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:nested/nested.dart';
export 'package:flutter_svg/flutter_svg.dart';

// Core - Constants
export 'package:chef_king/core/constants/api_constants.dart';
export 'package:chef_king/core/constants/app_strings.dart';
export 'package:chef_king/core/constants/app_colors.dart';
export 'package:chef_king/core/constants/app_assets.dart';

// Core - Theme
export 'package:chef_king/core/theme/app_theme.dart';

// Core - Extensions
export 'package:chef_king/core/extensions/context_extensions.dart';

// Core - DI
export 'package:chef_king/core/di/injection.dart';

// Core - Bloc Providers
export 'package:chef_king/core/bloc/bloc_providers.dart';

// Core - Routes
export 'package:chef_king/core/routes/app_routes.dart';
export 'package:chef_king/core/routes/app_router.dart';

// Core - Common Widgets
export 'package:chef_king/core/common/ck_text.dart';
export 'package:chef_king/core/common/ck_button.dart';
export 'package:chef_king/core/common/ck_input_field.dart';
export 'package:chef_king/core/common/ck_list_view_builder.dart';
export 'package:chef_king/core/common/ck_base_screen.dart';
export 'package:chef_king/core/common/ck_image.dart';
export 'package:chef_king/core/common/ck_overlay_loader.dart';
export 'package:chef_king/core/common/ck_snackbar.dart';

// Data - Local
export 'package:chef_king/data/local/app_cache/app_cache.dart';

// Data - Remote
export 'package:chef_king/data/remote/api_client.dart';

// Domain
export 'package:chef_king/domain/usecases/auth/AuthUseCase.dart';

// Presentation - BLocs
export 'package:chef_king/presentation/main/bloc/main_bloc.dart';
export 'package:chef_king/presentation/main/bloc/main_event.dart';
export 'package:chef_king/presentation/main/bloc/main_state.dart';
export 'package:chef_king/presentation/splash/bloc/splash_bloc.dart';
export 'package:chef_king/presentation/auth/bloc/auth_bloc.dart';
export 'package:chef_king/presentation/auth/bloc/forgot_password_bloc.dart';
export 'package:chef_king/presentation/home/bloc/home_bloc.dart';
export 'package:chef_king/presentation/home/bloc/home_event.dart';
export 'package:chef_king/presentation/home/bloc/home_state.dart';

// Presentation - Screens & Widgets
export 'package:chef_king/presentation/main/main_screen.dart';
export 'package:chef_king/presentation/home/home_screen.dart';
export 'package:chef_king/presentation/splash/splash_screen.dart';
export 'package:chef_king/presentation/splash/widget/splash_body.dart';
export 'package:chef_king/presentation/auth/login_screen.dart';
export 'package:chef_king/presentation/auth/forgot_password_screen.dart';
export 'package:chef_king/presentation/auth/widget/login_body.dart';

// App Root
export 'package:chef_king/app.dart';
