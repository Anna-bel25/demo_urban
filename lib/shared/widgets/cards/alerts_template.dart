import 'package:demo_urban/.env/theme/app_theme.dart';
import 'package:demo_urban/shared/providers/functional_provider.dart';
import 'package:demo_urban/shared/widgets/cards/filed_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

Text titleAlerts({required String title, required Color color}) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.bold,
      color: color,
    ),
  );
}

Padding messageAlerts(Size size, {required String message}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
    child: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppTheme.hinText,
      ),
    ),
  );
}

class AlertLoading extends StatelessWidget {
  const AlertLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();
    return Material(
      type: MaterialType.transparency,
      child: SizedBox(
        height: 180,
        width: 240,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SvgPicture.asset(
              theme.logoImagePathLight,
              fit: BoxFit.fill,
            ),
            const Positioned(
                bottom: 12,
                child: Text(
                  'Somos esperanza de vida',
                  style: TextStyle(
                      color: AppTheme.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ))
          ],
        ),
      ),
    );
  }
}

class AlertGeneric extends StatefulWidget {
  final bool dismissable;
  final GlobalKey? keyToClose;
  final Widget content;
  final bool? heightOption;

  const AlertGeneric(
      {Key? key,
      required this.content,
      this.heightOption = false,
      this.dismissable = false,
      this.keyToClose})
      : super(key: key);

  @override
  State<AlertGeneric> createState() => _AlertGenericState();
}

class _AlertGenericState extends State<AlertGeneric> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          //margin: EdgeInsets.all(50),
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          height: widget.heightOption == true ? size.height * 0.54 : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppTheme.white,
          ),
          child:
              Material(type: MaterialType.transparency, child: widget.content),
        ),
        if (widget.dismissable)
          Positioned(
            top: -3,
            right: 0,
            child: SizedBox(
              height: 50,
              width: 50,
              child: CloseButton(
                style: const ButtonStyle(
                    iconColor: WidgetStatePropertyAll(AppTheme.hinText)),
                onPressed: () {
                  final fp =
                      Provider.of<FunctionalProvider>(context, listen: false);
                  fp.dismissAlert(key: widget.keyToClose!);
                },
              ),
            ),
          )
      ],
    );
  }
}

class AlertTemplate extends StatefulWidget {
  final Widget content;
  final GlobalKey keyToClose;
  final bool? dismissAlert;
  final bool? animation;
  final double? padding;

  const AlertTemplate(
      {Key? key,
      required this.content,
      required this.keyToClose,
      this.dismissAlert = false,
      this.animation = true,
      this.padding = 20,
      })
      : super(key: key);

  @override
  State<AlertTemplate> createState() => _AlertTemplateState();
}

class _AlertTemplateState extends State<AlertTemplate> {
  late GlobalKey keySummoner;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomOut(
        controller: (controller) {
        },
        animate: false,
        duration: const Duration(milliseconds: 200),
        child: Scaffold(
          backgroundColor: Colors.black45,
          body: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  final fp =
                      Provider.of<FunctionalProvider>(context, listen: false);
                  widget.dismissAlert == true
                      ? fp.dismissAlert(key: widget.keyToClose)
                      : null;
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent,
                ),
              ),
              Container(
                padding: EdgeInsets.all(widget.padding ?? 20),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // /const Expanded(child: SizedBox()),
                        widget.animation == true
                            ? FadeInUpBig(
                                animate: true,
                                controller: (controller) {
                                },
                                duration: const Duration(milliseconds: 500),
                                child: widget.content)
                            : widget.content,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}


class ErrorGeneric extends StatelessWidget {
  final GlobalKey keyToClose;
  final String message;
  final String? messageButton;
  final void Function()? onPress;

  const ErrorGeneric(
      {Key? key,
      required this.message,
      required this.keyToClose,
      this.messageButton,
      this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(height: size.height * 0.015),
        SvgPicture.asset(AppTheme.iconErrorPath),
        SizedBox(height: size.height * 0.03),
        titleAlerts(title: '¡Oops, algo fallo!', color: AppTheme.error),
        SizedBox(height: size.height * 0.04),
        messageAlerts(size, message: message),
        SizedBox(height: size.height * 0.03),
        GradientButtonRed(
          borderRadius: 20,
          width: size.width * 0.05,
          //color: AppTheme.error,
          text: messageButton ?? 'Aceptar',
          onPressed: (onPress != null)
            ? onPress
            : () async {
                final fp =
                Provider.of<FunctionalProvider>(context, listen: false);
                fp.dismissAlert(key: keyToClose);
            },
        ),
        SizedBox(height: size.height * 0.01),
      ],
    );
  }
}

class SuccessInformation extends StatelessWidget {
  final GlobalKey keyToClose;
  final void Function()? onPressed;
  final String? message;
  final bool? isTitle;

  const SuccessInformation(
      {Key? key,
      this.isTitle = true,
      required this.keyToClose,
      this.onPressed,
      this.message = 'body'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(height: size.height * 0.015),
        SvgPicture.asset(AppTheme.iconCheckPath),
        const SizedBox(height: 25),
        isTitle == true
            ? titleAlerts(title: '¡Estamos listos!', color: AppTheme.title)
            : const SizedBox(),
        isTitle == true
            ? SizedBox(height: size.height * 0.015)
            : const SizedBox(),
        messageAlerts(size, message: message!),
        SizedBox(height: size.height * 0.025),
        GradientButtonRed(
            borderRadius: 15,
            width: size.width * 0.05,
            //color: AppTheme.title,
            text: 'Aceptar',
            onPressed: onPressed
            ),
        SizedBox(height: size.height * 0.01),
      ],
    );
  }
}

class ConfirmContent extends StatelessWidget {
  final String message;
  final void Function() confirm;
  final void Function() cancel;
  const ConfirmContent(
      {Key? key,
      required this.message,
      required this.confirm,
      required this.cancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: size.height * 0.015),
        SvgPicture.asset(AppTheme.iconCheckPath),
        const SizedBox(height: 15),
        messageAlerts(size, message: message),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientButtonBlack(
              onPressed: cancel, text: 'Cancelar'),
            SizedBox(width: size.width * 0.08),
            GradientButtonBlack(
              onPressed: confirm, text: 'Confirmar')
          ],
        ),
        SizedBox(height: size.height * 0.01),
      ],
    );
  }
}


class NoExistInformation extends StatelessWidget {
  final String message;
  final void Function() function;
  final String? namePage;
  final bool? isNamePage;

  const NoExistInformation({
    Key? key,
    required this.message,
    required this.function,
    this.namePage = '',
    this.isNamePage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: size.height * 0.015),
        SvgPicture.asset(AppTheme.iconCautionPath),
        const SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.027),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: message,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.hinText),
              children: <TextSpan>[
                isNamePage == true
                    ? TextSpan(
                        text: ' $namePage.',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.hinText),
                      )
                    : const TextSpan(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 25),
        GradientButtonBlack(
            //color: AppTheme.title,
            onPressed: function,
            width: size.width * 0.05,
            text: 'Aceptar'),
        SizedBox(height: size.height * 0.01),
      ],
    );
  }
}
