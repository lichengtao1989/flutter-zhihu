import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../types.dart' show ChildCommentElement;
import '../../utils.dart';
import '../../widgets/widgets.dart';
import '../comments/item.dart';
import 'child_comments_state.dart';

class ChildComments extends StatelessWidget {
  final ChildCommentElement item;

  const ChildComments(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ChildCommentsState());
    final state = Get.find<ChildCommentsState>();
    if (state.item != item) {
      state.item = item;
      state.init();
    }

    return ModalBottomSheet('全部回复', [
      Obx(() {
        if (state.comments.isEmpty) {
          return SliverFillRemaining(
            child: Container(
              color: Get.theme.cardColor,
              child: const Loading(),
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, i) {
              if (i == state.comments.length) {
                if (state.end.value) return const SizedBox();

                state.fetch();
                return const SizedBox(height: 64, child: Loading());
              }
              final item = state.comments[i];
              return Column(children: [
                buildWidget(i == 0, () => const SizedBox(height: 12)),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Item(item),
                ),
                buildWidget(
                  i != state.comments.length - 1,
                  () => Column(children: [
                    const Divider(height: 0),
                    const SizedBox(height: 12),
                  ]),
                ),
              ]);
            },
            childCount: state.comments.length + 1,
          ),
        );
      }),
    ]);
  }
}
