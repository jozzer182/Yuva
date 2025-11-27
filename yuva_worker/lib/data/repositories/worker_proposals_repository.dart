import '../models/worker_proposal.dart';

/// Filtros para obtener propuestas
class WorkerProposalFilter {
  final List<WorkerProposalStatus>? statuses;
  final String? jobPostId;

  const WorkerProposalFilter({
    this.statuses,
    this.jobPostId,
  });
}

/// Interfaz para gestionar propuestas de trabajadores
abstract class WorkerProposalsRepository {
  /// Obtener todas las propuestas del trabajador actual
  Future<List<WorkerProposal>> getMyProposals({
    WorkerProposalFilter? filter,
  });

  /// Obtener propuesta específica para un trabajo
  Future<WorkerProposal?> getProposalForJob(String jobPostId);

  /// Crear un borrador de propuesta
  Future<WorkerProposal> createDraftProposal(String jobPostId);

  /// Actualizar una propuesta existente
  Future<WorkerProposal> updateProposal(WorkerProposal proposal);

  /// Enviar una propuesta (cambiar estado a submitted)
  Future<WorkerProposal> submitProposal(String proposalId);

  /// Eliminar un borrador de propuesta
  Future<void> deleteDraft(String proposalId);

  /// Retirar una propuesta enviada (soft delete - cambiar estado a withdrawn)
  Future<void> withdrawProposal(String proposalId, String jobPostId);
}
