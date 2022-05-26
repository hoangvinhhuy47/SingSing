import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../data/models/media.dart';
import '../../data/models/post.dart';
import '../../utils/color_util.dart';
import '../../utils/image_util.dart';
import '../../utils/styles.dart';
import '../button_play_video.dart';
import '../ink_click_item.dart';

class ItemMediaWidget extends StatelessWidget {
  final BuildContext context;
  final Post post;
  final Function onTap;

  const ItemMediaWidget(
      {Key? key,
      required this.context,
      required this.post,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisSpacing: 6,
      mainAxisSpacing: 6,
      crossAxisCount: 2,
      children: post.medias.map((item) {
        return _buildItemMedia(item);
      }).toList(),
    );
  }

  Widget _buildItemMedia(MediaModel item) {
    final index = post.medias.indexOf(item);
    if (index > 3) {
      // just display 4 media
      return const SizedBox();
    }
    // for 4th file display the number of remaining images
    final bool isViewMore = index == 3 && post.medias.length > 4;

    // for display single file 2 row 2 column
    final isSingleFile = post.medias.length == 1;
    return StaggeredGridTile.count(
      crossAxisCellCount: isSingleFile ? 2 : 1,
      mainAxisCellCount: isSingleFile
          ? item.type == "video"
              ? 1.5
              : 2
          : index == 1 && post.medias.length == 3 // for display 2th file 2 row
              ? 2
              : 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: InkClickItem(
          onTap: () {
            onTap(item, index);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              ImageUtil.loadNetWorkImage(
                  url: item.thumb,
                  height: double.infinity,
                  width: double.infinity),
              Visibility(
                  visible: !isViewMore && item.type == "video",
                  child: BuildBtnPlayVideo(
                      context: context,
                      onPress: () {
                        onTap(item, index);
                      })),
              Visibility(
                  visible: isViewMore,
                  child: Container(
                    decoration: BoxDecoration(
                        color: ColorUtil.blurBgColor,
                        borderRadius: BorderRadius.circular(12)),
                  )),
              Visibility(
                  visible: isViewMore,
                  child: Text('+${post.medias.length - 3}',
                      style: s(context, fontSize: 28)))
            ],
          ),
        ),
      ),
    );
  }
}
