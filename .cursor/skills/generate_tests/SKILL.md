---
name: generate_tests
description: Generates unit tests for controllers following the project's testing patterns
---

# Generate Tests Skill

This skill automates the creation of unit tests for GetX controllers following Flutter and GetX testing best practices.

## Testing Patterns in This Project

### Test File Location
- **Controller Tests**: `test/{feature}/{feature}_controller_test.dart`
- **Widget Tests**: `test/{feature}/{feature}_view_test.dart`
- **Integration Tests**: `integration_test/`

### Common Test Structure
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:coffee_web/app/{feature}/{feature}_controller.dart';

void main() {
  late {FeatureName}Controller controller;

  setUp(() {
    // Initialize GetX test mode
    Get.testMode = true;
    
    // Create controller instance
    controller = {FeatureName}Controller();
  });

  tearDown(() {
    // Clean up
    controller.onClose();
    Get.reset();
  });

  group('{FeatureName}Controller Tests', () {
    test('should initialize with default values', () {
      // Arrange & Act
      controller.onInit();
      
      // Assert
      expect(controller.items.isEmpty, true);
      expect(controller.isLoading.value, false);
    });

    test('should load data successfully', () async {
      // Arrange
      // Mock dependencies if needed
      
      // Act
      await controller.loadData();
      
      // Assert
      expect(controller.items.isNotEmpty, true);
      expect(controller.isLoading.value, false);
    });
  });
}
```

## Usage Instructions

### Step 1: Gather Information
Ask the user for:
1. **Controller name** to test
2. **Key methods** to test
3. **Reactive variables** to verify
4. **Dependencies** that need mocking

### Step 2: Generate Test File

**Basic Test Template:**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:coffee_web/app/{feature}/{feature}_controller.dart';
// Import mocks
import '{feature}_controller_test.mocks.dart';

// Generate mocks
@GenerateMocks([ApiService, DatabaseService])
void main() {
  late {FeatureName}Controller controller;
  late MockApiService mockApiService;
  late MockDatabaseService mockDatabaseService;

  setUp(() {
    Get.testMode = true;
    
    // Initialize mocks
    mockApiService = MockApiService();
    mockDatabaseService = MockDatabaseService();
    
    // Register mocks in GetX
    Get.put<ApiService>(mockApiService);
    Get.put<DatabaseService>(mockDatabaseService);
    
    // Create controller
    controller = {FeatureName}Controller();
  });

  tearDown(() {
    controller.onClose();
    Get.reset();
  });

  group('{FeatureName}Controller - Initialization', () {
    test('should initialize with default values', () {
      expect(controller.items.isEmpty, true);
      expect(controller.isLoading.value, false);
      expect(controller.state.value, UiState.defaultView);
    });

    test('should call onInit successfully', () async {
      await controller.onInit();
      
      // Verify initialization logic
      expect(controller.isLoading.value, false);
    });
  });

  group('{FeatureName}Controller - Data Loading', () {
    test('should load data successfully', () async {
      // Arrange
      final mockData = [Item(id: '1', name: 'Test')];
      when(mockApiService.fetchData())
          .thenAnswer((_) async => mockData);
      
      // Act
      await controller.loadData();
      
      // Assert
      expect(controller.items.length, 1);
      expect(controller.items.first.name, 'Test');
      expect(controller.state.value, UiState.defaultView);
      verify(mockApiService.fetchData()).called(1);
    });

    test('should handle error when loading data fails', () async {
      // Arrange
      when(mockApiService.fetchData())
          .thenThrow(Exception('Network error'));
      
      // Act
      await controller.loadData();
      
      // Assert
      expect(controller.items.isEmpty, true);
      expect(controller.state.value, UiState.errorView);
      verify(mockApiService.fetchData()).called(1);
    });
  });

  group('{FeatureName}Controller - State Management', () {
    test('should update reactive variable correctly', () {
      // Arrange
      expect(controller.count.value, 0);
      
      // Act
      controller.count.value = 5;
      
      // Assert
      expect(controller.count.value, 5);
    });

    test('should add item to list', () {
      // Arrange
      final item = Item(id: '1', name: 'Test');
      
      // Act
      controller.addItem(item);
      
      // Assert
      expect(controller.items.length, 1);
      expect(controller.items.first, item);
    });
  });

  group('{FeatureName}Controller - Cleanup', () {
    test('should dispose resources in onClose', () {
      // Arrange
      controller.onInit();
      
      // Act
      controller.onClose();
      
      // Assert
      // Verify cleanup happened
      // Note: Rx variables are auto-disposed by GetX
    });
  });
}
```

### Step 3: Generate Mock Classes

If using mockito, create mock annotations:
```dart
@GenerateMocks([
  ApiService,
  DatabaseService,
  NotificationService,
])
void main() {
  // Tests here
}
```

Then run:
```bash
flutter pub run build_runner build
```

### Step 4: Widget Tests (Optional)

For testing views:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:coffee_web/app/{feature}/{feature}_view.dart';
import 'package:coffee_web/app/{feature}/{feature}_controller.dart';

