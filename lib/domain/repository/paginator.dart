abstract class Paginator<Key, Item> {
  Future loadNextItems();

  void reset();
}
