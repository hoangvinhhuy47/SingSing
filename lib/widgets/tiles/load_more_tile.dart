


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadMoreTile extends StatelessWidget {

  const LoadMoreTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      // color: Colors.red,
      child: const Center(
        child: SizedBox(
          child: CircularProgressIndicator(
            color: Colors.grey,
          ),
          height: 25.0,
          width: 25.0,
        ),
      ),
    ) ;
  }


}