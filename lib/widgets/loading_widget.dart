import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final Widget widget;
  final bool loading;

  LoadingWidget({@required this.widget, @required this.loading});

  @override
  Widget build(BuildContext context) {
    return loading ? Center(child: CircularProgressIndicator(),) : widget;
  }
}