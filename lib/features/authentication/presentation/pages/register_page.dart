import 'package:diar_tunis/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:diar_tunis/features/shared/widgets/custom_buttom.dart';
import 'package:diar_tunis/features/shared/widgets/custom_loading_overlay.dart';
import 'package:diar_tunis/features/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  // Service Provider specific controllers
  final _businessNameController = TextEditingController();
  final _businessDescriptionController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _yearsOfExperienceController = TextEditingController();

  String _selectedUserType = 'guest';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _businessNameController.dispose();
    _businessDescriptionController.dispose();
    _licenseNumberController.dispose();
    _yearsOfExperienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to appropriate home screen based on user type
            _navigateToHome(state.user.userType);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return LoadingOverlay(
            isLoading: state is AuthLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Welcome text
                    Text(
                      'Join Diar Tunis',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create your account to start your journey',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // User Type Selection
                    _buildUserTypeSelection(),
                    const SizedBox(height: 24),

                    // Basic Information
                    _buildBasicInformationSection(),
                    const SizedBox(height: 24),

                    // Contact Information (Optional)
                    _buildContactInformationSection(),

                    // Service Provider specific fields
                    if (_selectedUserType == 'service_provider') ...[
                      const SizedBox(height: 24),
                      _buildServiceProviderSection(),
                    ],

                    const SizedBox(height: 32),

                    // Register Button
                    CustomButton(
                      text: 'Create Account',
                      onPressed: _isLoading ? null : _handleRegister,
                      isLoading: _isLoading,
                    ),

                    const SizedBox(height: 16),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),

                    // Error messages
                    if (state is AuthError && state.hasValidationErrors) ...[
                      const SizedBox(height: 16),
                      _buildErrorMessages(state.validationErrorMessages),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I want to:',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            _UserTypeOption(
              value: 'guest',
              groupValue: _selectedUserType,
              title: 'Find Places to Stay',
              subtitle: 'Book unique accommodations and experiences',
              icon: Icons.search,
              onChanged: (value) => setState(() => _selectedUserType = value!),
            ),
            const SizedBox(height: 8),
            _UserTypeOption(
              value: 'host',
              groupValue: _selectedUserType,
              title: 'Host My Property',
              subtitle: 'List my property and earn money',
              icon: Icons.home,
              onChanged: (value) => setState(() => _selectedUserType = value!),
            ),
            const SizedBox(height: 8),
            _UserTypeOption(
              value: 'service_customer',
              groupValue: _selectedUserType,
              title: 'Find Home Services',
              subtitle: 'Book handyman, plumbing, and repair services',
              icon: Icons.build,
              onChanged: (value) => setState(() => _selectedUserType = value!),
            ),
            const SizedBox(height: 8),
            _UserTypeOption(
              value: 'service_provider',
              groupValue: _selectedUserType,
              title: 'Offer Services',
              subtitle: 'Provide home repair and maintenance services',
              icon: Icons.work,
              onChanged: (value) => setState(() => _selectedUserType = value!),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBasicInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _nameController,
          labelText: 'Full Name',
          prefixIcon: Icon(Icons.person),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your full name';
            }
            if (value.length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _emailController,
          labelText: 'Email Address',
          prefixIcon: Icon(Icons.email),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email address';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _passwordController,
          labelText: 'Password',
          prefixIcon: Icon(Icons.lock),
          obscureText: !_isPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () =>
                setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _confirmPasswordController,
          labelText: 'Confirm Password',
          prefixIcon: Icon(Icons.lock),
          obscureText: !_isConfirmPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              _isConfirmPasswordVisible
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
            onPressed: () => setState(
              () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildContactInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information (Optional)',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _phoneController,
          labelText: 'Phone Number',
          prefixIcon: Icon(Icons.phone),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _addressController,
          labelText: 'Address',
          prefixIcon: Icon(Icons.location_on),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildServiceProviderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Information',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _businessNameController,
          labelText: 'Business Name *',
          prefixIcon: Icon(Icons.business),
          validator: _selectedUserType == 'service_provider'
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your business name';
                  }
                  return null;
                }
              : null,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _businessDescriptionController,
          labelText: 'Business Description *',
          prefixIcon: Icon(Icons.description),
          maxLines: 3,
          validator: _selectedUserType == 'service_provider'
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe your business';
                  }
                  return null;
                }
              : null,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _licenseNumberController,
          labelText: 'License Number (if applicable)',
          prefixIcon: Icon(Icons.card_membership),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _yearsOfExperienceController,
          labelText: 'Years of Experience',
          prefixIcon: Icon(Icons.work_history),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildErrorMessages(List<String> errors) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: Colors.red[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error, color: Colors.red[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Please fix the following errors:',
                style: TextStyle(
                  color: Colors.red[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...errors.map(
            (error) => Padding(
              padding: const EdgeInsets.only(left: 28, bottom: 4),
              child: Text('• $error', style: TextStyle(color: Colors.red[700])),
            ),
          ),
        ],
      ),
    );
  }

  bool get _isLoading => context.read<AuthCubit>().state is AuthLoading;

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthCubit>().register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      userType: _selectedUserType,
      phone: _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : null,
      address: _addressController.text.trim().isNotEmpty
          ? _addressController.text.trim()
          : null,
      businessName:
          _selectedUserType == 'service_provider' &&
              _businessNameController.text.trim().isNotEmpty
          ? _businessNameController.text.trim()
          : null,
      businessDescription:
          _selectedUserType == 'service_provider' &&
              _businessDescriptionController.text.trim().isNotEmpty
          ? _businessDescriptionController.text.trim()
          : null,
      licenseNumber: _licenseNumberController.text.trim().isNotEmpty
          ? _licenseNumberController.text.trim()
          : null,
      yearsOfExperience: _yearsOfExperienceController.text.trim().isNotEmpty
          ? int.tryParse(_yearsOfExperienceController.text.trim())
          : null,
    );
  }

  void _navigateToHome(String userType) {
    switch (userType) {
      case 'guest':
      case 'service_customer':
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/guest-home',
          (route) => false,
        );
        break;
      case 'host':
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/host-home',
          (route) => false,
        );
        break;
      case 'service_provider':
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/service-provider-home',
          (route) => false,
        );
        break;
      case 'admin':
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/admin-home',
          (route) => false,
        );
        break;
      default:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/guest-home',
          (route) => false,
        );
    }
  }
}

class _UserTypeOption extends StatelessWidget {
  final String value;
  final String groupValue;
  final String title;
  final String subtitle;
  final IconData icon;
  final ValueChanged<String?> onChanged;

  const _UserTypeOption({
    required this.value,
    required this.groupValue,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 12),
            Icon(
              icon,
              size: 32,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey[600],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Theme.of(context).primaryColor : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
