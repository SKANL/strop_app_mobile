import 'package:equatable/equatable.dart'; // 1. Importamos el paquete que instalamos.

// 2. Definimos nuestra clase 'Project'.
//    Hereda de 'Equatable' para que podamos comparar dos proyectos fácilmente.
class Project extends Equatable {

  // 3. Estas son las propiedades que definen un proyecto.
  //    Son 'final' porque una vez que creamos un proyecto, sus datos base no deberían cambiar (inmutabilidad).
  final String id;
  final String name;
  final String location;
  final DateTime startDate;
  final DateTime endDate;

  // 4. Este es el 'constructor'. Es la función que usamos para crear un nuevo objeto Project.
  const Project({
    required this.id,
    required this.name,
    required this.location,
    required this.startDate,
    required this.endDate,
  });

  // 5. Esta es la parte que necesita 'Equatable'.
  //    Le decimos que dos objetos 'Project' son iguales si TODAS estas propiedades son idénticas.
  @override
  List<Object?> get props => [id, name, location, startDate, endDate];
}