import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sing_app/blocs/article/article_screen_bloc.dart';
import 'package:sing_app/blocs/article/article_screen_state.dart';
import 'package:sing_app/constants/extension_constant.dart';
import 'package:sing_app/widgets/loading_indicator.dart';
import 'package:sing_app/widgets/s2e_appbar.dart';

import '../utils/color_util.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  late final ArticleScreenBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<ArticleScreenBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ArticleScreenBloc, ArticleScreenState>(
        builder: _buildBody,
        listener: (ctx, state) {
          if (state is ArticleScreenSuccessState && !state.isSuccess) {
            log('message123 ${state.message}');
          }
        });
  }

  Widget _buildBody(BuildContext context, ArticleScreenState state) {
    final bool isLoading =
        (state is ArticleScreenLoadingState && state.isLoading);
    return Scaffold(
      appBar: _buildAppBar(),
      body: LoadingIndicator(
        isLoading: isLoading,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: _bloc.articleModel?.content != null
                ? Html(
                    data: _bloc.articleModel?.content!,
                  )
                : const SizedBox(),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return S2EAppBar(
      backgroundColor: ColorUtil.primary,
      title: _bloc.articleType.title,
    );
  }
}
