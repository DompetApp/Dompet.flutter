import 'package:get/get.dart';

typedef Callback<T> = InstanceBuilderCallback<T>;
typedef Builder<T> = List<Bind<T>> Function();

class BindingBuilder<T> extends Binding {
  Builder builder;

  BindingBuilder(this.builder);

  @override
  List<Bind> dependencies() => builder();

  factory BindingBuilder.put(Callback<T> builder, {String? tag}) {
    return BindingBuilder(() => [Bind.put(builder(), tag: tag)]);
  }
}
