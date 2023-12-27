import 'package:customer/equipment/data/api/api_checker.dart';
import 'package:customer/equipment/data/model/response/category_model.dart';
import 'package:customer/equipment/data/model/response/item_model.dart';
import 'package:customer/equipment/data/model/response/store_model.dart';
import 'package:customer/equipment/data/repository/category_repo.dart';
import 'package:get/get.dart';

import '../data/model/response/care_version.dart';

class EQCategoryController extends GetxController implements GetxService {
  final CategoryRepo categoryRepo;
  EQCategoryController({required this.categoryRepo});

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? _subCategoryList;
  List<Item>? _categoryItemList;
  List<Store>? _categoryStoreList;
  List<Item>? _searchItemList = [];
  List<Store>? _searchStoreList = [];
  List<bool>? _interestSelectedList;
  bool _isLoading = false;
  int? _pageSize;
  int? _restPageSize;
  bool _isSearching = false;
  int _subCategoryIndex = 0;
  String _type = 'all';
  bool _isStore = false;
  String? _searchText = '';
  String? _storeResultText = '';
  String? _itemResultText = '';
  int _offset = 1;

  List<CategoryModel>? get categoryList => _categoryList;
  List<CategoryModel>? get subCategoryList => _subCategoryList;
  List<Item>? get categoryItemList => _categoryItemList;
  List<Store>? get categoryStoreList => _categoryStoreList;
  List<Item>? get searchItemList => _searchItemList;
  List<Store>? get searchStoreList => _searchStoreList;
  List<bool>? get interestSelectedList => _interestSelectedList;
  bool get isLoading => _isLoading;
  int? get pageSize => _pageSize;
  int? get restPageSize => _restPageSize;
  bool get isSearching => _isSearching;
  int get subCategoryIndex => _subCategoryIndex;
  String get type => _type;
  bool get isStore => _isStore;
  String? get searchText => _searchText;
  int get offset => _offset;

  Future<List<CategoryModel>> getCategoryList(bool reload,
      {bool allCategory = false}) async {
    if (_categoryList == null || reload) {
      _categoryList = null;
      Response response = await categoryRepo.getCategoryList(allCategory);
      if (response.statusCode == 200) {
        _categoryList = [];
        _interestSelectedList = [];
        response.body.forEach((category) {
          _categoryList!.add(CategoryModel.fromJson(category));
          _interestSelectedList!.add(false);
        });
        update();
        return _categoryList ?? [];
      } else {
        update();

        ApiChecker.checkApi(response);

        return [];
      }
    } else {
      update();

      return _categoryList ?? [];
    }
  }

  void getSubCategoryList(String? categoryID) async {
    _subCategoryIndex = 0;
    _subCategoryList = null;
    _categoryItemList = null;
    Response response = await categoryRepo.getSubCategoryList(categoryID);
    if (response.statusCode == 200) {
      _subCategoryList = [];
      _subCategoryList!
          .add(CategoryModel(id: int.parse(categoryID!), name: 'all'.tr));
      response.body.forEach((category) =>
          _subCategoryList!.add(CategoryModel.fromJson(category)));
      getCategoryItemList(categoryID, 1, 'all', false);
    } else {
      ApiChecker.checkApi(response);
    }
  }

  List<CarVersion>? _careVersionList;

  Future<List<CarVersion>> getCareVersionList({String? categoryID}) async {
    // _subCategoryIndex = 0;
    _careVersionList = null;
    // _categoryItemList = null;
    try {
      Response response = await categoryRepo.getCareVersionList(categoryID);
      if (response.statusCode == 200) {
        _careVersionList = [];
        _careVersionList!.add(CarVersion(id: null, name: 'all'.tr));
        response.body.forEach(
            (category) => _careVersionList!.add(CarVersion.fromJson(category)));
        // getCategoryItemList(categoryID, 1, 'all', false);
        print("fffffffffffffffffffff${_careVersionList}");
        return _careVersionList ?? [];
      } else {
        ApiChecker.checkApi(response);
        return [];
      }
    } catch (e) {
      print("fffffffffffffffffffff${e}");

      print(e);
      return [];
    }
  }

