import 'package:equatable/equatable.dart';

class CmsLocation extends Equatable {
  final double latitude;
  final double longitude;

  const CmsLocation({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}