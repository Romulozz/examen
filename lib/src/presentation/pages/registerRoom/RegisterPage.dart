import 'package:examen/src/domain/models/Reservation.dart';
import 'package:examen/src/presentation/pages/registerRoom/bloc/ReservationState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:examen/src/presentation/pages/registerRoom/bloc/ReservationBloc.dart';
import 'package:examen/src/data/dataSource/service/ReservationService.dart';
import 'package:examen/src/presentation/pages/registerRoom/bloc/ReservationEvent.dart';

class RegisterRoomPage extends StatelessWidget {
  const RegisterRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReservationBloc(ReservationService()),
      child: RegisterRoomForm(),
    );
  }
}

class RegisterRoomForm extends StatefulWidget {
  @override
  _RegisterRoomFormState createState() => _RegisterRoomFormState();
}

class _RegisterRoomFormState extends State<RegisterRoomForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _checkInController = TextEditingController();
  final TextEditingController _checkOutController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();
  String? _roomType;
  int _guests = 1;

  void _submitForm() {
    final name = _nameController.text;
    final checkIn = DateTime.tryParse(_checkInController.text);
    final checkOut = DateTime.tryParse(_checkOutController.text);
    final observations = _observationsController.text.isEmpty ? null : _observationsController.text; // Cambiado a null si está vacío

    if (name.isEmpty || checkIn == null || checkOut == null || _roomType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor completa todos los campos.')),
      );
      return;
    }

    final reservation = Reservation(
      id: null, // Usar null para nuevas reservas sin id
      nombre: name,
      fechaEntrada: checkIn,
      fechaSalida: checkOut,
      tipoHabitacion: _roomType!,
      numHuespedes: _guests,
      observaciones: observations, // Aquí ahora será null si no hay observaciones
    );

    context.read<ReservationBloc>().add(CreateReservationEvent(reservation));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Registro de Habitación'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Registrar una Habitación',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del huésped',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.person, color: Colors.blueAccent),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _checkInController,
                decoration: InputDecoration(
                  labelText: 'Fecha de entrada',
                  prefixIcon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    _checkInController.text = date.toLocal().toString().split(' ')[0];
                  }
                },
                readOnly: true,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _checkOutController,
                decoration: InputDecoration(
                  labelText: 'Fecha de salida',
                  prefixIcon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now().add(const Duration(days: 1)),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    _checkOutController.text = date.toLocal().toString().split(' ')[0];
                  }
                },
                readOnly: true,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _roomType,
                items: <String>['Individual', 'Doble', 'Suite'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _roomType = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Tipo de habitación',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.king_bed, color: Colors.blueAccent),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Número de huéspedes',
                  prefixIcon: const Icon(Icons.group, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                initialValue: _guests.toString(),
                onChanged: (value) {
                  setState(() {
                    _guests = int.tryParse(value) ?? 1;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _observationsController,
                decoration: InputDecoration(
                  labelText: 'Observaciones especiales',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.notes, color: Colors.blueAccent),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 30),
              BlocConsumer<ReservationBloc, ReservationState>(
                listener: (context, state) {
                  if (state is ReservationSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Reserva creada con éxito!')),
                    );
                    Navigator.pop(context);
                  } else if (state is ReservationFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${state.error}')),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ReservationLoading) {
                    return const CircularProgressIndicator();
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Registrar Reserva',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
