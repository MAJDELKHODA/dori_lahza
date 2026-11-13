class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'https://dori.toldpath.com/api/v1';

  // Place Slug
  static const String placeSlug = 'la7za';

  // Place Information
  static String get place => '/places/$placeSlug';

  // Home
  static String get home => '/places/$placeSlug/home';

  // Categories
  static String get categories => '/places/$placeSlug/categories';

  // Services
  static String get services => '/places/$placeSlug/services';
  static String serviceDetails(int serviceId) =>
      '/places/$placeSlug/services/$serviceId';

  // Staff
  static String get staff => '/places/$placeSlug/staff';

  // Authentication
  static String get login => '/places/$placeSlug/auth/login';

  static String get register => '/places/$placeSlug/auth/register';

  static String get profile => '/places/$placeSlug/auth/me';

  static String get logout => '/places/$placeSlug/auth/logout';

  // Bookings
  static String get bookings => '/places/$placeSlug/bookings';
  static String availabilityDays(int serviceId) =>
      '/places/$placeSlug/availability/days';
  static const String availabilitySlots =
      '/places/$placeSlug/availability/slots';
  // profile
  static String get updateProfile => '/places/$placeSlug/auth/profile';
}
