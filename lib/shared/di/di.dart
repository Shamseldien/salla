import 'package:get_it/get_it.dart';
import 'package:salla/layout/bloc/cubit.dart';
import 'package:salla/modules/authentication/bloc/cubit.dart';
import 'package:salla/modules/new_address/bloc/cubit.dart';
import 'package:salla/modules/orders/bloc/cubit.dart';
import 'package:salla/modules/orders/my_orders.dart';
import 'package:salla/modules/product_info/bloc/cubit.dart';
import 'package:salla/modules/profile/bloc/cubit.dart';
import 'package:salla/modules/search/bloc/cubit.dart';
import 'package:salla/modules/single_category/bloc/cubit.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/network/local/cash_helper.dart';
import 'package:salla/shared/network/remote/dio_helper.dart';
import 'package:salla/shared/network/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt di = GetIt.I..allowReassignment = true;

Future initApp() async {
  final preferences = await SharedPreferences.getInstance();

  di.registerLazySingleton<SharedPreferences>(() => preferences);

  di.registerLazySingleton<CashHelper>(
      () => CashImplementation(di<SharedPreferences>()));

  di.registerFactory<AppCubit>(() => AppCubit(repository: di<Repository>()));
  di.registerLazySingleton<NewAddressCubit>(() => NewAddressCubit(repository: di<Repository>()));
  di.registerLazySingleton<SingleCatCubit>(() => SingleCatCubit(repository: di<Repository>()));
  di.registerLazySingleton<ProductInfoCubit>(() => ProductInfoCubit(repository: di<Repository>()));

  di.registerLazySingleton<DioHelper>(() => DioImplementation());
  di.registerLazySingleton<HomeLayoutCubit>(() => HomeLayoutCubit());
  di.registerLazySingleton<EditProfileCubit>(() => EditProfileCubit(di<Repository>()));
  di.registerLazySingleton<SearchCubit>(() => SearchCubit(di<Repository>()));
  di.registerLazySingleton<MyOrdersCubit>(() => MyOrdersCubit(repository: di<Repository>()));

  di.registerLazySingleton<Repository>(() => RepositoryImplementation(
      cashHelper: di<CashHelper>(), dioHelper: di<DioHelper>()));
  di.registerLazySingleton<AuthCubit>(() =>AuthCubit(repository: di<Repository>()));
}
