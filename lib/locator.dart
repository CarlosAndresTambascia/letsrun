import 'package:get_it/get_it.dart';
import 'package:letsrun/services/authentication_service.dart';
import 'package:letsrun/services/firestore_service.dart';
import 'package:letsrun/services/storage_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => FirebaseStorageService());
}
