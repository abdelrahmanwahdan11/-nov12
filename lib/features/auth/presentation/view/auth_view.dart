import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/theme/animations.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/glass_container.dart';
import '../widgets/auth_layout_metrics.dart';
import '../widgets/auth_visual_panel.dart';

enum _AuthMode { login, signup, forgot }

final RegExp _emailRegex = RegExp('^[\\w-.]+@([\\w-]+\\.)+[\\w-]{2,4}');

double _evaluatePasswordStrength(String password) {
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
  const specials = '!@#&*~%+=?';
  return specials.split('').any(value.contains);
}

class AuthView extends ConsumerStatefulWidget {
  const AuthView({super.key});

  @override
  ConsumerState<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _resetFormKey = GlobalKey<FormState>();

  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  final TextEditingController _signupEmailController = TextEditingController();
  final TextEditingController _signupPasswordController = TextEditingController();
  final TextEditingController _signupConfirmController = TextEditingController();
  final TextEditingController _resetEmailController = TextEditingController();

  bool _loginObscurePassword = true;
  bool _signupObscurePassword = true;
  bool _signupObscureConfirmPassword = true;

  double _loginPasswordStrength = 0;
  double _signupPasswordStrength = 0;

  _AuthMode _mode = _AuthMode.login;

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _signupConfirmController.dispose();
    _resetEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isRtl = localization.isRtl;
    final mediaQuery = MediaQuery.of(context);
    final mediaPadding = mediaQuery.padding;
    final viewInsets = mediaQuery.viewInsets;
    final topToolbarPadding = mediaPadding.top + kToolbarHeight;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(_titleForMode(localization)),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Opacity(
            opacity: 0.9,
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.aurora),
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppGradients.background(theme.brightness),
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final metrics = AuthLayoutMetrics.resolve(mediaQuery, constraints);

                final formContent = Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: metrics.formMaxWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GlassContainer(
                          borderRadius: AppRadiusTokens.xl,
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _subtitleForMode(localization),
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: AppSpacingTokens.base * 3),
                          LayoutBuilder(
                                builder: (context, segmentedConstraints) {
                                  final segmented = SegmentedButton<_AuthMode>(
                                    segments: [
                                      ButtonSegment<_AuthMode>(
                                        value: _AuthMode.login,
                                        icon: const Icon(IconlyLight.login),
                                        label: Text(localization.translate('login')),
                                      ),
                                      ButtonSegment<_AuthMode>(
                                        value: _AuthMode.signup,
                                        icon: const Icon(IconlyLight.add_user),
                                        label: Text(localization.translate('signup')),
                                      ),
                                      ButtonSegment<_AuthMode>(
                                        value: _AuthMode.forgot,
                                        icon: const Icon(IconlyLight.password),
                                        label: Text(localization.translate('forgot_password')),
                                      ),
                                    ],
                                    showSelectedIcon: false,
                                    selected: <_AuthMode>{_mode},
                                    onSelectionChanged: (selection) => _switchMode(selection.first),
                                    style: ButtonStyle(
                                      minimumSize: MaterialStateProperty.all(const Size.fromHeight(50)),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                      ),
                                      textStyle: MaterialStateProperty.all(
                                        theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                                      ),
                                      padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      ),
                                      visualDensity: VisualDensity.comfortable,
                                      side: MaterialStateProperty.all(
                                        BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
                                      ),
                                      foregroundColor: MaterialStateProperty.resolveWith(
                                        (states) => states.contains(MaterialState.selected)
                                            ? theme.colorScheme.onPrimary
                                            : theme.colorScheme.onSurfaceVariant,
                                      ),
                                      backgroundColor: MaterialStateProperty.resolveWith(
                                        (states) => states.contains(MaterialState.selected)
                                            ? theme.colorScheme.primary.withOpacity(0.18)
                                            : theme.colorScheme.surface.withOpacity(0.2),
                                      ),
                                    ),
                                  );

