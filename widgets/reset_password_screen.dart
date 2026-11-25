import 'package:flutter/material.dart';
import '../services/request_catcher_service.dart';
import 'sign_in_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrLoginController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _emailOrLoginController.dispose();
    super.dispose();
  }

  Future<void> _onResetPressed() async {
    if (!_formKey.currentState!.validate() || _isSending) return;

    setState(() => _isSending = true);
    try {
      final response = await RequestCatcherService.sendAction(
        action: 'reset',
        payload: {
          'emailOrLogin': _emailOrLoginController.text.trim(),
        },
      );
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Успішно'),
          content: Text(
            'Запит Reset надіслано на RequestCatcher (код ${response.statusCode}).',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Помилка'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png',
                height: 80,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailOrLoginController,
                validator: checkEmail,
                decoration: const InputDecoration(
                  labelText: 'Email / Login:',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSending ? null : _onResetPressed,
                child: Text(_isSending ? 'Sending...' : 'Reset'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}