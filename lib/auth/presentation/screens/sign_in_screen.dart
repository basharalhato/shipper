import 'package:shipper/auth/presentation/components/app_logo_component.dart';
import 'package:shipper/auth/presentation/components/login_form_component.dart';
import 'package:shipper/auth/presentation/components/welcome_component.dart';
import 'package:shipper/auth/presentation/providers/sign_in_provider.dart';
import 'package:shipper/core/data/error/app_exception.dart';
import 'package:shipper/core/presentation/extensions/app_error_extension.dart';
import 'package:shipper/core/presentation/routing/navigation_service.dart';
import 'package:shipper/core/presentation/screens/full_screen_platfom_scaffold.dart';
import 'package:shipper/core/presentation/styles/app_images.dart';
import 'package:shipper/core/presentation/utils/dialogs.dart';
import 'package:shipper/core/presentation/utils/scroll_behaviors.dart';
import 'package:flutter/material.dart';
import 'package:shipper/core/presentation/styles/sizes.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    ref.listen<AsyncValue<void>>(
      signInStateProvider,
      (prevState, newState) {
        prevState?.unwrapPrevious().whenOrNull(
              loading: () => NavigationService.dismissDialog(context),
            );
        newState.unwrapPrevious().whenOrNull(
              loading: () => Dialogs.showLoadingDialog(context),
              error: (err, st) {
                Dialogs.showErrorDialog(
                  context,
                  message: (err as AppException).errorMessage(context),
                );
              },
            );
      },
    );

    return FullScreenPlatformScaffold(
      body: ScrollConfiguration(
        behavior: MainScrollBehavior(),
        child: SingleChildScrollView(
          child: Container(
            constraints:
                BoxConstraints(minHeight: Sizes.fullScreenHeight(context)),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  AppImages.loginBackground,
                ),
                fit: BoxFit.fill,
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: Sizes.screenPaddingV80(context),
              horizontal: Sizes.screenPaddingH40(context),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLogoComponent(),
                SizedBox(
                  height: Sizes.marginV30(context),
                ),
                const WelcomeComponent(),
                SizedBox(
                  height: Sizes.marginV30(context),
                ),
                const LoginFormComponent(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
