import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notifications_repo.dart';
import 'results_repo.dart';
import 'tests_repo.dart';

final testsRepoProvider = Provider<TestsRepo>((ref) => TestsRepo());
final resultsRepoProvider = Provider<ResultsRepo>((ref) => ResultsRepo());
final notificationsRepoProvider =
    Provider<NotificationsRepo>((ref) => NotificationsRepo());
