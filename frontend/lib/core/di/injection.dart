import 'package:http/http.dart' as http;

import '../../features/airports/data/datasources/airports_remote_datasource.dart';
import '../../features/airports/data/repositories/airports_repository_impl.dart';
import '../../features/airports/domain/repositories/airports_repository.dart';
import '../../features/airports/domain/usecases/get_airports.dart';

import '../../features/flights/data/datasources/flights_remote_datasource.dart';
import '../../features/flights/data/services/flight_service.dart';
import '../constants/api_constants.dart';
import '../../features/flights/data/repositories/flights_repository_impl.dart';
import '../../features/flights/domain/repositories/flights_repository.dart';
import '../../features/flights/domain/usecases/search_flights.dart';

import '../../features/booking/data/datasources/booking_remote_datasource.dart';
import '../../features/booking/data/repositories/booking_repository_impl.dart';
import '../../features/booking/domain/repositories/booking_repository.dart';
import '../../features/booking/domain/usecases/get_booking.dart';
import '../../features/payment/data/datasources/payment_remote_datasource.dart';
import '../../features/payment/data/repositories/payment_repository_impl.dart';
import '../../features/payment/domain/repositories/payment_repository.dart';
import '../../features/payment/domain/usecases/create_payment.dart';
import '../../features/ai/data/datasources/ai_remote_datasource.dart';
import '../../features/ai/data/repositories/ai_repository_impl.dart';
import '../../features/ai/domain/repositories/ai_repository.dart';
import '../../features/ai/domain/usecases/get_ai.dart';
import '../../features/ai/presentation/controllers/ai_controller.dart';
import '../../features/home/presentation/controllers/home_controller.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<http.Client>(
    () => http.Client(),
  );

  // Airports

  getIt.registerLazySingleton<AirportsRemoteDataSource>(
    () => AirportsRemoteDataSourceImpl(
      client: getIt<http.Client>(),
    ),
  );

  getIt.registerLazySingleton<AirportsRepository>(
    () => AirportsRepositoryImpl(
      remoteDataSource:
          getIt<AirportsRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetAirports>(
    () => GetAirports(
      repository: getIt<AirportsRepository>(),
    ),
  );

  // Flights

  getIt.registerLazySingleton<FlightService>(
    () => FlightService(baseUrl: ApiConstants.baseUrl),
  );

  getIt.registerLazySingleton<FlightsRemoteDataSource>(
    () => FlightsRemoteDataSource(
      flightService: getIt<FlightService>(),
    ),
  );

  getIt.registerLazySingleton<FlightsRepository>(
    () => FlightsRepositoryImpl(
      remoteDataSource:
          getIt<FlightsRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<SearchFlights>(
    () => SearchFlights(
      getIt<FlightsRepository>(),
    ),
  );

  // Bookings

  getIt.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(
      client: getIt<http.Client>(),
    ),
  );

  getIt.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(
      remoteDataSource: getIt<BookingRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetBookings>(
    () => GetBookings(
      getIt<BookingRepository>(),
    ),
  );

  getIt.registerLazySingleton<CreateBooking>(
    () => CreateBooking(
      getIt<BookingRepository>(),
    ),
  );

  // Payments
  getIt.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(
      client: getIt<http.Client>(),
    ),
  );

  getIt.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(
      remoteDataSource: getIt<PaymentRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<CreatePayment>(
    () => CreatePayment(
      getIt<PaymentRepository>(),
    ),
  );

  // AI

  getIt.registerLazySingleton<AIRemoteDataSource>(
    () => AIRemoteDataSourceImpl(
      client: getIt<http.Client>(),
    ),
  );

  getIt.registerLazySingleton<AIRepository>(
    () => AIRepositoryImpl(
      remoteDataSource: getIt<AIRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetAI>(
    () => GetAI(
      repository: getIt<AIRepository>(),
    ),
  );

  getIt.registerFactory<AiController>(
    () => AiController(
      getAI: getIt<GetAI>(),
    ),
  );

  // Home

  getIt.registerFactory<HomeController>(
    () => HomeController(
      getAirports: getIt<GetAirports>(),
      searchFlights: getIt<SearchFlights>(),
    ),
  );
}
