import 'package:paging/domain/model/list_item.dart';
import 'package:paging/util/result.dart';


class Repository {
  final _remoteDataSource = List.generate(
    100,
        (index) => ListItem(
      title: 'Item $index',
      description: 'Description $index',
    ),
  );

  Future<Result<List<ListItem>>> getItems(int page, int pageSize) async {
    await Future.delayed(const Duration(seconds: 2));
    final startingIndex = page * pageSize;

    if (startingIndex + pageSize <= _remoteDataSource.length) {
      return Result.success(
          _remoteDataSource.sublist(startingIndex, startingIndex + pageSize));
    } else {
      return const Result.success([]);
    }
  }
}