                                  if (segmentedConstraints.maxWidth <= 420) {
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.zero,
                                      child: IntrinsicWidth(child: segmented),
                                    );
                                  }

                                  return segmented;
                                },
                              ),
                              const SizedBox(height: AppSpacingTokens.base * 3),
                              AnimatedSwitcher(
                                duration: AppAnimations.medium,
                                transitionBuilder: (child, animation) => FadeTransition(
                                  opacity: animation,
                                  child: SizeTransition(sizeFactor: animation, child: child),
                                ),
                                child: _buildFormForMode(localization, theme),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacingTokens.base * 4),
                        _GuestAccessCard(
                          onGuest: () async {
                            FocusScope.of(context).unfocus();
                            await ref.read(authSessionProvider.notifier).startGuestSession();
                            if (!mounted) {
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(localization.translate('snackbar_guest_mock'))),
                            );
                            if (mounted) {
                              context.go('/create');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );

                final formScrollView = SingleChildScrollView(
                  padding: metrics.formPadding.add(EdgeInsets.only(bottom: viewInsets.bottom)),
                  child: formContent,
                );

                if (!metrics.showHero) {
                  return formScrollView;
                }

                final heroAvailableHeight = constraints.maxHeight.isFinite
                    ? constraints.maxHeight -
                        metrics.heroPadding.resolve(Directionality.of(context)).vertical
                    : double.infinity;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: metrics.heroFlex,
                      child: Padding(
                        padding: metrics.heroPadding,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: metrics.heroMaxWidth,
                              maxHeight: heroAvailableHeight.isFinite
                                  ? heroAvailableHeight.clamp(320, double.infinity).toDouble()
                                  : double.infinity,
                            ),
                            child: AspectRatio(
                              aspectRatio: metrics.heroAspectRatio,
                              child: AuthVisualPanel(
                                localization: localization,
                                isRtl: isRtl,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(flex: metrics.formFlex, child: formScrollView),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormForMode(AppLocalizations localization, ThemeData theme) {
    switch (_mode) {
      case _AuthMode.login:
        return _LoginForm(
          key: const ValueKey('login_form'),
          formKey: _loginFormKey,
          emailController: _loginEmailController,
          passwordController: _loginPasswordController,
          obscurePassword: _loginObscurePassword,
          passwordStrength: _loginPasswordStrength,
          localization: localization,
          theme: theme,
          onPasswordChanged: (value) => setState(() => _loginPasswordStrength = _evaluatePasswordStrength(value)),
          onToggleObscure: () => setState(() => _loginObscurePassword = !_loginObscurePassword),
          onSubmit: () async {
            if (_loginFormKey.currentState?.validate() ?? false) {
              FocusScope.of(context).unfocus();
              final email = _loginEmailController.text.trim();
              await ref.read(authSessionProvider.notifier).signIn(email: email);
              if (!mounted) {
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localization.translate('snackbar_login_mock'))),
              );
              if (mounted) {
                context.go('/create');
              }
            }
          },
          onForgotPassword: () => _switchMode(_AuthMode.forgot),
          onGoToSignup: () => _switchMode(_AuthMode.signup),
        );
      case _AuthMode.signup:
        return _SignupForm(
          key: const ValueKey('signup_form'),
          formKey: _signupFormKey,
          emailController: _signupEmailController,
          passwordController: _signupPasswordController,
          confirmController: _signupConfirmController,
          obscurePassword: _signupObscurePassword,
          obscureConfirmPassword: _signupObscureConfirmPassword,
          passwordStrength: _signupPasswordStrength,
          localization: localization,
          theme: theme,
          onPasswordChanged: (value) => setState(() => _signupPasswordStrength = _evaluatePasswordStrength(value)),
          onTogglePassword: () => setState(() => _signupObscurePassword = !_signupObscurePassword),
          onToggleConfirm: () => setState(() => _signupObscureConfirmPassword = !_signupObscureConfirmPassword),
          onSubmit: () async {
            if (_signupFormKey.currentState?.validate() ?? false) {
              FocusScope.of(context).unfocus();
              final email = _signupEmailController.text.trim();
              await ref.read(authSessionProvider.notifier).signUp(email: email);
              if (!mounted) {
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localization.translate('snackbar_signup_mock'))),
              );
              if (mounted) {
                context.go('/create');
              }
            }
          },
          onGoToLogin: () => _switchMode(_AuthMode.login),
        );
      case _AuthMode.forgot:
        return _ForgotForm(
          key: const ValueKey('forgot_form'),
          formKey: _resetFormKey,
          emailController: _resetEmailController,
          localization: localization,
          theme: theme,
          onSubmit: () {
            if (_resetFormKey.currentState?.validate() ?? false) {
              FocusScope.of(context).unfocus();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localization.translate('snackbar_reset_mock'))),
              );
            }
          },
          onGoToLogin: () => _switchMode(_AuthMode.login),
          onGoToSignup: () => _switchMode(_AuthMode.signup),
        );
    }
  }

  void _switchMode(_AuthMode mode) {
    if (_mode == mode) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _mode = mode;
      if (mode != _AuthMode.login) {
        _loginPasswordStrength = 0;
      }
      if (mode != _AuthMode.signup) {
        _signupPasswordStrength = 0;
      }
    });
  }

  String _titleForMode(AppLocalizations localization) {
    switch (_mode) {
      case _AuthMode.login:
        return localization.translate('login');
      case _AuthMode.signup:
        return localization.translate('signup');
      case _AuthMode.forgot:
        return localization.translate('forgot_password');
    }
  }

  String _subtitleForMode(AppLocalizations localization) {
    switch (_mode) {
      case _AuthMode.login:
        return localization.translate('auth_subtitle_login');
      case _AuthMode.signup:
        return localization.translate('auth_subtitle_signup');
      case _AuthMode.forgot:
        return localization.translate('auth_subtitle_forgot');
    }
  }

}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.passwordStrength,
    required this.localization,
    required this.theme,
    required this.onPasswordChanged,
    required this.onToggleObscure,
    required this.onSubmit,
    required this.onForgotPassword,
    required this.onGoToSignup,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final double passwordStrength;
  final AppLocalizations localization;
  final ThemeData theme;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;
  final VoidCallback onGoToSignup;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
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
          const SizedBox(height: AppSpacingTokens.base * 2),
          TextFormField(
            controller: passwordController,
            obscureText: obscurePassword,
            onChanged: onPasswordChanged,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(
              labelText: localization.translate('label_password'),
              prefixIcon: const Icon(IconlyLight.lock),
              suffixIcon: IconButton(
                onPressed: onToggleObscure,
                icon: Icon(obscurePassword ? IconlyLight.show : IconlyLight.hide),
                tooltip: localization.translate(
                  obscurePassword ? 'action_show_password' : 'action_hide_password',
                ),
              ),
            ),
            validator: (value) {
              final password = value ?? '';
              if (_evaluatePasswordStrength(password) < 0.75) {
                return localization.translate('error_password_requirements');
              }
              return null;
            },
            onFieldSubmitted: (_) => onSubmit(),
          ),
          const SizedBox(height: AppSpacingTokens.base * 1.5),
          PasswordStrengthBar(
            strength: passwordStrength,
            localization: localization,
            theme: theme,
          ),
          const SizedBox(height: AppSpacingTokens.base * 3),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: onForgotPassword,
              child: Text(localization.translate('forgot_password')),
            ),
          ),
          const SizedBox(height: AppSpacingTokens.base * 2),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onSubmit,
              child: Text(localization.translate('login')),
            ),
          ),
          const SizedBox(height: AppSpacingTokens.base * 2),
          Center(
            child: TextButton(
              onPressed: onGoToSignup,
              child: Text(localization.translate('auth_prompt_no_account')),
            ),
          ),
          ],
        ),
      ),
    );
  }
}

