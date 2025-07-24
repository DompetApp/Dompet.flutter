import 'package:get/get.dart';

typedef InstanceBuilder<T> = InstanceBuilderCallback<T>;
typedef BindingsBuilder = List<Bind> Function();

class BindingBuilder<T> extends Binding {
  BindingsBuilder builder;

  BindingBuilder(this.builder);

  @override
  List<Bind> dependencies() => builder();

  factory BindingBuilder.put(T builder, {bool permanent = false, String? tag}) {
    return BindingBuilder(
      () => [Bind.put(builder, permanent: permanent, tag: tag)],
    );
  }

  factory BindingBuilder.lazyPut(InstanceBuilder<T> builder, {String? tag}) {
    return BindingBuilder(() => [Bind.lazyPut(builder, tag: tag)]);
  }
}
