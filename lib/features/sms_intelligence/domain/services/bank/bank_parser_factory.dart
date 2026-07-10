import 'package:finsight_ai/features/sms_intelligence/domain/entities/parsed_transaction.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/bank_parser.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/parsers/hdfc_bank_parser.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/parsers/hdfc_mutual_fund_parser.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/parsers/icici_bank_parser.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/parsers/sbi_bank_parser.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/parsers/axis_bank_parser.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/parsers/kotak_bank_parser.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/parsers/pnb_bank_parser.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/parsers/canara_bank_parser.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/parsers/bank_of_baroda_parser.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/parsers/union_bank_parser.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/parsers/saraswat_bank_parser.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/parsers/dbs_bank_parser.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/parsers/indian_bank_parser.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/parsers/federal_bank_parser.dart';
import 'package:finsight_ai/features/sms_intelligence/domain/services/bank/parsers/juspay_parser.dart';

/// Factory for creating bank-specific parsers based on SMS sender.
///
/// Direct port of `parser-core/bank/BankParserFactory.kt`.
abstract class BankParserFactory {
  BankParserFactory._();

  static final List<BankParser> _parsers = [
    HdfcMutualFundParser(),
    // NaviMutualFundParser(),
    HdfcBankParser(),
    // NepalSBIBankParser(),
    SbiBankParser(),
    SaraswatBankParser(),
    DbsBankParser(),
    IndianBankParser(),
    FederalBankParser(),
    JuspayParser(),
    // CashfreeParser(),
    // SliceParser(),
    // CredParser(),
    // LazyPayParser(),
    // UtkarshBankParser(),
    IciciBankParser(),
    // KarnatakaBankParser(),
    // KeralaGraminBankParser(),
    // KeralaBankParser(),
    // IDBIBankParser(),
    // JupiterBankParser(),
    AxisBankParser(),
    PnbBankParser(),
    // PunjabSindBankParser(),
    CanaraBankParser(),
    BankOfBarodaParser(),
    // BankOfIndiaParser(),
    // JioPaymentsBankParser(),
    // NSDLPaymentsBankParser(),
    // JanaSmallFinanceBankParser(),
    KotakBankParser(),
    // IDFCFirstBankParser(),
    UnionBankParser(),
    // HSBCBankParser(),
    // CentralBankOfIndiaParser(),
    // SouthIndianBankParser(),
    // JKBankParser(),
    // JioPayParser(),
    // IPPBParser(),
    // CityUnionBankParser(),
    // IndianOverseasBankParser(),
    // AirtelPaymentsBankParser(),
    // IndusIndBankParser(),
    // AMEXBankParser(),
    // OneCardParser(),
    // UCOBankParser(),
    // AUBankParser(),
    // YesBankParser(),
    // BandhanBankParser(),
    // ADCBParser(),
    // FABParser(),
    // EmiratesNBDParser(),
    // EmiratesIslamicParser(),
    // LivBankParser(),
    // CitiBankParser(),
    // DiscoverCardParser(),
    // OldHickoryParser(),
    // LaxmiBankParser(),
    // CBEBankParser(),
    // AltanaFCUParser(),
    // StandardBankMozambiqueParser(),
    // EMolaParser(),
    // MillenniumBimParser(),
    // EverestBankParser(),
    // BancolombiaParser(),
    // MashreqBankParser(),
    // CharlesSchwabParser(),
    // NavyFederalParser(),
    // AdelFiParser(),
    // AlecuBankParser(),
    // PriorbankParser(),
    // AlinmaBankParser(),
    // NabilBankParser(),
    // NMBTanzaniaParser(),
    // NMBBankParser(),
    // ManjushreeFinanceParser(),
    // CitizensBankParser(),
    // MachchhapuchreBankParser(),
    // StandardCharteredNepalParser(),
    // LumbiniBikashBankParser(),
    // NepalBankParser(),
    // SiddharthaBankParser(),
    // PrimeCommercialBankParser(),
    // MPesaMozambiqueParser(),
    // MPesaTanzaniaParser(),
    // MPESAParser(),
    // SelcomPesaParser(),
    // CrdbBankParser(),
    // MixxByYasParser(),
    // TigoPesaParser(),
    // DiamondTrustBankParser(),
    // CIBEgyptParser(),
    // ArabBankParser(),
    // DhanlaxmiBankParser(),
    // DOPBankParser(),
    // HuntingtonBankParser(),
    // StandardCharteredBankParser(),
    // EquitasBankParser(),
    // TelebirrParser(),
    // ZemenBankParser(),
    // DashenBankParser(),
    // FaysalBankParser(),
    // MelliBankParser(),
    // MellatBankParser(),
    // ParsianBankParser(),
    // BankinoBankParser(),
    // BluBankParser(),
    // BangkokBankParser(),
    // KasikornBankParser(),
    // SiamCommercialBankParser(),
    // KrungThaiBankParser(),
    // KrungsriBankParser(),
    // TTBBankParser(),
    // GSBBankParser(),
    // BAACBankParser(),
    // UOBThailandParser(),
    // CIMBThaiParser(),
    // KTCCreditCardParser(),
    // TBankParser(),
    // ChaseBankParser(),
    // AlRajhiBankParser(),
    // SNBAlAhliBankParser(),
    // STCBankParser(),
    // SabbBankParser(),
    // MBankCZParser(),
    // SparkasseRheinMaasParser(),
    // EnparaBankParser(),
    // BankMuscatParser(),
    // GreaterBankParser(),
    // BPCEParser(),
    // SampathBankParser(),
    // NationsTrustBankParser(),
    // NationalSavingsBankParser(),
    // BkashParser(),
    // AccessBankParser(),
    // ZenithBankParser(),
    // KeystoneBankParser(),
    // JaizBankParser(),
    // OpayBankParser()
  ];

  /// Returns the appropriate bank parser for the given sender.
  /// Returns null if no specific parser is found.
  static BankParser? getParser(String sender) {
    for (final parser in _parsers) {
      if (parser.canHandle(sender)) {
        return parser;
      }
    }
    return null;
  }

  /// Returns every parser whose canHandle matches the sender.
  static List<BankParser> getParsers(String sender) {
    return _parsers.where((p) => p.canHandle(sender)).toList();
  }

  /// Content-aware dispatch: tries every canHandle-matching parser and returns the
  /// first non-null parse().
  static ParsedTransaction? parse(String smsBody, String sender, int timestamp) {
    for (final parser in getParsers(sender)) {
      final tx = parser.parse(smsBody, sender, timestamp);
      if (tx != null) return tx;
    }
    return null;
  }

  /// Returns the bank parser for the given bank name.
  static BankParser? getParserByName(String bankName) {
    for (final parser in _parsers) {
      if (parser.getBankName() == bankName) {
        return parser;
      }
    }
    return null;
  }

  /// Returns all available bank parsers.
  static List<BankParser> getAllParsers() => _parsers;

  /// Checks if the sender belongs to any known bank.
  static bool isKnownBankSender(String sender) {
    return _parsers.any((p) => p.canHandle(sender));
  }
}
