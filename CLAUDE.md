# CLAUDE.md

Flutter + GetX app «لحظة» for place `la7za` on the Dori platform. Arabic-only, RTL.
Full structure and endpoint map: `README.md`. API reference: `docs/api/dori-la7za.postman_collection.json`
and https://dori.toldpath.com/docs (`/docs/openapi.yaml`, `/docs/collection.json`).

## Commands

```bash
flutter pub get
flutter analyze      # must report "No issues found!" before every commit
flutter test
```

## Architecture rules

- Feature-first Clean Architecture: `lib/features/<feature>/{data,domain,presentation}`.
  `core/` must not import from `features/`. `shared/` holds only small cross-feature entities.
- Flow: View → Controller → UseCase → Repository (interface) → RepositoryImpl → RemoteDataSource → `DioClient`.
- **Repositories** wrap every call in `guard()` (`core/network/guard.dart`) and return `Result<T>`.
  Never throw past a repository. Never `try/catch` in controllers.
- **Data sources** only call `DioClient` and map with the feature's `XModel.fromJson`.
  Models are `abstract final class XModel { static X fromJson(Json) }` that build domain entities.
- **Parse defensively** with `core/utils/json.dart` (`asInt`, `asString`, `asListOf`, …), never hard casts.
  Shapes of the protected (🔒) endpoints are inferred from the docs, not confirmed.
- **Errors:** `Failure` has `code` (`ErrorCodes`), `statusCode`, `details`, `fieldErrors`.
  Map feature-specific codes in the repository impl (see `SlotUnavailableFailure`).
- **State:** expose `Rx<ViewState<T>>` and render it with `StateView` (skeleton / error + retry / empty).
  Paged lists extend `PagedController<T>` and use `PagedListView`.
- **Views** are `GetView`s with no business logic. `StatefulWidget` only for purely local UI state
  (animations, a sheet's in-progress form input).
- **DI:** repositories are registered once in `app/bindings/data_binding.dart` (`lazyPut`, `fenix: true`).
  Controllers go in the feature's `presentation/bindings`. Shell tab controllers are registered by
  `ShellBinding` through each feature's `*Dependencies.registerTab()`.
  Pages that can stack on themselves (service, staff, booking, waitlist entry) use a tag = id,
  and the view overrides `tag`.
- **Navigation:** add the route name in `app_routes.dart`, the `GetPage` in `app_pages.dart`, and a typed
  helper in `app_nav.dart`. Call `AppNav.*`, not `Get.toNamed` with raw arguments.
- **Auth:** guests can browse. Protected actions call `SessionController.ensureSignedIn()` first.
  The token is attached automatically by `AuthInterceptor`.

## UI rules

- All copy is Arabic. Place-type words come from `Get.find<PlaceController>().labels`. Never hard-code
  «طبيب» / «الخدمات» style wording. Prices go through `PlaceController.price()`.
- Colors only through `context.palette` (`AppPalette`). Use `strong` for actions and text on light
  backgrounds, `soft` for tinted surfaces, `brand` for decoration only. Text styles through `context.text`.
- Spacing and radii from `Gap` / `Radii` (`core/theme/app_dimens.dart`). Use the directional variants
  (`EdgeInsetsDirectional`, `PositionedDirectional`, `AlignmentDirectional`). Forward chevrons use
  `Icons.chevron_right_rounded` (it mirrors in RTL).
- Reuse `core/widgets` (`AppCard`, `Pill`, `InfoRow`, `LoadingButton`, `BottomActionBar`, `SheetBody`,
  `AppNetworkImage`, `AppAvatar`, `RatingStars`, `SectionHeader`) before writing new widgets.
- No mock or placeholder data. Every list must handle loading, error, and empty states.

## Adding a feature

1. `domain/entities`, `domain/repositories/<x>_repository.dart` (interface), `domain/usecases`.
2. `data/models` (defensive mapper), `data/datasources/<x>_remote_data_source.dart`,
   `data/repositories/<x>_repository_impl.dart` (everything via `guard`).
3. Register the repository in `DataBinding`. Add the endpoint to `core/network/api_endpoints.dart`.
4. `presentation/controllers`, `bindings`, `views`, `widgets`. Add the route, page, and `AppNav` helper.
5. `flutter analyze` clean, add tests under `test/` for parsing or edge-case logic, then commit.

## Gotchas

- Never call `Get.toNamed<T>` with a non-void `T` (e.g. `<bool>`, `<Booking>`): GetX builds routes as
  `GetPageRoute<dynamic>`, the Navigator's cast to `Route<T?>` throws, and the page silently never opens.
  For pages that return a result use `AppNav.pushForResult<T>()` (covered by `test/navigation_test.dart`).

- `Slot.startsAt` must be sent back unchanged as `starts_at`. Display times come from the API's `time`
  strings, not from converting `DateTime`s (that would shift the offset).
- The live-queue `Poller` runs only while the queue tab is visible and the app is in the foreground.
  The waitlist entry page polls every 30 s while `waiting`, and a `Countdown` drives `seconds_left`.
- Commits are authored by the repository owner only: never add `Co-Authored-By` trailers or other AI attribution.
