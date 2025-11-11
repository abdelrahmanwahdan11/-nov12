import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/animations.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class AuthView extends ConsumerStatefulWidget {
  const AuthView({super.key});

  @override
  ConsumerState<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView> {
  static final RegExp _emailRegex = RegExp('^[\\w-.]+@([\\w-]+\\.)+[\\w-]{2,4}');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  double _passwordStrength = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isRtl = localization.isRtl;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(localization.translate('login')),
          flexibleSpace: Opacity(
            opacity: 0.9,
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.aurora),
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: GlassContainer(
              borderRadius: AppRadiusTokens.lg,
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localization.translate('auth_subtitle_login'),
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: localization.translate('label_email'),
                        prefixIcon: const Icon(IconlyLight.message),
                      ),
                      validator: (value) {
                        final email = value?.trim() ?? '';
                        if (!_emailRegex.hasMatch(email)) {
                          return localization.translate('error_invalid_email');
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      onChanged: (value) => setState(() => _passwordStrength = _evaluatePassword(value)),
                      decoration: InputDecoration(
                        labelText: localization.translate('label_password'),
                        prefixIcon: const Icon(IconlyLight.lock),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          icon: Icon(_obscurePassword ? IconlyLight.show : IconlyLight.hide),
                          tooltip: localization.translate(
                            _obscurePassword ? 'action_show_password' : 'action_hide_password',
                          ),
                        ),
                      ),
                      validator: (value) {
                        final password = value ?? '';
                        if (_evaluatePassword(password) < 0.75) {
                          return localization.translate('error_password_requirements');
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    AnimatedContainer(
                      duration: AppAnimations.medium,
                      height: 8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadiusTokens.sm),
                        color: theme.colorScheme.primary.withOpacity(0.18),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _passwordStrength.clamp(0, 1),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadiusTokens.sm),
                            gradient: LinearGradient(
                              colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(localization.translate('snackbar_login_mock')),
                              ),
                            );
                          }
                        },
                        child: Text(localization.translate('login')),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        child: Text(localization.translate('forgot_password')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _evaluatePassword(String password) {
    double score = 0;
    if (password.length >= 8) {
      score += 0.25;
    }
    if (password.contains(RegExp('[A-Z]'))) {
      score += 0.2;
    }
    if (password.contains(RegExp('[a-z]'))) {
      score += 0.2;
    }
    if (password.contains(RegExp('[0-9]'))) {
      score += 0.2;
    }
    if (_containsSpecial(password)) {
      score += 0.15;
    }
    return score.clamp(0, 1);
  }

  bool _containsSpecial(String value) {
    const specials = '!@#&*~';
    return specials.split('').any(value.contains);
  }
}
