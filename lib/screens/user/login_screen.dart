import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/login_provider.dart';
import '../../styles/buttom_style.dart';
import '../../styles/inputselect_style.dart';
import '../../styles/validation.dart';


class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer<LoginProvider>(builder: (context, model, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: model.isLoading
            ? Center(child: CircularProgressIndicator())
            : Center(
            child: SingleChildScrollView(
              child: Padding(
              padding: const EdgeInsets.all(16),
                child: Form(
                  key: model.loginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _formulario(model, context),
                      _botones(model, context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // Widget para el formulario de inicio de sesión
  Widget _formulario(LoginProvider model, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(height: 10),

          if (model.metodoAutenticacion == 'Tradicional') 
            CampoTexto(
              labelText: 'Número de Cédula',
              controller: model.numeroCedulaController,
              validator: (value) => validarFormLogin(value, 'cedula'),
              inputType: TextInputType.number,
              autoValidateMode: AutovalidateMode.onUserInteraction,
            ),

          CampoSelect(
            labelText: 'Método de Autenticación',
            selectedValue: model.metodoAutenticacion,
            options: ['Tradicional', 'Huella Digital', 'Face ID'],
            onChanged: (value) {
              model.setMetodoAutenticacion(value!);
            },
            validator: (value) => validarFormLogin(value, 'metodoAutenticacion'),
          ),

          if (model.metodoAutenticacion == 'Huella Digital' || model.metodoAutenticacion == 'Face ID') 
          const SizedBox(height: 20),

          if (model.metodoAutenticacion == 'Tradicional') 
            CampoTexto(
              labelText: 'Contraseña',
              controller: model.contrasenaController,
              validator: (value) => validarFormLogin(value, 'contrasena'),
              obscureText: true,
              autoValidateMode: AutovalidateMode.onUserInteraction,
            ),

          if (model.metodoAutenticacion == 'Huella Digital' || model.metodoAutenticacion == 'Face ID') 
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CustomButtonGradientRed(
                text: model.metodoAutenticacion == 'Face ID'
                  ? 'INICIAR SESIÓN CON FACE ID'
                  : 'INICIAR SESIÓN CON HUELLA DIGITAL',
              onPressed: () {
                model.authenticateBiometrics(context);
              },
              style: botonEstiloGradientRed(),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _botones(LoginProvider model, BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (model.metodoAutenticacion == 'Tradicional')
          CustomButtonGradientBlack(
            text: 'INICIAR SESIÓN',
            onPressed: () => model.submitLoginForm(context),
            style: botonEstiloGradientBlack(),
          ),
        ],
      ),
    );
  }
}

