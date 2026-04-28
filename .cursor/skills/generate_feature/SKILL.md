---
name: generate_feature
description: Automates creation of a complete GetX feature/module (View + Controller + optional Binding) following the project's exact MVVM + GetX architecture patterns
---

# Generate Feature Skill

This skill automates the creation of a new GetX feature/module that perfectly matches the CoffeeWeb-App's existing architecture, patterns, and conventions.

## Architecture Analysis

Based on the codebase analysis, this project follows these patterns:

### Folder Structure
- **Features Location**: `lib/app/{feature_name}/`
- **Controllers**: `{feature_name}_controller.dart` (extends `BaseController`)
- **Views**: `{feature_name}_view.dart` (typically `StatelessWidget`)
- **Bindings**: `{feature_name}_binding.dart` (implements `Bindings`) - **OPTIONAL**, only used for complex features
- **Models**: `{feature_name}_model.dart` (if needed)

### View Patterns
- **Primary Pattern**: `StatelessWidget` with `Get.put()` for controller instantiation
- **Controller Access**: Direct instantiation in view: `final {FeatureName}Controller controller = Get.put({FeatureName}Controller());`
- **NOT USED**: `GetView<T>` or `GetWidget<T>` (these are rarely used in this codebase)
- **State Management**: Mix of `Obx()` for reactive widgets and `GetBuilder` for non-reactive updates

### Controller Patterns
- **Base Class**: All controllers extend `BaseController` (from `lib/shared/utils/base_controller.dart`)
- **Lifecycle**: Implement `onInit()`, `onReady()`, `onClose()` as needed
- **State Management**: Use `Rx` types for reactive state (`.obs`, `RxString`, `RxBool`, `RxList`, etc.)
- **Dependency Injection**: Use `Get.find<T>()` for accessing existing controllers/services
- **Memory Management**: Always dispose reactive variables in `onClose()`

### Routing Patterns
- **Routes File**: `lib/routes/app_pages.dart`
- **Route Definition**: Add to `AppPages.routes` list as `GetPage`
- **Path Definition**: Add to `_Paths` class in `lib/routes/app_routes.dart`
- **Route Access**: Add to `AppRoutes` class in `lib/routes/app_routes.dart`
- **Middleware**: Most routes use `AppMiddleware()`, auth-protected routes use `AuthMiddleware()`
- **Binding**: Only add `binding:` parameter if the feature has a dedicated binding file

### Naming Conventions
- **Controllers**: `{FeatureName}Controller` (PascalCase, no underscores)
- **Views**: `{FeatureName}View` (PascalCase)
- **Bindings**: `{FeatureName}Binding` (PascalCase)
- **Files**: `{feature_name}_controller.dart`, `{feature_name}_view.dart` (snake_case)
- **Routes**: `/feature_name` (kebab-case for paths)

### Common Imports
Controllers typically import:
```dart
import 'package:get/get.dart';
import '../../shared/utils/base_controller.dart';
import '../../core/di/get_injector.dart'; // For accessing services
import '../../shared/shared.dart'; // Common utilities
```

Views typically import:
```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '{feature_name}_controller.dart';
```

## Usage Instructions

When asked to generate a new feature, follow these steps:

### Step 1: Gather Requirements
Ask the user for:
1. **Feature name** (e.g., "coffee_analytics", "user_settings")
2. **Description** of what the feature does
3. **Whether it needs a binding** (default: NO, only for complex features with multiple dependencies)
4. **Whether it needs authentication** (determines middleware)
5. **Any specific reactive state** needed (lists, booleans, strings, etc.)

### Step 2: Create Controller
Generate `lib/app/{feature_name}/{feature_name}_controller.dart`:

```dart
import 'package:get/get.dart';

import '../../shared/utils/base_controller.dart';
import '../../core/di/get_injector.dart';

/// Controller for {FeatureName} feature
/// Manages state and business logic for {description}
class {FeatureName}Controller extends BaseController {
  // Reactive state variables
  // Example: RxList<Item> items = <Item>[].obs;
  // Example: RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize data, set up listeners, etc.
  }

  @override
  void onReady() {
    super.onReady();
    // Called after the widget is rendered
  }

  @override
  void onClose() {
    // Dispose of reactive variables and clean up resources
    super.onClose();
  }
}
```

