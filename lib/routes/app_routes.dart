import 'package:get/get.dart';
import '../controllers/home/home_binding.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import '../data/models/booking/booking_model.dart';
import '../screen/main_navigation_screen.dart';
import '../screen/booking/availability_screen.dart';
import '../screen/booking/booking_confirm_screen.dart';
import '../screen/booking/booking_details_screen.dart';
import '../screen/notifications/notifications_screen.dart';
import '../auth/auth_gate_screen.dart';

abstract class AppRoutes {
  AppRoutes._();

  static const login = '/login';
  static const register = '/register';
  static const authGate = '/auth-gate';
  static const main = '/main';
  static const availability = '/availability';
  static const bookingConfirm = '/booking-confirm';
  static const bookingDetails = '/booking-details';
  static const notifications = '/notifications';

  static final pages = <GetPage>[
    GetPage(name: authGate, page: () => const AuthGateScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: register, page: () => const RegisterScreen()),
    GetPage(
      name: main,
      page: () => const MainNavigationScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: availability,
      page: () => AvailabilityScreen(serviceId: Get.arguments as int),
    ),
    GetPage(
      name: AppRoutes.bookingConfirm,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;

        return BookingConfirmScreen(
          serviceId: args['serviceId'] as int,
          startsAt: args['startsAt'] as String,
          staffId: args['staffId'] as int?,
          selectedDate: args['selectedDate'] as String,
          selectedDayLabel: args['selectedDayLabel'] as String,
          selectedTime: args['selectedTime'] as String,
        );
      },
    ),
    GetPage(
      name: AppRoutes.bookingDetails,
      page: () {
        final booking = Get.arguments as BookingModel;

        return BookingDetailsScreen(booking: booking);
      },
    ),
    GetPage(name: notifications, page: () => const NotificationsScreen()),
  ];
}
