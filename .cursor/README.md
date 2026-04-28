# CoffeeWeb-App Cursor Skills & Agents

This directory contains specialized skills and agents for the CoffeeWeb-App Flutter project using GetX and MVVM architecture, specifically configured for Cursor IDE.

## 📁 Directory Structure

```
.cursor/
├── skills/
│   ├── generate_feature/
│   │   └── SKILL.md          # Automates feature creation (View + Controller + Binding)
│   ├── generate_model/
│   │   └── SKILL.md          # Generates data models with JSON serialization
│   └── generate_tests/
│       └── SKILL.md          # Creates unit tests for controllers
└── agents/
    ├── reviewer.md           # Architectural review agent
    ├── refactor_assistant.md # Code refactoring agent
    └── debug_helper.md       # Debugging assistance agent
```

## 🎯 Skills

### 1. **generate_feature**
**Purpose**: Automates creation of complete GetX features following the project's exact MVVM + GetX patterns.

**What it creates**:
- Controller extending `BaseController`
- View as `StatelessWidget` with `Get.put()`
- Optional Binding (only when needed)
- Route definitions in `app_routes.dart` and `app_pages.dart`

**Usage**:
```
"Create a new feature called coffee_analytics to show consumption statistics"
```

**Key Features**:
- ✅ Follows exact project naming conventions
- ✅ Uses StatelessWidget (not GetView)
- ✅ Extends BaseController (not GetxController)
- ✅ Automatically updates routing files
- ✅ Includes proper DartDoc comments

---

### 2. **generate_model**
**Purpose**: Generates data models with JSON serialization following project patterns.

**What it creates**:
- Model classes with proper field types
- `fromJson()` factory constructor
- `toJson()` method
- `copyWith()` method for immutability
- Proper null safety

**Usage**:
```
"Create a model for coffee price data with fields: id, price, currency, timestamp"
```

**Key Features**:
- ✅ Handles nested objects
- ✅ Supports lists and collections
- ✅ DateTime parsing
- ✅ Custom JSON key mapping
- ✅ Null-safe implementation

---

### 3. **generate_tests**
**Purpose**: Creates unit tests for controllers following Flutter/GetX testing best practices.

**What it creates**:
- Test file structure with setUp/tearDown
- Mock dependencies using Mockito
- Test cases for initialization, data loading, state management
- Widget tests (optional)

**Usage**:
```
"Generate tests for NotificationsController"
```

**Key Features**:
- ✅ AAA pattern (Arrange-Act-Assert)
- ✅ Mock external dependencies
- ✅ Test reactive state
- ✅ Verify method calls
- ✅ Test error handling

---

## 🤖 Agents

### 1. **reviewer**
**Purpose**: Specialized architectural review agent that audits code for compliance with project patterns.

**What it checks**:
- ✅ Controllers extend `BaseController`
- ✅ Views use `StatelessWidget` (not GetView)
- ✅ Proper dependency injection with `Get.find()`
- ✅ Memory management (onClose implementation)
- ✅ Reactive state usage
- ✅ Error handling patterns
- ✅ Naming conventions
- ✅ Documentation (DartDoc comments)

**Usage**:
```
"Review the NotificationsController for architectural compliance"
```

**Output Format**:
- Summary (Pass/Fail/Needs Improvement)
- Critical Issues (must-fix)
- Warnings (should-fix)
- Suggestions (nice-to-have)
- Positive Feedback
- Next Steps

---

### 2. **refactor_assistant**
**Purpose**: Assists with refactoring code to align with MVVM + GetX patterns.

**Common Refactoring Scenarios**:
1. Converting StatefulWidget to StatelessWidget + GetX
2. Extracting business logic from views
3. Replacing Provider/BLoC with GetX
4. Converting to BaseController pattern
5. Proper dependency injection
6. Memory leak prevention
7. Reactive state management

**Usage**:
```
"Refactor this StatefulWidget to use GetX pattern"
```

**Key Features**:
- ✅ Step-by-step refactoring guide
- ✅ Before/after code examples
- ✅ Refactoring checklist
- ✅ Common pitfalls to avoid
- ✅ Verification steps

---

### 3. **debug_helper**
**Purpose**: Specialized debugging agent for common GetX and Flutter issues.

