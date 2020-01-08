abstract class DataLoader<T> {
  Future<T> load();
}

abstract class DataLoaderWithParam<T, K> {
  Future<T> load(K param);
}
