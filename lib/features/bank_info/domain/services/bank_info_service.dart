
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:syriacosmeticsmanger/common/basewidgets/custom_snackbar_widget.dart';
import 'package:syriacosmeticsmanger/features/profile/domain/models/profile_body.dart';
import 'package:syriacosmeticsmanger/data/model/response/base/api_response.dart';
import 'package:syriacosmeticsmanger/data/model/response/response_model.dart';
import 'package:syriacosmeticsmanger/features/bank_info/domain/repositories/bank_info_repository_interface.dart';
import 'package:syriacosmeticsmanger/features/bank_info/domain/services/bank_info_service_interface.dart';
import 'package:syriacosmeticsmanger/features/profile/domain/models/profile_info.dart';
import 'package:syriacosmeticsmanger/helper/api_checker.dart';
import 'package:syriacosmeticsmanger/localization/language_constrants.dart';
import 'package:syriacosmeticsmanger/main.dart';

class BankInfoService implements BankInfoServiceInterface{
  BankInfoRepositoryInterface bankInfoRepoInterface;
  BankInfoService({required this.bankInfoRepoInterface});

  @override
  Future chartFilterData(String? type) {
    return bankInfoRepoInterface.chartFilterData(type);
  }

  @override
  Future getBankList() async{
    ApiResponse apiResponse = await bankInfoRepoInterface.getList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
    return ProfileInfoModel.fromJson(apiResponse.response!.data);
    } else {
    ApiChecker.checkApi(apiResponse);
    }
  }

  @override
  String getBankToken() {
    return bankInfoRepoInterface.getBankToken();
  }

  @override
  Future updateBank(ProfileInfoModel userInfoModel, ProfileBody seller, String token) async{
    http.StreamedResponse response = await bankInfoRepoInterface.updateBank(userInfoModel, seller, token);
    if (response.statusCode == 200) {
      Navigator.pop(Get.context!);
      showCustomSnackBarWidget(getTranslated('bank_info_updated_successfully', Get.context!), Get.context!, isToaster: true, isError: false);
      return ResponseModel(true, '');
    } else {
      if (kDebugMode) {
        print('${response.statusCode} ${response.reasonPhrase}');
      }
      return ResponseModel(false, '${response.statusCode} ${response.reasonPhrase}');
    }
  }

  @override
  Future getOrderFilterData(String? type) {
    return bankInfoRepoInterface.getOrderFilterData(type);
  }
  
}