# لحظة — تطبيق حجز المواعيد

تطبيق Flutter لعملاء منشأة **la7za** على منصة **دوري**: تصفّح الخدمات، حجز المواعيد،
قائمة الانتظار الذكية، والدور الحي. واجهة عربية كاملة (RTL) بخط IBM Plex Sans Arabic،
وألوان التطبيق تُؤخذ من إعدادات المنشأة.

- **الـ API:** `https://dori.toldpath.com/api/v1/places/la7za`
- **مرجع الطلبات:** [`docs/api/dori-la7za.postman_collection.json`](docs/api/dori-la7za.postman_collection.json)
- **التوثيق التفاعلي:** https://dori.toldpath.com/docs

## التشغيل

```bash
flutter pub get
flutter run
```

```bash
flutter analyze
flutter test
```

## الميزات

| الشاشة | الـ endpoints |
|---|---|
| البداية (Splash) | `GET /ping`، `GET /places/{slug}` (الاسم، الألوان، `labels`، ساعات العمل، قواعد الحجز، `intake_fields`) |
| الرئيسية | `GET /home` (بانرات، تصنيفات، مميّزة، الأكثر طلبًا، الفريق، آخر التقييمات، حالة الدور) |
| الخدمات | `GET /categories`، `GET /services` (بحث `q`، تصنيف، شخص، مدة قصوى، مميّزة، جماعية، ترتيب، صفحات) |
| تفاصيل خدمة | `GET /services/{id}`، `GET /services/{id}/reviews` |
| الفريق وملف الشخص | `GET /staff`، `GET /staff/{id}` |
| التقييمات | `GET /reviews` (المتوسط، `distribution`، فلترة بالنجوم) |
| أفضل وقت للزيارة | `GET /insights/busy-hours` (الحالة الآن، أهدأ الأوقات، خريطة حرارية) |
| الحساب | `register`، `login`، `me` (مع `reliability`)، `PUT profile`، `logout` |
| الحجز | `availability/days`، `availability/slots`، `coupons/check`، `POST /bookings` (مع `SLOT_UNAVAILABLE` والبدائل) |
| حجوزاتي | `GET /bookings?scope=upcoming|past`، التفاصيل (QR والمراحل)، `reschedule`، `cancel`، `review` |
| قائمة الانتظار | `POST /waitlist`، القائمة، الحالة مع عدّاد `seconds_left`، `claim`، `DELETE` |
| الدور الحي | `GET /queue` (تحديث كل 20 ثانية)، `POST /queue/tickets`، `my-ticket`، إلغاء الرقم |
| الإشعارات | `GET /notifications`، `read-all`، التنقل حسب `url` |

يستطيع الزائر التصفّح بدون حساب. أي إجراء محمي (حجز، كوبون، انتظار، رقم في الدور) يفتح
تسجيل الدخول أولًا ثم يكمل من حيث توقف.

## الهيكلة

Clean Architecture مقسّمة حسب الميزة (feature-first) مع GetX لإدارة الحالة والتنقل وحقن الاعتماديات.

