import 'package:equatable/equatable.dart';

class FlatLocation extends Equatable {
  final double latitude;
  final double longitude;

  const FlatLocation({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}