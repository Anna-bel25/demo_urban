import 'dart:convert';
import 'package:edukar/modules/client/models/client_model.dart';
import 'package:edukar/modules/home/pages/home_page.dart';
import 'package:edukar/modules/security/login/models/login_response.dart';
import 'package:edukar/modules/security/login/services/login_service.dart';
import 'package:edukar/shared/helpers/responsive.dart';
import 'package:edukar/shared/models/credential_response.dart';
import 'package:edukar/shared/providers/functional_provider.dart';
import 'package:edukar/shared/secure_storage/user_data_storage.dart';
import 'package:edukar/shared/widgets/alerts_template.dart';
import 'package:edukar/shared/widgets/drop_down_widget.dart';
import 'package:edukar/shared/widgets/title.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import '../../../../env/theme/app_theme.dart';
import '../../../../shared/helpers/global_helper.dart';
import '../../../../shared/providers/client_provider.dart';
import '../../../../shared/widgets/filled_button.dart';
import '../../../../shared/widgets/placeholder_widget.dart';
import '../../../../shared/widgets/text_form_field_widget.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class FormLoginWidget extends StatefulWidget {
  const FormLoginWidget({super.key});

  @override
  State<FormLoginWidget> createState() => _FormLoginWidgetState();
}

class _FormLoginWidgetState extends State<FormLoginWidget> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPassword = false;
  bool? _rememberUser;
  late FunctionalProvider fp;
  final _loginService = LoginService();
  CredentialResponse? userModel;
  bool fingerprintButtonWidget = false;

  final _auth = LocalAuthentication();
  List<DropdownMenuItem<String>> selectCatalogue = [];
  String value = ' ';
  String valueCatalogue = 'PRIMER QUIMESTRE';
  String valueParcial = 'Totales';

  @override
  void initState() {
    fp = Provider.of<FunctionalProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool fingerprintButton = await UserDataStorage().getFingerprintButton();
      setState(() {
        fingerprintButtonWidget = fingerprintButton;
      });

      // userController.text = 'jacquita19@icloud.com';
      // passwordController.text = 'yxxHetARYq1nuc7P7klr';

      _initSessionByBiometric();

      userModel = await UserDataStorage().getUserCredentials();
      //bool isRemember = await UserDataStorage().getRemember();

      setState(() {
        if (userModel != null && userModel!.user != null) {
          userController.text = userModel!.user!;
          passwordController.text = userModel!.password!;
        }
      });

      // setState(() {
      //   _rememberUser = isRemember;
      // });
    });
    GlobalHelper().trackScreen("Pantalla de Login");
    super.initState();
  }

  _initSessionByBiometric() async {
    final credentialBiometric =
        await UserDataStorage().getUserCredentialsBiometric();
    if (credentialBiometric.user != null &&
        credentialBiometric.password != null) {
      //userController.text = credentialBiometric.user!;
      final autenticate = await _autenticateUser();
      if (autenticate) {
        final firebaseToken = await FirebaseMessaging.instance.getToken();
        _login(body: {
          "usr_name": credentialBiometric.user!,
          "usr_pass": credentialBiometric.password!,
          "token_dispositivo": firebaseToken.toString(),
        }, saveBiometric: true);
        // ClientModel clientModel = ClientModel(
        //   user: userModel?.user,
        //   password: userModel?.password,
        // );
        // fp.transferData(clientModel);
        // setState(() { });
      }
    }
  }

  void _login(
      {required Map<String, String> body, required bool saveBiometric}) async {
    userModel =
        CredentialResponse(user: body['usr_name'], password: body['usr_pass']);
    final response = await _loginService.postLogin(context, body);
    if (!response.error) {
      if (response.data!.informacion!.estudiantes!.isNotEmpty) {
        //rememberUser(userModel!);
        UserDataStorage()
            .setDataLogin(loginResponseFromJson(json.encode(response.data)));
        if (saveBiometric) {
          final resp = await _autenticateUser();
          if (resp) {
            UserDataStorage().setUserCredentialsBiometric(userModel!);
            UserDataStorage().setFingerprintButton(true);
          }
        }
        if (fp.alertLoading.isEmpty) {
          Navigator.pushAndRemoveUntil(
              context,
              GlobalHelper.navigationFadeIn(context, const HomePage()),
              (route) => false);
        }
      } else {
        final notStudentKey = GlobalHelper.genKey();
        fp.showAlert(
            key: notStudentKey,
            content: AlertGeneric(
                content: ErrorGeneric(
                    message:
                        'No hay estudiantes disponibles, contactese con el administrador.',
                    keyToClose: notStudentKey)));
      }
    } else {
      GlobalHelper.logger
          .e('error al loguearse contactese con su administrador');
    }
  }

  void rememberUser(CredentialResponse userModel) {
    if (_rememberUser!) {
      UserDataStorage().setUserCredentials(userModel);
      UserDataStorage().setRemember(_rememberUser!);
    } else {
      UserDataStorage().removeDataCredentials();
      UserDataStorage().removeRemember();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsive = Responsive.of(context);

    return Card(
      elevation: 5,
      borderOnForeground: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: responsive.isTablet ? EdgeInsets.all(50) : EdgeInsets.all(30),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.025),
              // child: placeHolderWidget(
              //     placeholder: 'Usuario', fontSize: responsive.dp(1.7))
            ),
            SizedBox(height: size.height * 0.006),
            TextFormFieldWidget(
              hintText: 'Usuario',
              maxHeigth: responsive.hp(7),
              keyboardType: TextInputType.emailAddress,
              controller: userController,
              textInputAction: TextInputAction.next,
              suffixIcon: const Icon(
                Icons.person_outline,
                color: AppTheme.bordergrey,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El correo es requerido.';
                }
                if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                    .hasMatch(value)) {
                  return 'El correo ingresado no es valido.';
                }
                return null;
              },
            ),
            SizedBox(height: size.height * 0.025),
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.025),
              // child: placeHolderWidget(
              //     placeholder: 'Contraseña', fontSize: responsive.dp(1.7))
            ),
            SizedBox(height: size.height * 0.0056),
            TextFormFieldWidget(
              hintText: 'Contraseña',
              maxHeigth: responsive.hp(7),
              keyboardType: TextInputType.visiblePassword,
              controller: passwordController,
              obscureText: !showPassword,
              suffixIcon: IconButton(
                color: AppTheme.bordergrey,
                icon: !showPassword
                    ? const Icon(Icons.remove_red_eye_outlined)
                    : const Icon(Icons.visibility_off_outlined),
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
              ),
            ),
            SizedBox(height: size.height * 0.025),
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.025),
              // child: placeHolderWidget(
              //     placeholder: 'Contraseña', fontSize: responsive.dp(1.7))
            ),
            DropDownButtonWidget(
              hint: 'Elegir empresa',
              //value: value != ' ' ? value : 'A', 
              items: ['A', 'B', 'C'].map((String empresa) {
                return DropdownMenuItem<String>(
                  value: empresa,
                  child: MediaQuery.withNoTextScaling(
                    child: Text(
                      empresa,
                      style: TextStyle(
                        color: config!.searchText,
                        fontSize: size.height * 0.016,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  value = value!;
                });
              },
            ),
            SizedBox(height: size.height * 0.015),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     Checkbox(
            //       value: _rememberUser ?? false,
            //       onChanged: (value) {
            //         setState(() {
            //           _rememberUser = value!;
            //         });
            //       },
            //       side: BorderSide(color: config!.primaryColor, width: 2),
            //       activeColor: config!.primaryColor,
            //       checkColor: AppTheme.white,
            //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //       visualDensity: VisualDensity.compact,
            //     ),
            //     placeHolderWidget(
            //         placeholder: 'Recordar mi usuario',
            //         fontWeight: FontWeight.normal,
            //         fontSize: responsive.dp(1.7)),
            //   ],
            // ),
            SizedBox(height: size.height * 0.02),
            Visibility(
              visible: fingerprintButtonWidget,
              child: OutlinedButton.icon(
                onPressed: () {
                  _initSessionByBiometric();
                  // Navigator.pushNamed(context, '/forgot-password');
                },
                icon: Icon(Icons.fingerprint, color: config!.primaryColor),
                label: Text(
                  'Huella o Face ID',
                  style: TextStyle(
                      color: config!.primaryColor,
                      fontSize: responsive.dp(1.7)),
                ),
                style: OutlinedButton.styleFrom(
                    minimumSize: Size(200, responsive.hp(5))),
              ),
            ),
            //SizedBox(height: size.height * 0.045),
            SizedBox(height: size.height * 0.03),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: FilledButtonWidget(
                  color: config!.secondaryColor,
                  text: 'Ingresar',
                  // onPressed: (){
                  //   Navigator.push(
                  //     context, MaterialPageRoute(
                  //       builder: (context) => PageHome(),
                  //     ),
                  //   );
                  // },

                  //onPressed: () => Navigator.pushNamed(context, '/home'),

                  onPressed: () async {
                    if (userController.text.trim().isEmpty ||
                        passwordController.text.trim().isEmpty) {
                      final keyIncompleteCredentials = GlobalHelper.genKey();
                      Future.delayed(const Duration(seconds: 2));
                      fp.showAlert(
                        key: keyIncompleteCredentials,
                        content: AlertGeneric(
                          content: ErrorGeneric(
                              message:
                                  'Por favor, llena los campos requeridos para poder iniciar sesión.',
                              keyToClose: keyIncompleteCredentials),
                        ),
                      );
                    } else {
                      try {
                        final firebaseToken =
                            await FirebaseMessaging.instance.getToken();
                        _login(body: {
                          "usr_name": userController.text.trim(),
                          "usr_pass": passwordController.text.trim(),
                          "token_dispositivo": firebaseToken.toString()
                        }, saveBiometric: true);
                      } on Exception catch (e) {
                        GlobalHelper.logger.e('error con el firebase: $e');
                        _login(body: {
                          "usr_name": userController.text.trim(),
                          "usr_pass": passwordController.text.trim()
                        }, saveBiometric: true);
                      }
                    }
                  },
                  height: responsive.hp(5),
                  //width: responsive.wp(8),
                  width: responsive.isTablet
                      ? responsive.wp(12)
                      : responsive.wp(8),
                )),
          ],
        ),
      ),
    );
  }

  Future<bool> _autenticateUser() async {
    final deviceSupported = await GlobalHelper.isDeviceSupported(auth: _auth);
    if (deviceSupported) {
      final checkBiometri = await GlobalHelper.hasBiometrics(auth: _auth);
      if (checkBiometri) {
        final list = await _auth.getAvailableBiometrics();
        if (list.contains(BiometricType.strong) ||
            list.contains(BiometricType.face) ||
            list.contains(BiometricType.fingerprint)) {
          final authenticated = await _auth.authenticate(
              options: const AuthenticationOptions(useErrorDialogs: false),
              localizedReason:
                  'Toque con el dedo el sensor para iniciar sesión.',
              authMessages: const <AuthMessages>[
                AndroidAuthMessages(
                  deviceCredentialsSetupDescription:
                      'Se requiere autenticación biométrica',
                  deviceCredentialsRequiredTitle:
                      'Se requiere autenticación biométrica',
                  //biometricSuccess: 'Autenticación exitosa',
                  biometricRequiredTitle:
                      'Se requiere autenticación biométrica',
                  biometricNotRecognized: 'No se reconoció la huella digital.',
                  biometricHint: '',
                  signInTitle: 'Se requiere autenticación biométrica',
                ),
                IOSAuthMessages(
                  cancelButton: 'No thanks',
                ),
              ]);
          if (authenticated) {
            return true;
          }
        }
      } else {}
    } else {}
    return false;
  }
}
