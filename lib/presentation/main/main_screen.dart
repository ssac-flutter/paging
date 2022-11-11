import 'package:flutter/material.dart';
import 'package:paging/presentation/main/main_view_model.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MainViewModel>();
    final state = viewModel.state;

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollEndNotification) {
            viewModel.loadNextItems();
          }
          return true;
        },
        child: ListView(
          children: [
            ...state.items
                .map((e) => ListTile(
              title: Text(e.title),
              subtitle: Text(e.description),
            ))
                .toList(),
            if (!viewModel.state.endReached) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
