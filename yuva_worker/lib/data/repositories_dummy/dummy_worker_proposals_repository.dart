import '../models/worker_proposal.dart';
import '../models/shared_types.dart';
import '../repositories/worker_proposals_repository.dart';

/// Implementación dummy con datos en memoria para propuestas de trabajadores
class DummyWorkerProposalsRepository implements WorkerProposalsRepository {
  // Simular delay de red
  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 600));

  // Datos en memoria
  final List<WorkerProposal> _proposals = [
    WorkerProposal(
      id: 'proposal_001',
      jobPostId: 'job_001',
      workerId: 'worker_001',
      proposedHourlyRate: 50000,
      budgetType: JobBudgetType.hourly,
      estimatedHours: 4,
      coverLetterKey: 'coverLetterSample1',
      status: WorkerProposalStatus.submitted,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    WorkerProposal(
      id: 'proposal_002',
      jobPostId: 'job_002',
      workerId: 'worker_001',
      proposedFixedPrice: 100000,
      budgetType: JobBudgetType.fixed,
      coverLetterKey: 'coverLetterSample2',
      status: WorkerProposalStatus.shortlisted,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    WorkerProposal(
      id: 'proposal_003',
      jobPostId: 'job_003',
      workerId: 'worker_001',
      proposedHourlyRate: 40000,
      budgetType: JobBudgetType.hourly,
      estimatedHours: 6,
      coverLetterKey: 'coverLetterSample3',
      status: WorkerProposalStatus.rejected,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    WorkerProposal(
      id: 'proposal_004',
      jobPostId: 'job_004',
      workerId: 'worker_001',
      proposedFixedPrice: 160000,
      budgetType: JobBudgetType.fixed,
      coverLetterKey: 'coverLetterSample4',
      status: WorkerProposalStatus.hired,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  @override
  Future<List<WorkerProposal>> getMyProposals({
    WorkerProposalFilter? filter,
  }) async {
    await _delay();
    
    var proposals = List<WorkerProposal>.from(_proposals);
    
    if (filter?.statuses != null && filter!.statuses!.isNotEmpty) {
      proposals = proposals.where(
        (p) => filter.statuses!.contains(p.status),
      ).toList();
    }
    
    if (filter?.jobPostId != null) {
      proposals = proposals.where(
        (p) => p.jobPostId == filter!.jobPostId,
      ).toList();
    }
    
    return proposals;
  }

  @override
  Future<WorkerProposal?> getProposalForJob(String jobPostId) async {
    await _delay();
    try {
      return _proposals.firstWhere(
        (p) => p.jobPostId == jobPostId,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<WorkerProposal> createDraftProposal(String jobPostId) async {
    await _delay();
    
    final newProposal = WorkerProposal(
      id: 'proposal_${DateTime.now().millisecondsSinceEpoch}',
      jobPostId: jobPostId,
      workerId: 'worker_001', // Usuario actual simulado
      budgetType: JobBudgetType.hourly,
      coverLetterKey: 'coverLetterDraft',
      status: WorkerProposalStatus.draft,
      createdAt: DateTime.now(),
    );
    
    _proposals.add(newProposal);
    return newProposal;
  }

  @override
  Future<WorkerProposal> updateProposal(WorkerProposal proposal) async {
    await _delay();
    
    final index = _proposals.indexWhere((p) => p.id == proposal.id);
    if (index != -1) {
      _proposals[index] = proposal.copyWith(
        lastUpdatedAt: DateTime.now(),
      );
    }
    
    return _proposals[index];
  }

  @override
  Future<WorkerProposal> submitProposal(String proposalId) async {
    await _delay();
    
    final index = _proposals.indexWhere((p) => p.id == proposalId);
    if (index != -1) {
      _proposals[index] = _proposals[index].copyWith(
        status: WorkerProposalStatus.submitted,
        lastUpdatedAt: DateTime.now(),
      );
    }
    
    return _proposals[index];
  }

  @override
  Future<void> deleteDraft(String proposalId) async {
    await _delay();
    _proposals.removeWhere((p) => p.id == proposalId && p.status == WorkerProposalStatus.draft);
  }

  @override
  Future<void> withdrawProposal(String proposalId, String jobPostId) async {
    await _delay();
    final index = _proposals.indexWhere((p) => p.id == proposalId);
    if (index != -1) {
      _proposals[index] = _proposals[index].copyWith(
        status: WorkerProposalStatus.withdrawn,
        lastUpdatedAt: DateTime.now(),
      );
    }
  }
}
