import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CompleteProfileScreen extends StatefulWidget {
  final User user;

  const CompleteProfileScreen({super.key, required this.user});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cpfController = TextEditingController();
  String? _selectedUserType;
  String? _selectedCategory;

  @override
  void dispose() {
    // Limpa os controladores para evitar vazamento de memória
    _cityController.dispose();
    _phoneController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      // Se o formulário não for válido, encerra o método
      return;
    }

    try {
      final userData = {
        'city': _cityController.text,
        'phone': _phoneController.text,
        'cpf': _cpfController.text,
        'userType': _selectedUserType,
        'category': _selectedCategory,
      };

      // Salva os dados no Firebase Realtime Database
      final databaseReference = FirebaseDatabase.instance.ref();
      await databaseReference.child('users/${widget.user.uid}').set(userData);

      if (!mounted) return;

      // Exibe uma mensagem de sucesso e volta para a tela anterior
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil salvo com sucesso!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      // Exibe uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar perfil: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Completar Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextFormField(
                controller: _cityController,
                label: 'Cidade',
                validator: (value) => value == null || value.isEmpty
                    ? 'Preencha sua cidade'
                    : null,
              ),
              _buildTextFormField(
                controller: _phoneController,
                label: 'Telefone',
                validator: (value) => value == null || value.isEmpty
                    ? 'Preencha seu telefone'
                    : null,
              ),
              _buildTextFormField(
                controller: _cpfController,
                label: 'CPF',
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Preencha seu CPF';
                  if (!CPFValidator.isValid(value)) return 'CPF inválido';
                  return null;
                },
              ),
              _buildDropdownButtonFormField(
                value: _selectedUserType,
                items: ['Cliente', 'Prestador de Serviços', 'Ambos'],
                label: 'Tipo de Usuário',
                onChanged: (value) => setState(() => _selectedUserType = value),
              ),
              _buildDropdownButtonFormField(
                value: _selectedCategory,
                items: [
                  'Autônomo',
                  'MEI',
                  'Autodidata',
                  'Técnico',
                  'Profissional',
                ],
                label: 'Categoria Profissional',
                onChanged: (value) => setState(() => _selectedCategory = value),
              ),
              TextButton(
                onPressed: () => _saveProfile(context),
                child: const Text('Salvar Perfil'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para construir campos de texto
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: validator,
    );
  }

  // Função para construir dropdowns
  Widget _buildDropdownButtonFormField({
    required String? value,
    required List<String> items,
    required String label,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label),
    );
  }
}