### Step 3: Create View
Generate `lib/app/{feature_name}/{feature_name}_view.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '{feature_name}_controller.dart';

/// View for {FeatureName} feature
/// {Description}
class {FeatureName}View extends StatelessWidget {
  final {FeatureName}Controller controller = Get.put({FeatureName}Controller());

  {FeatureName}View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('{Feature Name}'),
      ),
      body: Obx(() {
        // Reactive UI based on controller state
        return Center(
          child: Text('Implement {Feature Name} UI here'),
        );
      }),
    );
  }
}
```

### Step 4: Create Binding (ONLY if needed)
Generate `lib/app/{feature_name}/{feature_name}_binding.dart` **ONLY** if the feature has complex dependencies:

```dart
import 'package:get/get.dart';

import '{feature_name}_controller.dart';

/// Binding for {FeatureName} feature
/// Handles dependency injection for this feature
class {FeatureName}Binding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<{FeatureName}Controller>(() => {FeatureName}Controller());
  }
}
```

### Step 5: Update Routes
1. **Add to `lib/routes/app_routes.dart`** in the `_Paths` class:
```dart
static const {featureName} = '/{feature_name}';
```

2. **Add to `lib/routes/app_routes.dart`** in the `AppRoutes` class:
```dart
static const {featureName} = _Paths.{featureName};
```

3. **Add import to `lib/routes/app_pages.dart`**:
```dart
import '../app/{feature_name}/{feature_name}_view.dart';
// If binding exists:
import '../app/{feature_name}/{feature_name}_binding.dart';
```

4. **Add route to `lib/routes/app_pages.dart`** in the `AppPages.routes` list:
```dart
GetPage(
  name: _Paths.{featureName},
  page: () => {FeatureName}View(),
  middlewares: [AppMiddleware()], // or [AuthMiddleware()] if auth required
  // Only add binding if it exists:
  // binding: {FeatureName}Binding(),
),
```

### Step 6: Verify and Report
After generating all files:
1. Run `flutter analyze` to check for errors
2. Provide a summary of created files
3. Show the route path for navigation: `AppRoutes.{featureName}`
4. Suggest next steps (implement business logic, add UI components, etc.)

## Important Notes

1. **DO NOT** create bindings unless specifically requested or the feature has complex dependencies
2. **ALWAYS** extend `BaseController` for controllers
3. **ALWAYS** use `StatelessWidget` for views (not `GetView` or `GetWidget`)
4. **ALWAYS** instantiate controller with `Get.put()` directly in the view
5. **ALWAYS** add proper DartDoc comments (`///`) for classes and methods
6. **ALWAYS** dispose reactive variables in `onClose()`
7. **FOLLOW** the exact naming conventions (PascalCase for classes, snake_case for files)
8. **USE** `Obx()` for reactive UI updates, `GetBuilder` for non-reactive updates
9. **IMPORT** from `package:` paths, not relative paths for core modules

## Example Usage

**User**: "Create a new feature called coffee_analytics to show coffee consumption statistics"

**Agent Response**:
1. Create `lib/app/coffee_analytics/coffee_analytics_controller.dart`
2. Create `lib/app/coffee_analytics/coffee_analytics_view.dart`
3. Update `lib/routes/app_routes.dart` (add path and route constant)
4. Update `lib/routes/app_pages.dart` (add import and GetPage)
5. Verify with `flutter analyze`
6. Report: "Feature created! Navigate using `Get.toNamed(AppRoutes.coffeeAnalytics)`"

## Error Prevention

- **Check** if feature name already exists before creating
- **Validate** that feature name follows snake_case convention
- **Ensure** all imports use correct paths
- **Verify** that route paths don't conflict with existing routes
- **Confirm** that controller extends BaseController
- **Check** that view uses StatelessWidget (not GetView)
