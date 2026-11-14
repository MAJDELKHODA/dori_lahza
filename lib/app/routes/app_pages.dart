import 'package:dori_lahza/app/routes/app_routes.dart';
import 'package:dori_lahza/features/account/presentation/bindings/account_bindings.dart';
import 'package:dori_lahza/features/account/presentation/views/edit_profile_view.dart';
import 'package:dori_lahza/features/auth/presentation/bindings/auth_bindings.dart';
import 'package:dori_lahza/features/auth/presentation/views/login_view.dart';
import 'package:dori_lahza/features/auth/presentation/views/register_view.dart';
import 'package:dori_lahza/features/insights/presentation/bindings/busy_hours_binding.dart';
import 'package:dori_lahza/features/insights/presentation/views/busy_hours_view.dart';
import 'package:dori_lahza/features/place/presentation/views/place_info_view.dart';
import 'package:dori_lahza/features/reviews/domain/usecases/reviews_usecases.dart';
import 'package:dori_lahza/features/reviews/presentation/bindings/reviews_binding.dart';
import 'package:dori_lahza/features/reviews/presentation/views/reviews_view.dart';
import 'package:dori_lahza/features/services/presentation/bindings/services_bindings.dart';
import 'package:dori_lahza/features/services/presentation/views/service_details_view.dart';
import 'package:dori_lahza/features/shell/presentation/bindings/shell_binding.dart';
import 'package:dori_lahza/features/shell/presentation/views/shell_view.dart';
import 'package:dori_lahza/features/splash/presentation/bindings/splash_binding.dart';
import 'package:dori_lahza/features/splash/presentation/views/splash_view.dart';
import 'package:dori_lahza/features/staff/presentation/bindings/staff_bindings.dart';
import 'package:dori_lahza/features/staff/presentation/views/staff_profile_view.dart';
import 'package:dori_lahza/features/staff/presentation/views/team_view.dart';
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
    GetPage(name: AppRoutes.shell, page: () => const ShellView(), binding: ShellBinding()),

    // Browsing
    GetPage(
      name: AppRoutes.serviceDetails,
      page: () => ServiceDetailsView(serviceId: _id),
      binding: BindingsBuilder(() => ServiceDetailsBinding(_id).dependencies()),
    ),
    GetPage(name: AppRoutes.team, page: () => const TeamView(), binding: TeamBinding()),
    GetPage(
      name: AppRoutes.staffProfile,
      page: () => StaffProfileView(staffId: _id),
      binding: BindingsBuilder(() => StaffProfileBinding(_id).dependencies()),
    ),
    GetPage(
      name: AppRoutes.placeReviews,
      page: () => const ReviewsView(),
      binding: BindingsBuilder(() => ReviewsBinding(const PlaceReviewsTarget()).dependencies()),
    ),
    GetPage(
      name: AppRoutes.serviceReviews,
      page: () => const ReviewsView(),
      binding: BindingsBuilder(() => ReviewsBinding(Get.arguments as ReviewsTarget).dependencies()),
    ),
    GetPage(name: AppRoutes.busyHours, page: () => const BusyHoursView(), binding: BusyHoursBinding()),
  ];

  /// Integer id passed as the route argument.
  static int get _id => Get.arguments as int;
}