**Common Issues Covered**:
1. Controller not found errors
2. Reactive variables not updating UI
3. Memory leaks
4. Navigation issues
5. State not persisting
6. API call issues
7. Build context issues
8. Obx() not working
9. Binding issues
10. Performance issues

**Usage**:
```
"Help debug: Obx() not updating when I change the value"
```

**Key Features**:
- ✅ Diagnosis and solutions
- ✅ Debug logging examples
- ✅ GetX debugging tools
- ✅ Debug checklist
- ✅ Verification steps

---

## 🏗️ Architecture Patterns Enforced

All skills and agents enforce these project-specific patterns:

### **Controller Patterns**
```dart
class NotificationsController extends BaseController {
  RxSet<AppNotificationDTO> notificationSet = <AppNotificationDTO>{}.obs;
  RxBool isAPICalling = true.obs;
  
  @override
  Future<void> onInit() async {
    fbServices.setScreenLog(screenName: TrackData.notificationScreen);
    await _getAppNotification();
    super.onInit();
  }
  
  @override
  void onClose() {
    // Cleanup
    super.onClose();
  }
}
```

### **View Patterns**
```dart
class NotificationsView extends StatelessWidget {
  final NotificationsController controller = Get.put(NotificationsController());
  
  NotificationsView({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.notificationSet.isEmpty) {
          return EmptyListOrDataMessage(...);
        }
        return ListView(...);
      }),
    );
  }
}
```

### **Routing Patterns**
```dart
// app_routes.dart
static const notifications = '/notifications';

// app_pages.dart
GetPage(
  name: _Paths.notifications,
  page: () => NotificationsView(),
  middlewares: [AppMiddleware()],
  // binding: only if exists
),
```

---

## 🔍 Important Findings

1. **NO GetView/GetWidget Usage**: Project uses `StatelessWidget` exclusively
2. **BaseController Pattern**: All controllers extend custom `BaseController` (not `GetxController`)
3. **Direct Instantiation**: Controllers use `Get.put()` in views (not bindings for most features)
4. **Bindings are Rare**: Only 1 binding found (`BasePageBinding`), most features don't use them
5. **Reactive State**: Heavy use of `Rx` types (`RxList`, `RxSet`, `RxBool`, etc.)
6. **State Management**: Mix of `Obx()` and `GetBuilder` based on needs
7. **Memory Management**: `onClose()` implementation is critical

---

## 📊 Statistics

- **Analyzed Files**: 30+ controllers, 31+ views, 1 binding
- **Skills Created**: 3
- **Agents Created**: 3
- **Total Documentation**: ~60 KB
- **Coverage**: Complete MVVM + GetX architecture patterns

---

## 🚀 Quick Start

1. **Create a new feature**:
   ```
   "Create a feature called coffee_reports for displaying analytics"
   ```

2. **Review existing code**:
   ```
   "Review the NotificationsController for compliance"
   ```

3. **Debug an issue**:
   ```
   "Help debug: my Obx() widget is not updating"
   ```

4. **Refactor code**:
   ```
   "Refactor this StatefulWidget to use GetX pattern"
   ```

5. **Generate tests**:
   ```
   "Create unit tests for CoffeePriceController"
   ```

---

## 📝 Notes

- **DO NOT** edit or overwrite the existing `./CLAUDE.md` file
- These skills/agents are specific to CoffeeWeb-App architecture
- All patterns are derived from actual codebase analysis
- Excludes `app_playground` directory from analysis
- Follows GEMINI.md guidelines for code quality

---

## 🎓 For Cursor IDE Users

These skills and agents are specifically formatted for Cursor IDE with:
- YAML frontmatter for agent configuration
- `model: auto` for automatic model selection
- Structured markdown for easy parsing
- Clear usage instructions and examples

---

## 📚 Additional Resources

- **Project Documentation**: See `CLAUDE.md` for comprehensive project knowledge
- **Architecture Guidelines**: See `GEMINI.md` for code quality standards
- **Testing Guide**: See individual test skill for testing patterns
- **Debugging Guide**: See debug_helper agent for common issues

---

**Last Updated**: 2026-01-26
**Project**: CoffeeWeb-App
**Architecture**: Flutter + GetX + MVVM
**IDE**: Cursor IDE
