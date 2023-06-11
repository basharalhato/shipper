import 'package:shipper/core/core_features/theme/presentation/utils/themes/cupertino_custom_theme.dart';
import 'package:shipper/core/presentation/helpers/localization_helper.dart';
import 'package:shipper/core/presentation/utils/validators.dart';
import 'package:shipper/core/presentation/widgets/custom_text_form_field.dart';
import 'package:shipper/core/presentation/widgets/platform_widgets/platform_icons.dart';
import 'package:shipper/core/presentation/widgets/platform_widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shipper/core/presentation/styles/sizes.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginTextFieldsSection extends ConsumerWidget {
  const LoginTextFieldsSection({
    required this.emailController,
    required this.passwordController,
    required this.onFieldSubmitted,
    Key? key,
  }) : super(key: key);

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context, ref) {
    return PlatformWidget(
      material: (_) {
        return Column(
          children: _sharedItemComponent(context, ref, isMaterial: true),
        );
      },
      cupertino: (_) {
        return CupertinoFormSection.insetGrouped(
          decoration:
              CupertinoCustomTheme.cupertinoFormSectionDecoration(context),
          backgroundColor: Colors.transparent,
          margin: EdgeInsets.zero,
          children: _sharedItemComponent(context, ref, isMaterial: false),
        );
      },
    );
  }

  List<Widget> _sharedItemComponent(
    BuildContext context,
    WidgetRef ref, {
    required bool isMaterial,
  }) {
    return [
      CustomTextFormField(
        key: const ValueKey('login_email'),
        hintText: tr(context).email,
        controller: emailController,
        validator: ref.watch(validatorsProvider).validateEmail(context),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        suffix: Icon(PlatformIcons.mail),
      ),
      if (isMaterial)
        SizedBox(
          height: Sizes.textFieldMarginV24(context),
        ),
      CustomTextFormField(
        key: const ValueKey('login_password'),
        hintText: tr(context).password,
        controller: passwordController,
        validator: ref.watch(validatorsProvider).validateLoginPassword(context),
        textInputAction: TextInputAction.go,
        obscureText: true,
        suffix: Icon(PlatformIcons.password),
        onFieldSubmitted: onFieldSubmitted,
      ),
    ];
  }
}
