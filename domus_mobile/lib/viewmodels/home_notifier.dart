import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/dio_client.dart';
import '../models/home_category_model.dart';
import '../models/banner_model.dart';
import '../models/question_model.dart';
import '../models/article_model.dart';
import '../models/notification_model.dart';
import '../models/home_featured_batch_model.dart';
import '../core/providers.dart';
import '../core/constants/api_constants.dart';

class HomeService {
  final DioClient _dioClient;

  HomeService(this._dioClient);

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await _dioClient.get('/api/v1/home/app_categories');
    return (response as List).map<CategoryModel>((e) => CategoryModel.fromJson(e)).toList();
  }

  Future<List<SubCategoryModel>> fetchSubCategories(int categoryId) async {
    final response = await _dioClient.get('/api/v1/home/app_categories/$categoryId/sub_categories');
    return (response as List).map<SubCategoryModel>((e) => SubCategoryModel.fromJson(e)).toList();
  }

  Future<List<BannerModel>> fetchBanners() async {
    final response = await _dioClient.get('/api/v1/home/banners');
    return (response as List).map<BannerModel>((e) => BannerModel.fromJson(e)).toList();
  }

  Future<QuestionModel?> fetchMCQOfDay() async {
    try {
      final response = await _dioClient.get(ApiConstants.mcqOfDay);
      return QuestionModel.fromJson(response);
    } catch (e) {
      print("Error fetching MCQ: $e");
      return null;
    }
  }

  Future<List<HomeFeaturedBatchModel>> fetchFeaturedBatches() async {
    final response = await _dioClient.get(ApiConstants.featuredBatches);
    return (response as List).map<HomeFeaturedBatchModel>((e) => HomeFeaturedBatchModel.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>?> submitMCQVote(int questionId, String option) async {
    try {
      final response = await _dioClient.post('${ApiConstants.mcqOfDay}/vote', data: {
        'question_id': questionId,
        'selected_option': option,
      });
      return response as Map<String, dynamic>;
    } catch (e) {
      print("Error submitting MCQ vote: $e");
      return null;
    }
  }

  Future<List<NotificationModel>> fetchGlobalNotifications() async {
    try {
      final response = await _dioClient.get('/api/v1/notifications/global');
      return (response as List).map<NotificationModel>((e) => NotificationModel.fromJson(e['notification'])).toList();
    } catch (e) {
      print("Error fetching notifications: $e");
      return [];
    }
  }

  Future<List<ArticleModel>> fetchArticles() async {
    try {
      final response = await _dioClient.get('/api/v1/feed/articles');
      return (response as List).map<ArticleModel>((e) => ArticleModel.fromJson(e)).toList();
    } catch (e) {
      print("Error fetching articles: $e");
      return [];
    }
  }
}

final homeServiceProvider = Provider<HomeService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return HomeService(dioClient);
});

class HomeState {
  final List<CategoryModel> categories;
  final Map<int, List<SubCategoryModel>> subCategories; // cache subcategories by category id
  final List<BannerModel> banners;
  final List<HomeFeaturedBatchModel> featuredBatches;
  final QuestionModel? mcqOfDay;
  final List<NotificationModel> notifications;
  final List<ArticleModel> articles;
  final bool isLoading;
  final String? error;

  HomeState({
    this.categories = const [],
    this.subCategories = const {},
    this.banners = const [],
    this.featuredBatches = const [],
    this.mcqOfDay,
    this.notifications = const [],
    this.articles = const [],
    this.isLoading = false,
    this.error,
  });

  HomeState copyWith({
    List<CategoryModel>? categories,
    Map<int, List<SubCategoryModel>>? subCategories,
    List<BannerModel>? banners,
    List<HomeFeaturedBatchModel>? featuredBatches,
    QuestionModel? mcqOfDay,
    List<NotificationModel>? notifications,
    List<ArticleModel>? articles,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      categories: categories ?? this.categories,
      subCategories: subCategories ?? this.subCategories,
      banners: banners ?? this.banners,
      featuredBatches: featuredBatches ?? this.featuredBatches,
      mcqOfDay: mcqOfDay ?? this.mcqOfDay,
      notifications: notifications ?? this.notifications,
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  final HomeService _service;

  HomeNotifier(this._service) : super(HomeState()) {
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Fetch data individually to handle failures gracefully
      final results = await Future.wait([
        _service.fetchCategories().catchError((e) {
          print("Error fetching categories: $e");
          return <CategoryModel>[];
        }),
        _service.fetchBanners().catchError((e) {
          print("Error fetching banners: $e");
          return <BannerModel>[];
        }),
        _service.fetchMCQOfDay(),
        _service.fetchFeaturedBatches().catchError((e) {
          print("Error fetching featured batches: $e");
          return <HomeFeaturedBatchModel>[];
        }),
        _service.fetchGlobalNotifications(),
        _service.fetchArticles(),
      ]);
      
      final List<CategoryModel> categories = results[0] as List<CategoryModel>;
      final List<BannerModel> banners = results[1] as List<BannerModel>;
      final QuestionModel? mcq = results[2] as QuestionModel?;
      final List<HomeFeaturedBatchModel> featured = results[3] as List<HomeFeaturedBatchModel>;
      final List<NotificationModel> notifications = results[4] as List<NotificationModel>;
      final List<ArticleModel> articles = results[5] as List<ArticleModel>;

      state = state.copyWith(
        categories: categories,
        banners: banners,
        mcqOfDay: mcq,
        featuredBatches: featured,
        notifications: notifications,
        articles: articles,
        isLoading: false,
      );

      if (categories.isNotEmpty) {
        fetchSubCategories(categories.first.id);
      }
    } catch (e) {
      print("Global home data error: $e");
      state = state.copyWith(
        isLoading: false, 
        error: "Failed to load home data. Please try again."
      );
    }
  }

  Future<void> fetchSubCategories(int categoryId) async {
    if (state.subCategories.containsKey(categoryId)) return;
    
    try {
      final subs = await _service.fetchSubCategories(categoryId);
      final newMap = Map<int, List<SubCategoryModel>>.from(state.subCategories);
      newMap[categoryId] = subs;
      state = state.copyWith(subCategories: newMap);
    } catch (e) {
      print("Failed to load subcategories for $categoryId: $e");
    }
  }
  
  Future<void> fetchMCQOfDay() async {
    try {
      final mcq = await _service.fetchMCQOfDay();
      state = state.copyWith(mcqOfDay: mcq);
    } catch (e) {
      print("Failed to load MCQ of the Day: $e");
    }
  }
  Future<void> submitMCQVote(int questionId, String option, int selectedIndex) async {
    if (state.mcqOfDay == null) return;
    
    state = state.copyWith(
      mcqOfDay: state.mcqOfDay!.copyWith(selectedOptionIndex: selectedIndex),
    );
    
    final result = await _service.submitMCQVote(questionId, option);
    if (result != null && result['status'] == 'success') {
      // Update with latest stats from server result
      final stats = result['option_stats'] as Map<String, dynamic>?;
      if (stats != null && state.mcqOfDay != null) {
        state = state.copyWith(
          mcqOfDay: state.mcqOfDay!.copyWith(
            optionStats: Map<String, double>.from(stats.map((k, v) => MapEntry(k, v.toDouble()))),
            selectedOptionIndex: selectedIndex, // Just to be sure
          ),
        );
      }
    } else {
      // Revert optimism on failure
      fetchMCQOfDay();
    }
  }
}

final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final service = ref.watch(homeServiceProvider);
  return HomeNotifier(service);
});
