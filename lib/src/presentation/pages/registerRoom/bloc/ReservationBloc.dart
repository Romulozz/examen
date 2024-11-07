import 'package:bloc/bloc.dart';
import 'package:examen/src/domain/models/Reservation.dart';
import 'package:examen/src/data/dataSource/service/ReservationService.dart';
import 'package:examen/src/domain/utils/Resource.dart';
import 'ReservationEvent.dart';
import 'ReservationState.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  final ReservationService reservationService;

  ReservationBloc(this.reservationService) : super(ReservationInitial()) {
    on<CreateReservationEvent>(_onCreateReservation);
  }

  Future<void> _onCreateReservation(
      CreateReservationEvent event, Emitter<ReservationState> emit) async {
    emit(ReservationLoading());

    final response = await reservationService.createReservation(event.reservation);

    if (response is Success<Reservation>) {
      // Accedemos a `data` haciendo un casting seguro.
      final reservationData = (response as Success<Reservation>).data;
      emit(ReservationSuccess(reservationData));
    } else if (response is Error<Reservation>) {
      // Accedemos a `message` haciendo un casting seguro.
      final errorMessage = (response as Error<Reservation>).message;
      emit(ReservationFailure(errorMessage));
    }
  }
}
