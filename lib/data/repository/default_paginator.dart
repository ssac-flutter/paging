import 'package:paging/domain/repository/paginator.dart';
import 'package:paging/util/result.dart';

class DefaultPaginator<Key, Item> implements Paginator<Key, Item> {
  final Key initialKey;
  final Function(bool) onLoadUpdated;
  final Future<Result<List<Item>>> Function(Key nextKey) onRequest;
  final Future<Key> Function(List<Item>) getNextKey;
  final Future<void> Function(String message) onError;
  final Future<void> Function(List<Item> items, Key newKey) onSuccess;

  late Key _currentKey;
  var _isMakingRequest = false;

  DefaultPaginator({
    required this.initialKey,
    required this.onLoadUpdated,
    required this.onRequest,
    required this.getNextKey,
    required this.onError,
    required this.onSuccess,
  }) {
    _currentKey = initialKey;
  }

  @override
  Future loadNextItems() async {
    if (_isMakingRequest) {
      return;
    }

    _isMakingRequest = true;
    await onLoadUpdated(true);
    final result = await onRequest(_currentKey);
    _isMakingRequest = false;
    final items = result.when(
      success: (items) => items,
      error: (message) {
        onError(message);
        onLoadUpdated(false);
        return;
      },
    );

    if (items == null) {
      return;
    }

    _currentKey = await getNextKey(items);
    onSuccess(items, _currentKey);
    onLoadUpdated(false);
  }

  @override
  void reset() {
    _currentKey = initialKey;
  }
}

