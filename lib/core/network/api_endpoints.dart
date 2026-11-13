/// Every endpoint of `docs/api/dori-la7za.postman_collection.json`.
abstract final class ApiEndpoints {
  static const baseUrl = 'https://dori.toldpath.com/api/v1';
  static const placeSlug = 'la7za';
  static const _p = '/places/$placeSlug';

  // 1. Splash
  static const ping = '/ping';
  static const place = _p;

  // 2. Browsing
  static const home = '$_p/home';
  static const categories = '$_p/categories';
  static const services = '$_p/services';
  static String service(int id) => '$_p/services/$id';
  static String serviceReviews(int id) => '$_p/services/$id/reviews';
  static const staff = '$_p/staff';
  static String staffMember(int id) => '$_p/staff/$id';
  static const placeReviews = '$_p/reviews';
  static const busyHours = '$_p/insights/busy-hours';

  // 3. Account
  static const register = '$_p/auth/register';
  static const login = '$_p/auth/login';
  static const me = '$_p/auth/me';
  static const profile = '$_p/auth/profile';
  static const logout = '$_p/auth/logout';

  // 4. Booking
  static const availabilityDays = '$_p/availability/days';
  static const availabilitySlots = '$_p/availability/slots';
  static const checkCoupon = '$_p/coupons/check';
  static const bookings = '$_p/bookings';
  static String booking(int id) => '$_p/bookings/$id';
  static String reschedule(int id) => '$_p/bookings/$id/reschedule';
  static String cancelBooking(int id) => '$_p/bookings/$id/cancel';
  static String reviewBooking(int id) => '$_p/bookings/$id/review';

  // 5. Waitlist
  static const waitlist = '$_p/waitlist';
  static String waitlistEntry(int id) => '$_p/waitlist/$id';
  static String claimWaitlist(int id) => '$_p/waitlist/$id/claim';

  // 6. Live queue
  static const queue = '$_p/queue';
  static const queueTickets = '$_p/queue/tickets';
  static const myTicket = '$_p/queue/my-ticket';
  static String cancelTicket(int id) => '$_p/queue/tickets/$id/cancel';

  // 7. Notifications
  static const notifications = '$_p/notifications';
  static const readAllNotifications = '$_p/notifications/read-all';
}
