import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/dio_client.dart';
import '../models/mock_test_model.dart';
import '../core/providers.dart';

class MockTestService {
  final DioClient _dioClient;

  MockTestService(this._dioClient);

  Future<List<TestGroupModel>> fetchTestGroups({int? parentId}) async {
    final response = await _dioClient.get(
      '/api/v1/tests/groups',
      queryParameters: parentId != null ? {'parent_id': parentId} : null,
    );
    return (response as List).map((e) => TestGroupModel.fromJson(e)).toList();
  }

  Future<TestGroupModel> fetchTestGroupDetail(int groupId) async {
    final response = await _dioClient.get('/api/v1/tests/groups/$groupId');
    return TestGroupModel.fromJson(response);
  }
}

final mockTestServiceProvider = Provider<MockTestService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return MockTestService(dioClient);
});

class MockTestState {
  final List<TestGroupModel> rootGroups;
  final Map<int, TestGroupModel> groupDetails;
  final bool isLoading;
  final String? error;

  MockTestState({
    this.rootGroups = const [],
    this.groupDetails = const {},
    this.isLoading = false,
    this.error,
  });

  MockTestState copyWith({
    List<TestGroupModel>? rootGroups,
    Map<int, TestGroupModel>? groupDetails,
    bool? isLoading,
    String? error,
  }) {
    return MockTestState(
      rootGroups: rootGroups ?? this.rootGroups,
      groupDetails: groupDetails ?? this.groupDetails,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class MockTestNotifier extends StateNotifier<MockTestState> {
  final MockTestService _service;

  MockTestNotifier(this._service) : super(MockTestState());

  Future<void> fetchRootGroups() async {
    state = state.copyWith(isLoading: true);
    try {
      final groups = await _service.fetchTestGroups();
      state = state.copyWith(rootGroups: groups, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchGroupDetail(int groupId) async {
    state = state.copyWith(isLoading: true);
    try {
      final detail = await _service.fetchTestGroupDetail(groupId);
      final newDetails = Map<int, TestGroupModel>.from(state.groupDetails);
      newDetails[groupId] = detail;
      state = state.copyWith(groupDetails: newDetails, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final mockTestNotifierProvider = StateNotifierProvider<MockTestNotifier, MockTestState>((ref) {
  final service = ref.watch(mockTestServiceProvider);
  return MockTestNotifier(service);
});
