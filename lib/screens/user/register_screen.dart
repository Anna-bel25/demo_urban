import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/register_provider.dart';
import '../../styles/buttom_style.dart';
import '../../styles/inputselect_style.dart';
import '../../styles/validation.dart';


class RegisterPage extends StatelessWidget {

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
      body: Consumer<RegisterProvider>(builder: (context, model, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
            padding: const EdgeInsets.all(16),
              child: Form(
                key: model.registerFormKey,
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
        );
      }),
    );
  }

  // Widget para el formulario de registro
  Widget _formulario(RegisterProvider model, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Register',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(height: 10),
          CampoTexto(
            labelText: 'Nombre',
            controller: model.nombreController,
            validator: (value) => validarFormRegister(value, 'nombre'),
            autoValidateMode: AutovalidateMode.onUserInteraction,
          ),
          CampoTexto(
            labelText: 'Apellido',
            controller: model.apellidoController,
            validator: (value) => validarFormRegister(value, 'apellido'),
            autoValidateMode: AutovalidateMode.onUserInteraction,
          ),
          CampoTexto(
            labelText: 'Número de Cédula',
            controller: model.numeroCedulaController,
            validator: (value) => validarFormRegister(value, 'cedula'),
            inputType: TextInputType.number,
            autoValidateMode: AutovalidateMode.onUserInteraction,
          ),
          CampoSelect(
            labelText: 'Rol',
            selectedValue: model.rol,
            options: ['Residente', 'Visitante'],
            onChanged: (value) {
              model.setRol(value!);
            },
            validator: (value) => validarFormRegister(value, 'rol'),
          ),
          if (model.rol == 'Residente')
            CampoTexto(
              labelText: 'Manzana y Villa',
              controller: model.manzanaVillaController,
              validator: (value) => validarFormRegister(value, 'manzanaVilla'),
              autoValidateMode: AutovalidateMode.onUserInteraction,
            ),
          CampoSelect(
            labelText: 'Método de Autenticación',
            selectedValue: model.metodoAutenticacion,
            options: ['Tradicional', 'Huella Digital', 'Face ID'],
            onChanged: (value) {
              model.setMetodoAutenticacion(value!);
            },
            validator: (value) => validarFormRegister(value, 'rol'),
          ),
          if (model.metodoAutenticacion == 'Tradicional')
            Column(
              children: [
                CampoTexto(
                  labelText: 'Contraseña',
                  controller: model.contrasenaController,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => validarFormRegister(value, 'contrasena'),
                  obscureText: true,
                ),
                CampoTexto(
                  labelText: 'Confirmar Contraseña',
                  controller: model.confirmContrasenaController,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value != model.contrasenaController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
              ],
            ),
          if (model.metodoAutenticacion == 'Huella Digital' || model.metodoAutenticacion == 'Face ID')
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: CustomButtonGradientRed(
                text: model.metodoAutenticacion == 'Face ID'
                    ? 'Registrar Face ID'
                    : 'Registrar Huella Digital',
                onPressed: () {
                model.authenticateBiometrics(context);
              },
                style: botonEstiloGradientRed(),
              ),
            ),
          //const SizedBox(height: 20),
        ],
      ),
    );
  }


  Widget _botones(RegisterProvider model, BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButtonGradientBlack(
            text: 'CREAR CUENTA',
            onPressed: () => model.submitRegisterForm(context),
            style: botonEstiloGradientBlack(),
          ),
        ],
      ),
    );
  }
}