class _SignupForm extends StatelessWidget {
  const _SignupForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.confirmController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.passwordStrength,
    required this.localization,
    required this.theme,
    required this.onPasswordChanged,
    required this.onTogglePassword,
    required this.onToggleConfirm,
    required this.onSubmit,
    required this.onGoToLogin,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final double passwordStrength;
  final AppLocalizations localization;
  final ThemeData theme;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirm;
  final VoidCallback onSubmit;
  final VoidCallback onGoToLogin;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
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
          const SizedBox(height: AppSpacingTokens.base * 2),
          TextFormField(
            controller: passwordController,
            obscureText: obscurePassword,
            onChanged: onPasswordChanged,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.newPassword],
            decoration: InputDecoration(
              labelText: localization.translate('label_password'),
              prefixIcon: const Icon(IconlyLight.lock),
              suffixIcon: IconButton(
                onPressed: onTogglePassword,
                icon: Icon(obscurePassword ? IconlyLight.show : IconlyLight.hide),
                tooltip: localization.translate(
                  obscurePassword ? 'action_show_password' : 'action_hide_password',
                ),
              ),
            ),
            validator: (value) {
              final password = value ?? '';
              if (_evaluatePasswordStrength(password) < 0.75) {
                return localization.translate('error_password_requirements');
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacingTokens.base * 1.5),
          PasswordStrengthBar(
            strength: passwordStrength,
            localization: localization,
            theme: theme,
          ),
          const SizedBox(height: AppSpacingTokens.base * 2),
          TextFormField(
            controller: confirmController,
            obscureText: obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.newPassword],
            decoration: InputDecoration(
              labelText: localization.translate('label_confirm_password'),
              prefixIcon: const Icon(IconlyLight.password),
              suffixIcon: IconButton(
                onPressed: onToggleConfirm,
                icon: Icon(obscureConfirmPassword ? IconlyLight.show : IconlyLight.hide),
                tooltip: localization.translate(
                  obscureConfirmPassword ? 'action_show_password' : 'action_hide_password',
                ),
              ),
            ),
            validator: (value) {
              if (value != passwordController.text) {
                return localization.translate('error_password_mismatch');
              }
              return null;
            },
            onFieldSubmitted: (_) => onSubmit(),
          ),
          const SizedBox(height: AppSpacingTokens.base * 3),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onSubmit,
              child: Text(localization.translate('signup')),
            ),
          ),
          const SizedBox(height: AppSpacingTokens.base * 2),
          Center(
            child: TextButton(
              onPressed: onGoToLogin,
              child: Text(localization.translate('auth_prompt_have_account')),
            ),
          ),
          ],
        ),
      ),
    );
  }
}

