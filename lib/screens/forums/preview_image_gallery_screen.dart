import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/preview_image_gallery/preview_image_gallery_bloc.dart';
import 'package:sing_app/blocs/preview_image_gallery/preview_image_gallery_state.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/widgets/pinch_zoom_widget.dart';
import 'package:sing_app/widgets/s2e_appbar.dart';

import '../../utils/image_util.dart';

class PreviewImageGalleryScreen extends StatefulWidget {
  const PreviewImageGalleryScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PreviewImageGalleryState();
}

class _PreviewImageGalleryState extends State<PreviewImageGalleryScreen> {
  late final PageController _pageController;
  late final PreviewImageGalleryBloc _bloc;
  int index = 0;

  @override
  void initState() {
    _bloc = BlocProvider.of(context);
    index = _bloc.initialIndex;
    _pageController = PageController(initialPage: _bloc.initialIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: ColorUtil.primary,
      body: _buildBloc(),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bloc.close();
    super.dispose();
  }

  PreferredSizeWidget _buildAppBar() {
    return S2EAppBar(
      title: _bloc.singleImage == null
          ? '${index + 1} of ${_bloc.medias.length}'
          : '',
      actionWidgets: [

      ],
    );
  }

  Widget _buildBloc() {
    return BlocConsumer<PreviewImageGalleryBloc, PreviewImageGalleryState>(
      listener: (ctx, state) {},
      builder: _buildBody,
    );
  }

  Widget _buildBody(BuildContext context, PreviewImageGalleryState state) {
    return _bloc.medias.isNotEmpty
        ? PageView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: _bloc.medias.length,
            onPageChanged: (int page) {
              setState(() {
                index = page;
              });
            },
            controller: _pageController,
            itemBuilder: _itemBuilder,
          )
        : PinchZoomWidget(
            resizeOnInteractionEnd: false,
            maxScale: 5,
            child: ImageUtil.loadNetWorkImage(
                url: _bloc.singleImage?.original ?? '',
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.fitWidth));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final item = _bloc.medias[index];
    return SizedBox(
        height: double.infinity,
        child: item.type == 'video'
            ? BetterPlayer.network(item.original,
                betterPlayerConfiguration: const BetterPlayerConfiguration(
                  aspectRatio: 16 / 9,
                  fit: BoxFit.contain,
                ))
            : PinchZoomWidget(
                resizeOnInteractionEnd: _bloc.medias.length != 1,
                maxScale: 5,
                minScale: 0.5,
                child: ImageUtil.loadNetWorkImage(
                    url: item.original,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.fitWidth)));
  }
}
