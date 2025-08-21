import 'package:flutter/material.dart';
  import 'package:flutter_svg/flutter_svg.dart';
  import 'package:uot_transport_driver_flutter/core/app_colors.dart';
  import 'package:uot_transport_driver_flutter/core/app_icons.dart';

  class UotAppbar extends StatelessWidget implements PreferredSizeWidget {
    const UotAppbar({super.key});

    @override
    Widget build(BuildContext context) {
      final double screenWidth = MediaQuery.of(context).size.width;
      final double logoSize = screenWidth * 0.15; // 15% of screen width
      final double leadingPadding = screenWidth * 0.025; // 2.5% of screen width

      return Directionality(
        textDirection: TextDirection.rtl,
        child: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(right: leadingPadding),
            child: Image.asset(
              AppIcons.logoPath,
              width: logoSize,
              height: logoSize,
            ),
          ),
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                AppIcons.outline_NotificationsAppPath,
                width: screenWidth * 0.05,
                height: screenWidth * 0.055,
                color: AppColors.primaryColor,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: SvgPicture.asset(
                AppIcons.outline_SearchAppPath,
                width: screenWidth * 0.06,
                height: screenWidth * 0.06,
                color: AppColors.primaryColor,
              ),
              onPressed: () {},
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: const Color(0xffCED2D8),
              height: 1.0,
            ),
          ),
        ),
      );
    }

    @override
    Size get preferredSize => const Size.fromHeight(56);
  }