import 'package:get/get.dart';
import 'package:safe_to_spend/features/root/controllers/root_shell_controller.dart';

/// Binding configuring dependencies for the root application shell.
class RootShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootShellController>(RootShellController.new);
  }
}
