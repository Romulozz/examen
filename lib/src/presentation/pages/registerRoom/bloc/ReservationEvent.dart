// ReservationEvent.dart
import 'package:equatable/equatable.dart';
import 'package:examen/src/domain/models/Reservation.dart';

abstract class ReservationEvent extends Equatable {
  const ReservationEvent();

  @override
  List<Object?> get props => [];
}

class CreateReservationEvent extends ReservationEvent {
  final Reservation reservation;

  const CreateReservationEvent(this.reservation);

  @override
  List<Object?> get props => [reservation];
}
