# GetX feature screen — reusable structure template

Use this blueprint when adding a tab or full screen with **GetX**, **MVVM-style separation**, reactive lists, and optional overlays / pull-to-refresh.

**Reference implementation in this repo:** `lib/app/subscriptions/` (`SubscriptionsBinding`, `SubscriptionsController`, `SubscriptionsView`, `widgets/`).

---

## Recommended directory layout

```
lib/
├── app/
│   └── {feature_name}/
│       ├── {feature_name}_view.dart
│       ├── {feature_name}_controller.dart
│       ├── {feature_name}_binding.dart
│       └── widgets/
├── network/
└── shared/
```

## Controller

- `RxList<T>`, `RxBool isLoading`, `ScrollController` (dispose in `onClose`)
- `loadInitialData()` + `refreshView()` for `RefreshIndicator` / retry
- Side effects only in controller; inject repos via `Get.find`

## Binding (shell / tabs)

- `Get.lazyPut<FeatureController>(..., fenix: true)` inside `ensureRegistered()` so the first `Get.find` / `GetView` creates the controller and tab swaps do not require matching `Get.delete` mid-request.

## View

- **StatefulWidget** shell when the parent destroys the tab each time: `initState` → `Binding.ensureRegistered()` + `addPostFrameCallback` → `refreshView()` so each visit refetches.
- **GetView<FeatureController>** for the body; wrap reactive subtrees in `Obx`.
- **RefreshIndicator** + `AlwaysScrollableScrollPhysics` when using a `ScrollController`.

## Checklist

- [ ] `onClose` disposes `ScrollController`, timers, subscriptions  
- [ ] `Obx` reads `.obs` / `Rx` inside the builder  
- [ ] Pull-to-refresh calls `controller.refreshView()`  

Version: 1.0  
