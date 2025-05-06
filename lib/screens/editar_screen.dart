import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/users_provider.dart';
import '../models/user.dart';

class EditarScreen extends StatefulWidget {
  const EditarScreen({super.key});

  @override
  State<EditarScreen> createState() => _EditarScreenState();
}

class _EditarScreenState extends State<EditarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<UserProvider>(context, listen: false).loggedInUser;
    if (user != null) {
      _nameController.text = user.name;
      _ageController.text = user.age.toString();
      _emailController.text = user.email;
      _passwordController.text = user.password; // Prellenar con la contraseña actual
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'El nom és obligatori' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Edat'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'L\'edat és obligatòria';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age <= 0) {
                    return 'Introdueix una edat vàlida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Correu electrònic'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'El correu és obligatori' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contrasenya'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La contrasenya és obligatòria';
                  }
                  if (value.length < 6) {
                    return 'La contrasenya ha de tenir almenys 6 caràcters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final updatedUser = User(
                      id: userProvider.loggedInUser?.id,
                      name: _nameController.text,
                      age: int.parse(_ageController.text),
                      email: _emailController.text,
                      password: _passwordController.text, // Actualizar la contraseña
                    );

                    final success = await userProvider.updateUser(updatedUser);

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Perfil actualitzat correctament'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Error actualitzant el perfil: ${userProvider.error ?? "Error desconegut"}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text('Guardar Canvis'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}