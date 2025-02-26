import 'package:edukar/env/environment_company.dart';
import 'package:flutter/material.dart';
import '../../env/theme/app_theme.dart';
import 'alert_modal.dart';

class LayoutWidget extends StatefulWidget {
  const LayoutWidget({
    Key? key,
    required this.child,
    this.requiredStack = true,
    this.keyDismiss,
  }) : super(key: key);

  final Widget child;
  final bool requiredStack;
  final GlobalKey<State<StatefulWidget>>? keyDismiss;

  @override
  State<LayoutWidget> createState() => _LayoutWidgetState();
}

class _LayoutWidgetState extends State<LayoutWidget> {
  final config = EnvironmentCompany().config;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundHome,
        body: MediaQuery.withNoTextScaling(
          child: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      decoration: BoxDecoration(
                          color: config!.primaryColor,
                          image: DecorationImage(
                              image: AssetImage(config!.imgLayout),
                              alignment: Alignment.bottomLeft)),
                      child: widget.child,
                    ),
                  ),
                ],
              ),
              if (widget.requiredStack) const AlertModal(),
            ],
          ),
        ),
      ),
    );
  }
}
