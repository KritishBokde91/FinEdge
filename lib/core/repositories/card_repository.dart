import 'package:drift/drift.dart';
import '../database/drift_database.dart';
import '../database/daos/app_daos.dart';

/// Repository managing credit and debit cards.
///
/// Ported from CardRepository.kt.
class CardRepository {
  final CardDao _dao;
  final AppDatabase _db;

  const CardRepository(this._dao, this._db);

  /// Resolves the specific card using its last 4 digits and bank name.
  Future<CardsTableData?> getCard(String bankName, String cardLast4) async {
    final query = _db.select(_db.cardsTable)
      ..where((t) => t.bankName.equals(bankName) & t.cardLast4.equals(cardLast4))
      ..limit(1);
    return query.getSingleOrNull();
  }

  /// Inserts a new card entry into the cards table.
  Future<int> insertCard(CardsTableCompanion entry) => _dao.insertCard(entry);

  /// Lists all active cards.
  Future<List<CardsTableData>> getActiveCards() => _dao.getAllActiveCards();

  /// Updates active/inactive status of a card.
  Future<void> setCardActive(int cardId, bool isActive) async {
    await (_db.update(_db.cardsTable)..where((t) => t.id.equals(cardId)))
        .write(CardsTableCompanion(isActive: Value(isActive)));
  }

  /// Links a debit card to a primary bank account.
  Future<void> linkCardToAccount(int cardId, String? accountLast4) async {
    await (_db.update(_db.cardsTable)..where((t) => t.id.equals(cardId)))
        .write(CardsTableCompanion(accountLast4: Value(accountLast4)));
  }

  /// Finds an existing card or creates a new card.
  Future<void> findOrCreateCard({
    required String cardLast4,
    required String bankName,
    required bool isCredit,
  }) async {
    final card = await getCard(bankName, cardLast4);
    if (card == null) {
      await insertCard(
        CardsTableCompanion(
          bankName: Value(bankName),
          cardLast4: Value(cardLast4),
          cardType: Value(isCredit ? 'CREDIT' : 'DEBIT'),
          isActive: const Value(true),
        ),
      );
    }
  }
}
