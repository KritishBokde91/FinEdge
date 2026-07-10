import 'package:drift/drift.dart';
import '../database/drift_database.dart';
import '../database/daos/app_daos.dart';

/// Repository managing outstanding loan debts.
///
/// Ported from LoanRepository.kt.
class LoanRepository {
  final LoanDao _dao;
  final AppDatabase _db;

  const LoanRepository(this._dao, this._db);

  Future<int> insertLoan(LoansTableCompanion entry) => _dao.insertLoan(entry);

  Future<List<LoansTableData>> getActiveLoans() => _dao.getAllActiveLoans();

  /// Updates active status of a loan.
  Future<void> setLoanActive(int loanId, bool active) async {
    await (_db.update(_db.loansTable)..where((t) => t.id.equals(loanId)))
        .write(LoansTableCompanion(active: Value(active)));
  }
}
