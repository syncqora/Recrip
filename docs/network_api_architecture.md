# SaaS — Network API architecture (`lib/network`)

This project follows the same layering as [CoffeeWeb-App `docs/network_api_architecture.md`](../../CoffeeWeb-App/docs/network_api_architecture.md): **UI → Repository → feature `*Services` → `ApiServices` (GetConnect) → HTTP**.

---

## Flow

```
LoginController
      │
      ▼
AuthService (lib/core/services)     ← persists tokens after successful login
      │
      ▼
AuthRepository / AuthRepo             ← lib/network/repo/
      │
      ▼
AuthServices                          ← lib/network/api/
      │
      ▼
ApiServices.callApi()                 ← lib/network/services/api_services.dart
      │
      ▼
GetConnect (package: get)
```

**Note:** Classes under `lib/network/api/` are **not** raw HTTP clients. They call `ApiServices.callApi()` and parse JSON into models.

---

## Folder map

| Location | Role |
|----------|------|
| `lib/network/services/` | `ApiServices` (GetConnect), `ApiEndPoints.baseUrl` |
| `lib/network/endPoints/` | Path constants, e.g. `AuthEndPoints.login`, `AuthEndPoints.revoke`, `AuthEndPoints.introspect` |
| `lib/network/api/` | Feature classes, e.g. `AuthServices` |
| `lib/network/repo/` | `abstract` repository + `AuthRepo` implementation |
| `lib/core/models/<feature>/` | Request/response models (e.g. auth login) |

Barrels: `services/services.dart`, `endPoints/end_points.dart`, `api/api.dart`, `repo/repo.dart`.

---

## Base URL

Set **`ApiEndPoints.baseUrl`** before the first HTTP call (e.g. in a flavor `main_*.dart` or at the start of `initializeApp()` in `lib/main.dart`). Default: `http://localhost:8080`.

---

## Errors

- **`ApiException`** — non-2xx or error payload from `ApiServices.callApi` (via `ErrorHandler`).
- **`JSONException`** — parse failures in feature `*Services` classes.

Defined in `lib/shared/utils/app_exceptions.dart`.

---

## DI (`lib/core/di/get_injector.dart`)

On cold start, `BasePageController.setDefaultLanding()` calls `POST /auth/introspect` when an access token is stored; if `active` is true, the user is sent to the dashboard.

Registered **permanent** instances:

- `ApiServices`
- `AuthRepository` → `AuthRepo(services: AuthServices())`
- `AuthService` (app/session layer)

---

## Checklist: new endpoint

1. Add path under `lib/network/endPoints/…` and export from `end_points.dart`.
2. Add models under `lib/core/models/…` if needed.
3. Add methods on a feature class in `lib/network/api/…` using `Get.find<ApiServices>().callApi(...)`.
4. Extend abstract repository + `…Repo` in `lib/network/repo/`.
5. Export from `api/api.dart` and `repo/repo.dart` if using barrels.
