import 'package:get/get.dart';

typedef Callback<T> = InstanceBuilderCallback<T>;
typedef Builder<T> = List<Bind<T>> Function();

class GetBindingBuilder<T> extends Binding {
  Builder builder;

  GetBindingBuilder(this.builder);

  factory GetBindingBuilder.lazyPut(
    Callback<T> builder, {
    bool fenix = true,
    String? tag,
  }) {
    return GetBindingBuilder(
      () => [Bind.lazyPut(builder, tag: tag, fenix: fenix)],
    );
  }

  factory GetBindingBuilder.put(
    Callback<T> builder, {
    bool permanent = false,
    String? tag,
  }) {
    return GetBindingBuilder(
      () => [Bind.put(builder(), tag: tag, permanent: permanent)],
    );
  }

  @override
  List<Bind> dependencies() {
    return builder();
  }
}
