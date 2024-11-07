import 'dart:convert';
import 'package:intl/intl.dart';

// Funciones para parsear y serializar los datos de Reservation
List<Reservation> reservationsFromJson(String str) =>
    List<Reservation>.from(json.decode(str).map((x) => Reservation.fromJson(x)));

String reservationsToJson(List<Reservation> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reservation {
  int? id;
  String nombre;
  DateTime? fechaEntrada;
  DateTime? fechaSalida;
  String tipoHabitacion;
  int numHuespedes;
  String? observaciones;

  Reservation({
    required this.id,
    required this.nombre,
    required this.fechaEntrada,
    required this.fechaSalida,
    required this.tipoHabitacion,
    required this.numHuespedes,
    this.observaciones,
  });

  // Método para convertir JSON en un objeto Reservation
  factory Reservation.fromJson(Map<String, dynamic> json) {
    final rfc1123Format = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", 'en_US');
    DateTime? parseDate(String dateStr) {
      // Manejo de fecha inválida "0000-00-00"
      if (dateStr == "0000-00-00") return null;

      // Manejo de fecha en formato RFC 1123
      try {
        return rfc1123Format.parse(dateStr);
      } catch (e) {
        print("Error parsing date: $e");
        return null;
      }
    }

    return Reservation(
      id: json["id"],
      nombre: json["nombre"],
      fechaEntrada: parseDate(json["fecha_entrada"]),
      fechaSalida: parseDate(json["fecha_salida"]),
      tipoHabitacion: json["tipo_habitacion"],
      numHuespedes: json["num_huespedes"],
      observaciones: json["observaciones"] ?? "",
    );
  }

  // Método para convertir un objeto Reservation a JSON
  Map<String, dynamic> toJson() => {
    "id": id,
    "nombre": nombre,
    "fecha_entrada": fechaEntrada?.toIso8601String(),
    "fecha_salida": fechaSalida?.toIso8601String(),
    "tipo_habitacion": tipoHabitacion,
    "num_huespedes": numHuespedes,
    "observaciones": observaciones ?? "",
  };
}