```
lib/
├── main.dart                 تهيئة التواريخ العربية وتشغيل التطبيق
├── app/
│   ├── app.dart              GetMaterialApp: اللغة، الثيم، الصفحات
│   ├── bindings/             InitialBinding (الشبكة، المنشأة، الجلسة) و DataBinding (كل الـ repositories)
│   └── routes/               app_routes (الأسماء)، app_pages (الصفحات)، app_nav (تنقل بأنواع واضحة)
├── core/                     بنية مشتركة، لا تعرف شيئًا عن الميزات
│   ├── network/              DioClient، interceptors (توكن + أخطاء)، AppException، guard()
│   ├── error/                Failure و ErrorCodes
│   ├── result/               Result<T> = Success | FailureResult
│   ├── usecase/              UseCase<T, Params>
│   ├── pagination/           Paginated<T> من data + meta
│   ├── state/                ViewState<T> و PagedController<T>
│   ├── storage/              TokenStorage (آمن)
│   ├── theme/                AppPalette (من لون المنشأة)، AppTheme، المسافات والزوايا
│   ├── utils/                قراءة JSON بأمان، التنسيق، الرسائل، polling و countdown
│   └── widgets/              skeleton، StateView، الخطأ والفارغ، PagedListView، بطاقات وأزرار
├── shared/                   كيانات صغيرة تستخدمها عدة ميزات (RatingSummary، DayHours، StaffBrief)
└── features/<feature>/
    ├── data/
    │   ├── datasources/      طلبات الـ API فقط
    │   ├── models/           تحويل JSON إلى كيانات
    │   └── repositories/     تنفيذ الـ repository، كل استدعاء داخل guard()
    ├── domain/
    │   ├── entities/         كائنات Dart خالصة
    │   ├── repositories/     الواجهات (abstract interface)
    │   └── usecases/         إجراء واحد لكل use case
    └── presentation/
        ├── bindings/         تسجيل الـ controllers
        ├── controllers/      GetxController: الحالة والمنطق
        ├── views/            الشاشات (GetView)، عرض فقط
        └── widgets/          مكونات الميزة
```

الميزات: `splash`، `place`، `auth`، `account`، `shell`، `home`، `services`، `staff`، `reviews`،
`insights`، `booking` (خطوات الحجز)، `bookings` (حجوزاتي)، `waitlist`، `queue`، `notifications`.

### مسار الطلب

```
View ──Obx──> Controller ──> UseCase ──> Repository (interface)
                                              │
                         RepositoryImpl ──guard()──> RemoteDataSource ──> DioClient
                                                                            │
                                     AuthInterceptor (Bearer) → ErrorInterceptor (envelope → AppException)
```

- **النجاح:** `DioClient` يفك `{ success, message, data, meta }` إلى `ApiResponse`.
- **الخطأ:** `{ success:false, message, error:{code, details} }` يصير `AppException` ثم `Failure`.
  ما في `try/catch` داخل الـ controllers.
- **401 مع توكن:** يُمسح التوكن ويخرج المستخدم من الجلسة، ويظهر تنبيه.
- **422:** `failure.fieldErrors` تظهر تحت الحقول.
- **أخطاء خاصة بالميزات:** `SLOT_UNAVAILABLE` يتحول إلى `SlotUnavailableFailure(alternatives)`
  داخل الـ repository، و `SLOT_TAKEN` يُقرأ من `failure.code`.

### حالات الشاشة

كل مورد غير متزامن هو `Rx<ViewState<T>>`، ويُعرض بـ `StateView`:
**skeleton** بنفس شكل المحتوى، و**خطأ** مع إعادة المحاولة، و**فارغ** برسالة مناسبة.
القوائم المقسّمة لصفحات ترث `PagedController<T>` وتُعرض بـ `PagedListView`، وفيها سحب للتحديث،
وتحميل الصفحة التالية تلقائيًا، وإعادة محاولة في آخر القائمة.

### النصوص والثيم

- كل الكلمات المرتبطة بنوع المنشأة تأتي من `PlaceController.labels`
  (مثل «مقدّم الخدمة»، «الخدمات»، «موعد»).
- `theme.primary_color` يبني `AppPalette`. لأن لون المنشأة فاتح (`#94DDF0`)، يُشتق منه لون
  `strong` أغمق للأزرار والنصوص حتى يكون مقروءًا (تباين 4.5:1)، ويبقى `brand` للخلفيات.
- الاتجاه RTL بالكامل: `EdgeInsetsDirectional` و `PositionedDirectional`، وأيقونات تنقلب حسب الاتجاه.

## ملاحظات

- الـ collection ما فيها أمثلة ردود للطلبات المحمية (🔒)، فالـ models مبنية من وصف التوثيق
  وتقرأ الحقول بشكل دفاعي (`core/utils/json.dart`). بعد تجربة حساب حقيقي، طابق أي حقل
  مختلف داخل ملف الـ model الخاص به.
- صور `uploads/` على الخادم ما فيها CORS headers، فلا تظهر في نسخة الويب فقط.
  على Android و iOS تظهر بشكل طبيعي.
