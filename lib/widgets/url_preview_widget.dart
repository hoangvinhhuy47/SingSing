import 'package:flutter/cupertino.dart';
import 'package:sing_app/data/models/graph_url_info_model.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/ink_click_item.dart';

import '../constants/constants.dart';
import '../data/models/internal_web_view.dart';
import '../utils/url_util.dart';

class UrlPreviewWidget extends StatelessWidget {
  final GraphUrlInfo graphUrlInfo;
  final UrlPreviewWidgetType type;
  final Function? removeGraphUrlInfo;
  final double contentWidth;

  const UrlPreviewWidget(
      {Key? key,
      required this.graphUrlInfo,
      this.type = UrlPreviewWidgetType.typeView,
      this.removeGraphUrlInfo,this.contentWidth = 0.65})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkClickItem(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        if (type != UrlPreviewWidgetType.typeEdit) {
          UrlUtil.openWeb(
            context,
            InternalWebViewModel(
              title: graphUrlInfo.domain,
              url: graphUrlInfo.url,
            ),
          );
        }
      },
      color: type != UrlPreviewWidgetType.typeEdit
          ? ColorUtil.backgroundItemColor
          : ColorUtil.mainGrey,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: type != UrlPreviewWidgetType.typeEdit && type != UrlPreviewWidgetType.typeLinkInComment
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _urlImage(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal:
                            type == UrlPreviewWidgetType.typePinPost ? 0 : 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(child: _textDomain(context)),
                        const SizedBox(height: 4),
                        _textTitle(context)
                      ],
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
                  Row(
                    children: [
                      _urlImage(),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _textDomain(context),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: MediaQuery.of(context).size.width *contentWidth,
                              child: _textTitle(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: type == UrlPreviewWidgetType.typeEdit,
                    child: Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () => removeGraphUrlInfo != null
                            ? removeGraphUrlInfo!()
                            : null,
                        child: ImageUtil.loadAssetsImage(
                            fileName: 'ic_remove_file.svg'),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _urlImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
          type == UrlPreviewWidgetType.typePinPost ? 12 : 0),
      child: ImageUtil.loadNetWorkImage(
          url: graphUrlInfo.image,
          height: type == UrlPreviewWidgetType.typePinPost
              ? 140
              : type == UrlPreviewWidgetType.typeView
                  ? 170
                  : 80,
          width: type == UrlPreviewWidgetType.typeView ||
                  type == UrlPreviewWidgetType.typePinPost
              ? double.infinity
              : 80),
    );
  }

  Text _textTitle(BuildContext context) {
    return Text(
      graphUrlInfo.title,
      style: s(context,
          fontSize: type == UrlPreviewWidgetType.typePinPost ? 16 : 18),
      maxLines: type == UrlPreviewWidgetType.typeView ? 4 : 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Text _textDomain(BuildContext context) {
    return Text(
      graphUrlInfo.domain.toUpperCase(),
      style: s(context,
          fontSize: type == UrlPreviewWidgetType.typePinPost ? 16 : 18,
          color: ColorUtil.colorButton),
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
    );
  }
}
