import 'package:get/get.dart';

typedef Callback<T> = InstanceBuilderCallback<T>;
typedef Builder<T> = List<Bind<T>> Function();

class BindingBuilder<T> extends Binding {
  Builder builder;

  BindingBuilder(this.builder);

  @override
  List<Bind> dependencies() => builder();

  factory BindingBuilder.put(Callback<T> builder, {String? tag}) {
    return BindingBuilder(() {
      late final deps = Get.find<T>(tag: tag);
      late final live = Get.isRegistered<T>(tag: tag);
      late final info = Get.getInstanceInfo<T>(tag: tag);

      if (live && info.isPermanent == true) {
        return [Bind.put(deps, tag: tag, permanent: true)];
      }

      if (live && info.isPermanent != true) {
        Get.delete<T>(tag: tag);
      }

      return [Bind.put(builder(), tag: tag)];
    });
  }
}