class _ForgotForm extends StatelessWidget {
  const _ForgotForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.localization,
    required this.theme,
    required this.onSubmit,
    required this.onGoToLogin,
    required this.onGoToSignup,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final AppLocalizations localization;
  final ThemeData theme;
  final VoidCallback onSubmit;
  final VoidCallback onGoToLogin;
  final VoidCallback onGoToSignup;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.email],
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
            onFieldSubmitted: (_) => onSubmit(),
          ),
          const SizedBox(height: AppSpacingTokens.base * 3),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onSubmit,
              child: Text(localization.translate('cta_send_reset')),
            ),
          ),
          const SizedBox(height: AppSpacingTokens.base * 2),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacingTokens.base * 2,
            runSpacing: AppSpacingTokens.base,
            children: [
              TextButton(
                onPressed: onGoToLogin,
                child: Text(localization.translate('auth_prompt_remembered')),
              ),
              TextButton(
                onPressed: onGoToSignup,
                child: Text(localization.translate('auth_prompt_need_account')),
              ),
            ],
          ),
          ],
        ),
      ),
    );
  }
}

class PasswordStrengthBar extends StatelessWidget {
  const PasswordStrengthBar({
    super.key,
    required this.strength,
    required this.localization,
    required this.theme,
  });

  final double strength;
  final AppLocalizations localization;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final label = _strengthLabel(localization, strength);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localization.translate('password_strength'),
              style: theme.textTheme.labelLarge,
            ),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.secondary),
            ),
          ],
        ),
        const SizedBox(height: AppSpacingTokens.base * 0.75),
        ClipRRect(
          borderRadius: AppRadiusTokens.sm,
          child: SizedBox(
            height: 8,
            child: LinearProgressIndicator(
              value: strength.clamp(0, 1),
              backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.lerp(
                  theme.colorScheme.error,
                  theme.colorScheme.primary,
                  strength.clamp(0, 1),
                )!,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static String _strengthLabel(AppLocalizations localization, double strength) {
    if (strength >= 0.85) {
      return localization.translate('password_strength_strong');
    }
    if (strength >= 0.6) {
      return localization.translate('password_strength_medium');
    }
    if (strength >= 0.35) {
      return localization.translate('password_strength_weak');
    }
    return localization.translate('password_strength_very_weak');
  }
}

class _GuestAccessCard extends StatelessWidget {
  const _GuestAccessCard({required this.onGuest});

  final VoidCallback onGuest;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return GlassContainer(
      borderRadius: AppRadiusTokens.lg,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(IconlyBold.profile, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacingTokens.base * 2),
              Expanded(
                child: Text(
                  localization.translate('guest_mode'),
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacingTokens.base * 1.5),
          Text(
            localization.translate('guest_mode_subtitle'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacingTokens.base * 2.5),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onGuest,
              icon: const Icon(IconlyLight.play),
              label: Text(localization.translate('guest_mode_cta')),
            ),
          ),
        ],
      ),
    );
  }
}
