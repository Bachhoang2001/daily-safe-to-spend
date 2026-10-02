import 'package:get/get.dart';

/// Contract for navigation operations to decouple controllers from GetX global calls.
abstract class INavigator {
  /// Navigates to a named route.
  Future<T?>? toNamed<T>(
    String page, {
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  });

  /// Navigates to a named route replacing the current route.
  Future<T?>? offNamed<T>(
    String page, {
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  });

  /// Navigates to a named route removing all previous routes from the stack.
  Future<T?>? offAllNamed<T>(
    String page, {
    dynamic arguments,
    int? id,
    Map<String, String>? parameters,
  });

  /// Closes the current screen/dialog/bottomsheet.
  void back<T>({
    T? result,
    bool closeOverlays = false,
    bool canPop = true,
    int? id,
  });
}

/// Default GetX implementation of [INavigator].
class AppNavigator implements INavigator {
  /// Creates a constant instance of [AppNavigator].
  const AppNavigator();

  @override
  Future<T?>? toNamed<T>(
    String page, {
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  }) {
    return Get.toNamed<T>(
      page,
      arguments: arguments,
      id: id,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
    );
  }

  @override
  Future<T?>? offNamed<T>(
    String page, {
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  }) {
    return Get.offNamed<T>(
      page,
      arguments: arguments,
      id: id,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
    );
  }

  @override
  Future<T?>? offAllNamed<T>(
    String page, {
    dynamic arguments,
    int? id,
    Map<String, String>? parameters,
  }) {
    return Get.offAllNamed<T>(
      page,
      arguments: arguments,
      id: id,
      parameters: parameters,
    );
  }

  @override
  void back<T>({
    T? result,
    bool closeOverlays = false,
    bool canPop = true,
    int? id,
  }) {
    Get.back<T>(
      result: result,
      closeOverlays: closeOverlays,
      canPop: canPop,
      id: id,
    );
  }
}
