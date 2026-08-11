import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syriacosmeticsmanger/features/pos/controllers/barcode_scan_controller.dart';
import 'package:syriacosmeticsmanger/features/dashboard/controllers/bottom_menu_controller.dart';
import 'package:syriacosmeticsmanger/utill/dimensions.dart';
import 'package:syriacosmeticsmanger/utill/images.dart';
import 'package:syriacosmeticsmanger/features/dashboard/widgets/gradient_border_widget.dart';
import 'package:syriacosmeticsmanger/features/menu/widgets/menu_widget.dart';

import '../../../localization/language_constrants.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({super.key});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomMenuController>(builder: (context, menuController, _) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true, // 👈 مهم جداً حتى ينزل المحتوى خلف الشريط ويطلع تأثير الزجاج
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        body: PageStorage(bucket: bucket, child: menuController.currentScreen),

        floatingActionButton: UnicornOutlineButtonWidget(strokeWidth: 0, radius: 50,
          gradient: LinearGradient(colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          child: FloatingActionButton(backgroundColor: Theme.of(context).primaryColor, elevation: 1,
            onPressed: () {
              Provider.of<BarcodeScanController>(context, listen: false).scanProductBarCode(context);
            },
            child: Padding(padding: const EdgeInsets.all(15.0),
                child: Image.asset(Images.scanner)),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        // 👇 الشريط الجديد: عائم + زجاجي
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // قوة الضبابية
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: (Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
                      Theme.of(context).cardColor)
                      .withValues(alpha: 0.6), // الشفافية — نزلها أو طلّعها حسب الذوق
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customBottomItem(tap: () => menuController.selectHomePage(),
                        icon: Images.pos,
                        name: getTranslated('pos', context)!, selectIndex: 0),
                    customBottomItem(tap: () => menuController.selectPosScreen(),
                        icon: Images.order,
                        name: getTranslated('my_order', context)!, selectIndex: 1),
                    const SizedBox(height: 20, width: 20),
                    customBottomItem(tap: () => menuController.selectItemsScreen(),
                        icon: Images.productIcon,
                        name: getTranslated('products', context)!, selectIndex: 2),
                    customBottomItem(tap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (con) => const MenuBottomSheetWidget(),
                      );
                    },
                        icon: Images.menu,
                        name: getTranslated('menu', context)!, selectIndex: 3),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget customBottomItem({required String icon, required String name, VoidCallback? tap, int? selectIndex}) {
    return InkWell(onTap: tap,
      child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(height: Dimensions.navbarIconSize, width: Dimensions.navbarIconSize,
          child: Image.asset(icon, fit: BoxFit.contain,
            color: Provider.of<BottomMenuController>(context, listen: false).currentTab == selectIndex
                ? Theme.of(context).primaryColor : Theme.of(context).textTheme.headlineMedium?.color,
          ),
        ),
        const SizedBox(height: 6.0),
        Text(name, style: TextStyle(
            color: Provider.of<BottomMenuController>(context, listen: false).currentTab == selectIndex
                ? Theme.of(context).primaryColor : Theme.of(context).textTheme.headlineMedium?.color,
            fontSize: Dimensions.navbarFontSize, fontWeight: FontWeight.w400),
        )
      ]),
    );
  }
}