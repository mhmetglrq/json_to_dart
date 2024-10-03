import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_to_dart/config/extensions/context_extensions.dart';

import '../../../../config/items/app_colors.dart';
import '../bloc/dashboard_bloc.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return LayoutBuilder(builder: (context, constaints) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: context.paddingHorizontalDefault,
                  child: Row(
                    children: [
                      Padding(
                        padding: context.paddingTopLow,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: context.dynamicHeight(0.005),
                          width: context.dynamicWidth(0.11),
                          color: AppColors.kPrimaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.kNeutral30,
                    ),
                  ),
                  color: AppColors.kNeutral10,
                ),
                padding: context.paddingHorizontalDefault,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                            text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'JSON',
                              style: context.textTheme.titleLarge?.copyWith(
                                color: state.currentRoute == "jsonToDart"
                                    ? AppColors.kPrimaryLight
                                    : AppColors.kBlack,
                              ),
                            ),
                            TextSpan(
                              text: ' to ',
                              style: context.textTheme.titleLarge?.copyWith(
                                color: AppColors.kNeutral70,
                              ),
                            ),
                            TextSpan(
                              text: 'Dart',
                              style: context.textTheme.titleLarge?.copyWith(
                                color: state.currentRoute == "jsonToDart"
                                    ? AppColors.kPrimaryLight
                                    : AppColors.kBlack,
                              ),
                            ),
                          ],
                        )),
                        // Text(
                        //   'Never Ever',
                        //   style: context.textTheme.titleLarge?.copyWith(
                        //     color: state.currentRoute == "jsonToDart"
                        //         ? AppColors.kPrimaryLight
                        //         : AppColors.kBlack,
                        //   ),
                        // ),
                      ],
                    ),

                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
