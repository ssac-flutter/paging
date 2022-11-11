import 'package:flutter/material.dart';
import 'package:paging/data/repository/default_paginator.dart';
import 'package:paging/data/repository/repository.dart';
import 'package:paging/domain/model/list_item.dart';
import 'package:paging/domain/repository/paginator.dart';
import 'package:paging/presentation/main/main_state.dart';

class MainViewModel with ChangeNotifier {
  final _repository = Repository();

  MainState _state = const MainState();

  MainState get state => _state;

  late final Paginator _paginator;

  MainViewModel() {
    _paginator = DefaultPaginator<int, ListItem>(
      initialKey: state.page,
      onLoadUpdated: (loading) {
        _state = state.copyWith(isLoading: loading);
        notifyListeners();
      },
      onRequest: (nextPage) async {
        return await _repository.getItems(nextPage, 20);
      },
      getNextKey: (items) async {
        return state.page + 1;
      },
      onError: (message) async {
        _state = state.copyWith(error: message);
        notifyListeners();
      },
      onSuccess: (items, newKey) async {
        _state = state.copyWith(
            items: [...state.items, ...items],
            page: newKey,
            endReached: items.isEmpty);
        notifyListeners();
      },
    );

    loadNextItems();
  }

  Future loadNextItems() async {
    await _paginator.loadNextItems();
  }
}
