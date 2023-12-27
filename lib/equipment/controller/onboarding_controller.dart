import 'package:customer/equipment/data/api/api_checker.dart';
import 'package:customer/equipment/data/model/response/onboarding_model.dart';
import 'package:customer/equipment/data/repository/onboarding_repo.dart';
import 'package:get/get.dart';

class EQOnBoardingController extends GetxController implements GetxService {
  final OnBoardingRepo onboardingRepo;
  EQOnBoardingController({required this.onboardingRepo});

  List<OnBoardingModel> _onBoardingList = [];
  int _selectedIndex = 0;

  List<OnBoardingModel> get onBoardingList => _onBoardingList;
  int get selectedIndex => _selectedIndex;

  void changeSelectIndex(int index) {
    _selectedIndex = index;
    update();
  }

  void getOnBoardingList() async {
    Response response = await onboardingRepo.getOnBoardingList();
    if (response.statusCode == 200) {
      _onBoardingList = [];
      _onBoardingList.addAll(response.body);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }
}