void main() {
  testWidgets('{FeatureName}View should display correctly', (tester) async {
    // Arrange
    Get.testMode = true;
    final controller = Get.put({FeatureName}Controller());
    
    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        home: {FeatureName}View(),
      ),
    );
    
    // Assert
    expect(find.text('Expected Text'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    
    // Cleanup
    Get.reset();
  });

  testWidgets('should show loading indicator when loading', (tester) async {
    // Arrange
    Get.testMode = true;
    final controller = Get.put({FeatureName}Controller());
    controller.isLoading.value = true;
    
    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        home: {FeatureName}View(),
      ),
    );
    
    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    // Cleanup
    Get.reset();
  });
}
```

## Testing Best Practices

### 1. Test Structure (AAA Pattern)
```dart
test('description', () {
  // Arrange - Set up test data and mocks
  final mockData = [...];
  when(mock.method()).thenReturn(mockData);
  
  // Act - Execute the code being tested
  controller.doSomething();
  
  // Assert - Verify the results
  expect(controller.result, expectedValue);
});
```

### 2. Mock External Dependencies
```dart
// Don't test external services, mock them
when(mockApiService.fetchData())
    .thenAnswer((_) async => mockData);
```

### 3. Test Edge Cases
```dart
test('should handle empty list', () { ... });
test('should handle null values', () { ... });
test('should handle network errors', () { ... });
```

### 4. Test Reactive State
```dart
test('should update UI when reactive variable changes', () {
  // Arrange
  expect(controller.count.value, 0);
  
  // Act
  controller.increment();
  
  // Assert
  expect(controller.count.value, 1);
});
```

### 5. Verify Method Calls
```dart
test('should call API service once', () async {
  await controller.loadData();
  
  verify(mockApiService.fetchData()).called(1);
});
```

## Common Test Scenarios

### Testing Async Methods
```dart
test('should load data asynchronously', () async {
  // Use async/await
  await controller.loadData();
  
  expect(controller.items.isNotEmpty, true);
});
```

### Testing Error Handling
```dart
test('should handle errors gracefully', () async {
  when(mockApiService.fetchData())
      .thenThrow(Exception('Error'));
  
  await controller.loadData();
  
  expect(controller.state.value, UiState.errorView);
});
```

### Testing State Transitions
```dart
test('should transition from loading to default state', () async {
  // Initial state
  expect(controller.state.value, UiState.defaultView);
  
  // Start loading
  controller.setLoading();
  expect(controller.state.value, UiState.loading);
  
  // Complete loading
  controller.setDefault();
  expect(controller.state.value, UiState.defaultView);
});
```

### Testing List Operations
```dart
test('should add and remove items from list', () {
  final item = Item(id: '1', name: 'Test');
  
  controller.addItem(item);
  expect(controller.items.length, 1);
  
  controller.removeItem(item);
  expect(controller.items.isEmpty, true);
});
```

## Running Tests

**Run all tests:**
```bash
flutter test
```

**Run specific test file:**
```bash
flutter test test/features/my_feature/my_feature_controller_test.dart
```

**Run with coverage:**
```bash
flutter test --coverage
```

**Generate coverage report:**
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Test Coverage Goals

Aim for:
- **Controllers**: 80%+ coverage
- **Critical business logic**: 100% coverage
- **Views**: Basic smoke tests
- **Edge cases**: All covered

## Example: Complete Test File

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:coffee_web/app/notifications/notifications_controller.dart';
import 'package:coffee_web/network/repo/notification_repo.dart';
import 'notifications_controller_test.mocks.dart';

@GenerateMocks([NotificationRepo])
void main() {
  late NotificationsController controller;
  late MockNotificationRepo mockRepo;

  setUp(() {
    Get.testMode = true;
    mockRepo = MockNotificationRepo();
    Get.put<NotificationRepo>(mockRepo);
    controller = NotificationsController();
  });

  tearDown(() {
    controller.onClose();
    Get.reset();
  });

  group('NotificationsController - Initialization', () {
    test('should initialize with empty notification set', () {
      expect(controller.notificationSet.isEmpty, true);
      expect(controller.isAPICalling.value, true);
    });
  });

  group('NotificationsController - Load Notifications', () {
    test('should load notifications successfully', () async {
      // Arrange
      final mockNotifications = [
        AppNotificationDTO(id: '1', message: 'Test'),
      ];
      when(mockRepo.userNotificationForUser(
        userId: anyNamed('userId'),
        pageNumber: anyNamed('pageNumber'),
        pageSize: anyNamed('pageSize'),
      )).thenAnswer((_) async => GetUsersNotificationForUserResponse(
        isSuccess: true,
        returnLst: ReturnLst(
          appNotificationDTO: mockNotifications,
          notificationCount: NotificationCount(totalNotification: 1),
        ),
      ));

      // Act
      await controller.onInit();

      // Assert
      expect(controller.notificationSet.length, 1);
      expect(controller.isAPICalling.value, false);
    });
  });
}
```

## Usage

Invoke this skill when:
- Creating tests for new controllers
- Improving test coverage
- Testing specific functionality
- Debugging failing tests
- Setting up test infrastructure