  // void getCategoryItemList(String? categoryID ,bool notify) async {
  //   _offset = offset;
  //   if(offset == 1) {
  //     if(_type == type) {
  //       _isSearching = false;
  //     }
  //     _type = type;
  //     if(notify) {
  //       update();
  //     }
  //     _careVersionList = null;
  //   }
  //   Response response = await categoryRepo.getCareVersionList(categoryID);
  //   if (response.statusCode == 200) {
  //     if (offset == 1) {
  //       _careVersionList = [];
  //     }
  //     _categoryItemList!.addAll(ItemModel.fromJson(response.body).items!);
  //     _pageSize = ItemModel.fromJson(response.body).totalSize;
  //     _isLoading = false;
  //   } else {
  //     ApiChecker.checkApi(response);
  //   }
  //   update();
  // }

  void setSubCategoryIndex(int index, String? categoryID) {
    _subCategoryIndex = index;
    if (_isStore) {
      getCategoryStoreList(
          _subCategoryIndex == 0
              ? categoryID
              : _subCategoryList![index].id.toString(),
          1,
          _type,
          true);
    } else {
      getCategoryItemList(
          _subCategoryIndex == 0
              ? categoryID
              : _subCategoryList![index].id.toString(),
          1,
          _type,
          true);
    }
  }

  void getCategoryItemList(
      String? categoryID, int offset, String type, bool notify,
      {year, version_id}) async {
    _offset = offset;
    if (offset == 1) {
      if (_type == type) {
        _isSearching = false;
      }
      _type = type;
      if (notify) {
        update();
      }
      _categoryItemList = null;
    }
    Response response = await categoryRepo.getCategoryItemList(
        categoryID, offset, type,
        version_id: version_id, year: year);
    if (response.statusCode == 200) {
      if (offset == 1) {
        _categoryItemList = [];
      }
      _categoryItemList!.addAll(ItemModel.fromJson(response.body).items!);
      _pageSize = ItemModel.fromJson(response.body).totalSize;
      _isLoading = false;
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void getCategoryStoreList(
      String? categoryID, int offset, String type, bool notify) async {
    _offset = offset;
    if (offset == 1) {
      if (_type == type) {
        _isSearching = false;
      }
      _type = type;
      if (notify) {
        update();
      }
      _categoryStoreList = null;
    }
    Response response =
        await categoryRepo.getCategoryStoreList(categoryID, offset, type);
    if (response.statusCode == 200) {
      if (offset == 1) {
        _categoryStoreList = [];
      }
      _categoryStoreList!.addAll(StoreModel.fromJson(response.body).stores!);
      _restPageSize = ItemModel.fromJson(response.body).totalSize;
      _isLoading = false;
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void searchData(String? query, String? categoryID, String type) async {
    if ((_isStore && query!.isNotEmpty && query != _storeResultText) ||
        (!_isStore && query!.isNotEmpty && query != _itemResultText)) {
      _searchText = query;
      _type = type;
      if (_isStore) {
        _searchStoreList = null;
      } else {
        _searchItemList = null;
      }
      _isSearching = true;
      update();

      Response response =
          await categoryRepo.getSearchData(query, categoryID, _isStore, type);
      if (response.statusCode == 200) {
        if (query.isEmpty) {
          if (_isStore) {
            _searchStoreList = [];
          } else {
            _searchItemList = [];
          }
        } else {
          if (_isStore) {
            _storeResultText = query;
            _searchStoreList = [];
            _searchStoreList!
                .addAll(StoreModel.fromJson(response.body).stores!);
            update();
          } else {
            _itemResultText = query;
            _searchItemList = [];
            _searchItemList!.addAll(ItemModel.fromJson(response.body).items!);
          }
        }
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  void toggleSearch() {
    _isSearching = !_isSearching;
    _searchItemList = [];
    if (_categoryItemList != null) {
      _searchItemList!.addAll(_categoryItemList!);
    }
    update();
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  Future<bool> saveInterest(List<int?> interests) async {
    _isLoading = true;
    update();
    Response response = await categoryRepo.saveUserInterests(interests);
    bool isSuccess;
    if (response.statusCode == 200) {
      isSuccess = true;
    } else {
      isSuccess = false;
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
    return isSuccess;
  }

  void addInterestSelection(int index) {
    _interestSelectedList![index] = !_interestSelectedList![index];
    update();
  }

  void setRestaurant(bool isRestaurant) {
    _isStore = isRestaurant;
    update();
  }
}
