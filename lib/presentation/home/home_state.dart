import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testflutt/data/model/category_sub_cate.dart';
import 'package:testflutt/data/service/cat_sub.dart';

final categoryProvider =
    StateNotifierProvider.family<
      CategoryNotifier,
      AsyncValue<List<Category>>,
      String?
    >((ref, query) => CategoryNotifier(ref, query));

class CategoryNotifier extends StateNotifier<AsyncValue<List<Category>>> {
  CategoryNotifier(this.ref, this.query) : super(AsyncValue.loading()) {
    getAllCategory(query);
  }

  final Ref ref;
  String? query;

  Future<void> getAllCategory(String? query) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => CatSub().getCategory(query));
  }
}

final SubProvider =
    StateNotifierProvider.family<
      SubCategoryNotifier,
      AsyncValue<List<SubCategory>>,
      String?
    >((ref, query) => SubCategoryNotifier(ref, query));

class SubCategoryNotifier extends StateNotifier<AsyncValue<List<SubCategory>>> {
  SubCategoryNotifier(this.ref, this.query) : super(AsyncValue.loading());

  final Ref ref;
  final String? query;

  Future<void> get() async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => CatSub().getSUb(query));
  }
}
