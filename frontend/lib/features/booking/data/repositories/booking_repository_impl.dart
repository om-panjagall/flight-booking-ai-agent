import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_datasource.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<Booking>> getBookings() async {
    final models = await remoteDataSource.getBookings();
    return models.map<Booking>((model) => model).toList();
  }

  @override
  Future<Booking> createBooking({required Booking booking}) async {
    return remoteDataSource.createBooking(
      booking: booking,
    );
  }
}

