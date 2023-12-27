class CarVersion {
  int? id;
  String? name;
  String? image;
  int? categoryId;
  int? position;
  int? status;
  int? priority;
  int? moduleId;
  String? slug;
  int? featured;
  String? createdAt;
  String? updatedAt;
  int? productsCount;
  List<Translations>? translations;

  CarVersion(
      {this.id,
      this.name,
      this.image,
      this.categoryId,
      this.position,
      this.status,
      this.priority,
      this.moduleId,
      this.slug,
      this.featured,
      this.createdAt,
      this.updatedAt,
      this.productsCount,
      this.translations});

  CarVersion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    categoryId = json['category_id'];
    position = json['position'];
    status = json['status'];
    priority = json['priority'];
    moduleId = json['module_id'];
    slug = json['slug'];
    featured = json['featured'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productsCount = json['products_count'];
    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        translations!.add(new Translations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['category_id'] = this.categoryId;
    data['position'] = this.position;
    data['status'] = this.status;
    data['priority'] = this.priority;
    data['module_id'] = this.moduleId;
    data['slug'] = this.slug;
    data['featured'] = this.featured;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['products_count'] = this.productsCount;
    if (this.translations != null) {
      data['translations'] = this.translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Translations {
  int? id;
  String? translationableType;
  int? translationableId;
  String? locale;
  String? key;
  String? value;
  var createdAt;
  var updatedAt;

  Translations(
      {this.id,
      this.translationableType,
      this.translationableId,
      this.locale,
      this.key,
      this.value,
      this.createdAt,
      this.updatedAt});

  Translations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    translationableType = json['translationable_type'];
    translationableId = json['translationable_id'];
    locale = json['locale'];
    key = json['key'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['translationable_type'] = this.translationableType;
    data['translationable_id'] = this.translationableId;
    data['locale'] = this.locale;
    data['key'] = this.key;
    data['value'] = this.value;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
