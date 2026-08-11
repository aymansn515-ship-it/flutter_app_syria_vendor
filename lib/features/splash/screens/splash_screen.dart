import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syriacosmeticsmanger/features/chat/screens/inbox_screen.dart';
import 'package:syriacosmeticsmanger/features/maintenance/maintenance_screen.dart';
import 'package:syriacosmeticsmanger/features/notification/screens/notification_screen.dart';
import 'package:syriacosmeticsmanger/features/order_details/screens/order_details_screen.dart';
import 'package:syriacosmeticsmanger/features/product/screens/product_list_screen.dart';
import 'package:syriacosmeticsmanger/features/refund/domain/models/refund_model.dart';
import 'package:syriacosmeticsmanger/features/refund/screens/refund_details_screen.dart';
import 'package:syriacosmeticsmanger/features/splash/domain/models/config_model.dart';
import 'package:syriacosmeticsmanger/features/update/screen/update_screen.dart';
import 'package:syriacosmeticsmanger/features/wallet/screens/wallet_screen.dart';
import 'package:syriacosmeticsmanger/helper/network_info.dart';
import 'package:syriacosmeticsmanger/features/auth/controllers/auth_controller.dart';
import 'package:syriacosmeticsmanger/features/splash/controllers/splash_controller.dart';
import 'package:syriacosmeticsmanger/main.dart';
import 'package:syriacosmeticsmanger/notification/models/notification_body.dart';
import 'package:syriacosmeticsmanger/utill/app_constants.dart';
import 'package:syriacosmeticsmanger/utill/dimensions.dart';
import 'package:syriacosmeticsmanger/utill/images.dart';
import 'package:syriacosmeticsmanger/utill/styles.dart';
import 'package:syriacosmeticsmanger/features/auth/screens/auth_screen.dart';
import 'package:syriacosmeticsmanger/features/dashboard/screens/dashboard_screen.dart';
import 'package:syriacosmeticsmanger/features/splash/widgets/splash_painter_widget.dart';

import '../../../theme/controllers/theme_controller.dart';

class SplashScreen extends StatefulWidget {
  final NotificationBody? body;
  const SplashScreen({super.key, this.body});
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<AuthController>(Get.context!,listen: false).setUnAuthorize(false, update: false);
    initCall();
  }

  Future<void> initCall() async {
    NetworkInfo.checkConnectivity(context);
    Provider.of<SplashController>(context, listen: false).initConfig().then((bool isSuccess) {
      if(isSuccess) {
        Provider.of<SplashController>(Get.context!, listen: false).getBusinessPagesList('default');
        Provider.of<SplashController>(Get.context!, listen: false).initShippingTypeList(Get.context!,'');
        Timer(const Duration(seconds: 1), () async {
          final config = Provider.of<SplashController>(Get.context!, listen: false).configModel;
          SellerAppVersionControl? appVersion = Provider.of<SplashController>(Get.context!, listen: false).configModel?.sellerAppVersionControl;
          String? minimumVersion = '0';

          if(Platform.isAndroid) {
            minimumVersion =  appVersion?.forAndroid?.version ?? '0';
          } else if(Platform.isIOS) {
            minimumVersion = appVersion?.forIos?.version ?? '0';
          }


          if(compareVersions(minimumVersion, AppConstants.appVersion) == 1) {
            Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(builder: (_) => const UpdateScreen()));
          } else if(config?.maintenanceModeData?.maintenanceStatus == 1 && config?.maintenanceModeData?.selectedMaintenanceSystem?.vendorApp == 1) {
            Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
              builder: (_) => const MaintenanceScreen(),
              settings: const RouteSettings(name: 'MaintenanceScreen'),
            ));
          } else {
            if(widget.body != null) {
              String notificationType = widget.body?.type??"";

              switch(notificationType.toLowerCase()) {
                case 'chatting' : {
                  Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(builder: (context) => InboxScreen(fromNotification: true, initIndex: widget.body?.messageKey ==  'message_from_delivery_man' ? 1 : 0)));
                }
                break;

                case 'theme' : {
                  Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(builder: (context) => const NotificationScreen()));
                }
                break;

                case 'order' : {
                  Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(builder: (context) => OrderDetailsScreen(orderId: int.parse(widget.body!.orderId.toString()), fromNotification: true)));
                }
                break;

                case 'wallet' : {
                  Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(builder: (context) => const WalletScreen(fromNotification: true)));
                }
                break;

                case 'wallet_withdraw' : {
                  Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(builder: (context) => const WalletScreen(fromNotification: true)));
                }
                break;

                case 'product_request_approved_message' : {
                  Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(builder: (context) => const ProductListMenuScreen(fromNotification: true)));
                }
                break;

                case 'refund' : {
                  Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(builder: (context) =>  RefundDetailsScreen(fromNotification: true, refundModel: RefundModel(id: widget.body!.refundId), orderDetailsId: widget.body!.orderDetailsId)));
                }
                break;

                default: {
                  Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(builder: (context) => const NotificationScreen()));
                } break;
              }

            } else {
              if(Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                await Provider.of<AuthController>(context, listen: false).updateToken(context);
                Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const DashboardScreen()));
              } else {
                Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const AuthScreen()));
              }
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Provider.of<ThemeController>(context).darkTheme ? Colors.black : Colors.white,
        body: Center(
          child: Hero(
              tag:'logo',
              child: Image.asset(
                width : 0.8 * MediaQuery.of(context).size.width,
                  // Images.whiteLogo,
                  Images.logoWithAppName,
                  fit: BoxFit.cover, )),
        )
    );
  }

  int compareVersions(String version1, String version2) {
    List<String> v1Components = version1.split('.');
    List<String> v2Components = version2.split('.');

    int maxLength = v1Components.length > v2Components.length
        ? v1Components.length
        : v2Components.length;

    for (int i = 0; i < maxLength; i++) {
      int v1Part = i < v1Components.length ? int.tryParse(v1Components[i]) ?? 0 : 0;
      int v2Part = i < v2Components.length ? int.tryParse(v2Components[i]) ?? 0 : 0;

      if (v1Part > v2Part) return 1;
      if (v1Part < v2Part) return -1;
    }

    return 0;
  }


}
