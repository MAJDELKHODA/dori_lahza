import 'package:dori_lahza/app/routes/app_routes.dart';
import 'package:dori_lahza/features/account/presentation/bindings/account_bindings.dart';
import 'package:dori_lahza/features/account/presentation/views/edit_profile_view.dart';
import 'package:dori_lahza/features/auth/presentation/bindings/auth_bindings.dart';
import 'package:dori_lahza/features/auth/presentation/views/login_view.dart';
import 'package:dori_lahza/features/auth/presentation/views/register_view.dart';
import 'package:dori_lahza/features/place/presentation/views/place_info_view.dart';
import 'package:dori_lahza/features/splash/presentation/bindings/splash_binding.dart';
import 'package:dori_lahza/features/splash/presentation/views/splash_view.dart';
import 'package:get/get.dart';

abstract final class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(name: AppRoutes.splash, page: () => const SplashView(), binding: SplashBinding()),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      fullscreenDialog: true,
    ),
    GetPage(name: AppRoutes.register, page: () => const RegisterView(), binding: RegisterBinding()),
    GetPage(name: AppRoutes.editProfile, page: () => const EditProfileView(), binding: EditProfileBinding()),
    GetPage(name: AppRoutes.placeInfo, page: () => const PlaceInfoView()),
  ];
}
