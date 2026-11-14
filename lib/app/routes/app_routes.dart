/// Route names. Pages are registered in `app_pages.dart`.
abstract final class AppRoutes {
  static const splash = '/';
  static const shell = '/main';

  // Auth & account
  static const login = '/login';
  static const register = '/register';
  static const editProfile = '/account/edit';
  static const placeInfo = '/place';

  // Browsing
  static const services = '/services';
  static const serviceDetails = '/services/details';
  static const team = '/team';
  static const staffProfile = '/team/profile';
  static const placeReviews = '/reviews';
  static const serviceReviews = '/services/reviews';
  static const busyHours = '/insights/busy-hours';

  // Booking
  static const bookingSlots = '/booking/slots';
  static const bookingConfirm = '/booking/confirm';
  static const bookingDetails = '/bookings/details';
  static const reschedule = '/bookings/reschedule';

  // Waitlist & queue
  static const waitlist = '/waitlist';
  static const waitlistEntry = '/waitlist/entry';

  // Notifications
  static const notifications = '/notifications';
}
