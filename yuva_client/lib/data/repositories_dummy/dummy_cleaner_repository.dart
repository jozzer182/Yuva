import '../models/cleaner.dart';
import '../repositories/cleaner_repository.dart';

/// Dummy implementation of CleanerRepository
class DummyCleanerRepository implements CleanerRepository {
  static const List<Cleaner> _dummyCleaners = [
    Cleaner(
      id: 'cleaner_1',
      name: 'Ana Martínez',
      photoUrl: 'https://i.pravatar.cc/150?img=1',
      rating: 4.9,
      reviewCount: 127,
      pricePerHour: 50,
      yearsExperience: 5,
      specialties: ['Aseo profundo', 'Cocinas'],
      bio: 'Profesional con 5 años de experiencia. Me encanta dejar cada espacio reluciente.',
      isVerified: true,
      isFeatured: true,
    ),
    Cleaner(
      id: 'cleaner_2',
      name: 'Carlos López',
      photoUrl: 'https://i.pravatar.cc/150?img=12',
      rating: 4.8,
      reviewCount: 95,
      pricePerHour: 45,
      yearsExperience: 3,
      specialties: ['Aseo semanal', 'Baños'],
      bio: 'Atención al detalle y puntualidad garantizadas.',
      isVerified: true,
      isFeatured: true,
    ),
    Cleaner(
      id: 'cleaner_3',
      name: 'Patricia Ruiz',
      photoUrl: 'https://i.pravatar.cc/150?img=5',
      rating: 5.0,
      reviewCount: 203,
      pricePerHour: 60,
      yearsExperience: 8,
      specialties: ['Mudanza', 'Limpieza profunda'],
      bio: 'Experta en limpieza de mudanzas y espacios grandes.',
      isVerified: true,
      isFeatured: true,
    ),
    Cleaner(
      id: 'cleaner_4',
      name: 'Javier Morales',
      photoUrl: 'https://i.pravatar.cc/150?img=15',
      rating: 4.7,
      reviewCount: 68,
      pricePerHour: 48,
      yearsExperience: 4,
      specialties: ['Aseo puntual', 'Ventanas'],
      bio: 'Servicio rápido y eficiente para tu hogar.',
      isVerified: true,
      isFeatured: false,
    ),
  ];

  @override
  Future<List<Cleaner>> getFeaturedCleaners() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _dummyCleaners.where((c) => c.isFeatured).toList();
  }

  @override
  Future<List<Cleaner>> searchCleaners({String? query, String? categoryId}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return _dummyCleaners;
  }

  @override
  Future<Cleaner> getCleanerById(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _dummyCleaners.firstWhere(
      (c) => c.id == id,
      orElse: () => _dummyCleaners.first,
    );
  }
}
