import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/wallet_s2e/singsing_wallet/singsing_wallet_screen_bloc.dart';
import '../../../blocs/wallet_s2e/singsing_wallet/singsing_wallet_screen_state.dart';

class SingSingWalletScreen extends StatefulWidget {
  const SingSingWalletScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SingSingWalletScreenState();
}

class _SingSingWalletScreenState extends State<SingSingWalletScreen> {
  late SingSingWalletScreenBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SingSingWalletScreenBloc, SingSingWalletScreenState>(
        builder: (ctx, state) {
          return _buildBody(ctx, state);
        },
        listener: (ctx, state) {});
  }

  Widget _buildBody(BuildContext ctx, SingSingWalletScreenState state) {
    return Center(
      child: Text('Coming Soon'),
    );
  }
}
