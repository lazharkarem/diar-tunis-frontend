import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;
  final Function(String email, String password) onSubmit;
  final Function(
    String email,
    String password,
    String firstName,
    String lastName,
    String userType,
  )?
  onRegister;
  final bool isLoading;

  const AuthForm({
    super.key,
    required this.isLogin,
    required this.onSubmit,
    this.onRegister,
    this.isLoading = false,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _isPasswordVisible = false;
  String _selectedUserType = 'guest';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (!widget.isLogin) ...[
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (!widget.isLogin && value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),

          if (!widget.isLogin) ...[
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedUserType,
              decoration: const InputDecoration(
                labelText: 'User Type',
                prefixIcon: Icon(Icons.account_circle_outlined),
              ),
              items: const [
                DropdownMenuItem(value: 'guest', child: Text('Guest')),
                DropdownMenuItem(value: 'host', child: Text('Host')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedUserType = value!;
                });
              },
            ),
          ],

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _handleSubmit,
              child: widget.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(widget.isLogin ? 'Login' : 'Register'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (widget.isLogin) {
        widget.onSubmit(_emailController.text, _passwordController.text);
      } else {
        widget.onRegister!(
          _emailController.text,
          _passwordController.text,
          _firstNameController.text,
          _lastNameController.text,
          _selectedUserType,
        );
      }
    }
  }
}
