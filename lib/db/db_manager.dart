import 'package:sing_app/data/models/balance.dart';
import 'package:sing_app/data/models/log_transaction.dart';
import 'package:sing_app/data/models/wallet.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sqflite/sqflite.dart';
import 'db_constants.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class DbManager {
  String tag = 'DbManager';

  DbManager._privateConstructor() {
    //
  }

  static final DbManager _instance = DbManager._privateConstructor();
  static DbManager get instance => _instance;

  Database? db;

  openDb() async {
    LoggerUtil.info('openDb' , tag: tag);
    try{
      db ??= await openDatabase('data.db', version: 2,
          onCreate: (Database db, int version) async {
            final batch = db.batch();
            _createV1Tables(batch);
            _createV2Tables(batch);
            await batch.commit();
          },
          onUpgrade: (db, oldVersion, newVersion) async {
            final batch = db.batch();
            if(oldVersion == 1){
              _createV2Tables(batch);
            }
            await batch.commit();
          }
      );
    } catch(_){
      db = null;
    }
  }

  void _createV1Tables(Batch batch){
    LoggerUtil.info('Create table $tableHideToken');
    batch.execute('''
          create table $tableHideToken (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          $columnWalletId TEXT NOT NULL,
          $columnTokenAddress TEXT NOT NULL,
          UNIQUE($columnWalletId, $columnTokenAddress)
          )
          ''');
    LoggerUtil.info('Create table $tableLogTransactions');
    batch.execute('''
          create table $tableLogTransactions (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          $columnWalletId TEXT NOT NULL,
          $columnTokenAddress TEXT NOT NULL,
          $columnReceiveAddress TEXT NOT NULL,
          $columnAmount TEXT NOT NULL,
          $columnTransactionHash TEXT NOT NULL,
          $columnDescription TEXT,
          $columnTimestamp INTEGER NOT NULL
          )
          ''');
  }
  void _createV2Tables(Batch batch){
    LoggerUtil.info('Create table $tableWallets');
    batch.execute('''
          create table $tableWallets (
          $columnWalletId TEXT PRIMARY KEY NOT NULL,
          $columnName TEXT,
          $columnMnemonic TEXT,
          $columnPrivateKey TEXT,
          $columnAddress TEXT NOT NULL,
          $columnSecretType TEXT NOT NULL,
          $columnImportMethod INTEGER NOT NULL,
          $columnTimestamp INTEGER NOT NULL
          )
          ''');

    LoggerUtil.info('Create table $tableBalances');
    batch.execute('''
          create table $tableBalances (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          $columnWalletId TEXT NOT NULL,
          $columnTokenAddress TEXT,
          $columnSecretType TEXT,
          $columnBalance REAL NOT NULL,
          $columnRawBalance REAL NOT NULL,
          $columnSymbol TEXT NOT NULL,
          $columnGasBalance REAL NOT NULL,
          $columnRawGasBalance REAL NOT NULL,
          $columnGasSymbol TEXT NOT NULL,
          $columnDecimals INTEGER NOT NULL,
          $columnTimestamp INTEGER NOT NULL
          )
          ''');
  }

  closeDb() async {
    LoggerUtil.info('closeDb' , tag: tag);
    try{
      await db?.close();
    } catch(_){

    }
    db = null;
  }

  Future<int> hideBalance(Balance balance) async {
    await openDb();
    final Map<String, dynamic> data = <String, dynamic>{};
    data[columnWalletId] = balance.walletId;
    data[columnTokenAddress] = balance.tokenAddress ?? balance.secretType;

    var result = 0;
    try{
      result = await db?.insert(tableHideToken, data) ?? 0;
    } catch(_){
      
    }
    await closeDb();
    return result;
  }

  Future<List<String>> getListHideToken(String walletId) async {
    await openDb();
    List<Map>? maps = [];
    try{
      maps = await db?.query(tableHideToken,
          columns: [columnWalletId, columnTokenAddress],
          where: '$columnWalletId = ?',
          whereArgs: [walletId]);
    }catch(_){

    }

    List<String> listHideTokenAddress = [];
    if (maps != null) {
      for (var item in maps) {
        listHideTokenAddress.add(item[columnTokenAddress]);
      }
    }
    // LoggerUtil.info('getListHideToken result: ${listHideTokenAddress.length}' , tag: tag);
    // for(String token in listHideTokenAddress) {
    //   LoggerUtil.info('token address: $token' , tag: tag);
    // }
    await closeDb();
    return listHideTokenAddress;
  }

  Future<int> unHideBalance(Balance balance) async {
    await openDb();
    String query =
        'DELETE FROM $tableHideToken WHERE $columnWalletId=? AND $columnTokenAddress=?';
    var result = 0;
    try{
      result = await db?.rawDelete(query,
          [balance.walletId, balance.tokenAddress ?? balance.secretType]) ?? 0;
    } catch(_){
    }
    await closeDb();
    return result;
  }

  void showTableHideToken() async {
    await openDb();
    try {
      List<Map<String, Object?>>? list =
      await db?.rawQuery('SELECT * FROM $tableHideToken');
      LoggerUtil.info('showTable $tableHideToken: $list', tag: tag);
    } catch(_){

    }
    await closeDb();
  }


  Future<int> insertTransaction({
    required String walletId,
    required String sendTokenAddress,
    required String receiveAddress,
    required String amount,
    required String transactionHash,
    required int timestamp,
  }) async {
    await openDb();
    final Map<String, dynamic> data = <String, dynamic>{};
    data[columnWalletId] = walletId;
    data[columnTokenAddress] = sendTokenAddress;
    data[columnReceiveAddress] = receiveAddress;
    data[columnAmount] = amount;
    data[columnTransactionHash] = transactionHash;
    data[columnTimestamp] = timestamp;

    var result = 0;
    try{
      result = await db?.insert(tableLogTransactions, data) ?? 0;
    } catch(_){

    }
    LoggerUtil.info('insertTransaction : $transactionHash - result: $result' , tag: tag);
    await closeDb();
    return result;
  }

  Future<List<LogTransaction>> getLogTransactions(String walletId, String tokenContractOrSecretType) async {
    await openDb();
    List<Map>? maps = [];
    try{
      maps = await db?.query(tableLogTransactions,
          // columns: [columnWalletId, columnTokenAddress],
          where: '$columnWalletId = ? AND $columnTokenAddress = ?',
          whereArgs: [walletId, tokenContractOrSecretType]);
    }catch(_){

    }

    List<LogTransaction> results = [];
    if (maps != null) {
      for (var item in maps) {
        LogTransaction logTransaction = LogTransaction.fromDbMap(item);
        results.add(logTransaction);
      }
    }
    LoggerUtil.info('getLogTransactions result: ${results.length}' , tag: tag);
    for(LogTransaction item in results) {
      LoggerUtil.info('LogTransaction: $item' , tag: tag);
    }
    await closeDb();
    return results;
  }

  Future<void> showTableLogTransactions() async {
    await openDb();
    try{
      List<Map<String, Object?>>?  list = await db?.query(tableHideToken);
      LoggerUtil.info('showTableLogTransactions $tableLogTransactions: $list', tag: tag);
    } catch(_){

    }
    await closeDb();
  }

  Future<String> insertWallet({
    String? name,
    required String mnemonic,
    required String privateKey,
    required String address,
    required String secretType,
  }) async {
    await openDb();

    const uuid = Uuid();
    String newWalletId = uuid.v4(options: {'rng': UuidUtil.cryptoRNG});

    final Map<String, dynamic> data = {
      columnWalletId: newWalletId,
      columnName: name,
      columnMnemonic: mnemonic,
      columnPrivateKey: privateKey,
      columnAddress: address,
      columnSecretType: secretType,
      columnImportMethod: WalletImportMethod.create.index,
      columnTimestamp: DateTime.now().millisecondsSinceEpoch
    };

    int result = 0;
    try{
      result = await db?.insert(tableWallets, data) ?? 0;
      LoggerUtil.info('insert wallet : $data - result: $result' , tag: tag);
    } catch(exc){
      LoggerUtil.error('insert wallet error: $exc');
    } finally {
      await closeDb();
    }

    return result > 0 ? newWalletId : '';
  }

  Future<bool> updateWalletName({
    required String name,
    required String walletId
  }) async {
    await openDb();

    final Map<String, dynamic> data = {
      columnName: name,
    };
    const where = '$columnWalletId = ?';
    int? result;
    try{
      result = await db?.update(tableWallets, data, where: where, whereArgs: [walletId]);
    }catch(_){

    }

    await closeDb();
    return result != null && result > 0;
  }

  Future<bool> updateWalletBalance({
    required String walletId,
    required double balance,
    required double rawBalance,
  }) async {
    await openDb();

    final Map<String, dynamic> data = {
      columnBalance: balance,
      columnRawBalance: rawBalance,
      columnGasBalance: balance,
      columnRawGasBalance: rawBalance,
    };
    const where = '$columnWalletId = ? AND $columnTokenAddress IS NULL';
    int? result;
    try{
      result = await db?.update(tableBalances, data, where: where, whereArgs: [walletId]);
    }catch(_){

    }
    await closeDb();
    return result != null && result > 0;
  }

  Future<List<Wallet>> getWallets() async {
    await openDb();
    List<Map>? maps = [];
    try{
      maps = await db?.query(tableWallets,
        orderBy: '`$columnTimestamp` ASC',
      );
    }catch(_){

    }

    List<Wallet> results = [];
    if (maps != null) {
      for (final item in maps) {
        final wallet = Wallet.fromDbMap(item);
        wallet.balance = await getChainBalance(walletId: wallet.id, autoOpenDb: false);
        results.add(wallet);
      }
    }
    await closeDb();
    return results;
  }

  Future<int> countWallet({
    required String secretType,
  }) async {
    await openDb();
    int? result;
    try{
      result = Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $tableWallets where `$columnSecretType` = ?', [secretType]));
    }catch(_){
    }

    await closeDb();
    return result ?? 0;
  }


  Future<int> deleteWallet(Wallet wallet) async {
    await openDb();
    var result = 0;
    String query =
        'DELETE FROM $tableWallets WHERE $columnWalletId=?';
    try{
      result = await db?.rawDelete(query,
          [wallet.id]) ?? 0;
    } catch(_){

    }
    await closeDb();
    return result;
  }

  Future<int> insertBalance({
    String? name,
    required String walletId,
    required String? tokenAddress,
    required String secretType,
    required double balance,
    required double rawBalance,
    required double gasBalance,
    required double rawGasBalance,
    required String symbol,
    required String gasSymbol,
    required int decimals,
  }) async {
    await openDb();

    final Map<String, dynamic> data = {
      columnWalletId: walletId,
      columnTokenAddress: tokenAddress,
      columnSecretType: secretType,
      columnBalance: balance,
      columnRawBalance: rawBalance,
      columnGasBalance: gasBalance,
      columnRawGasBalance: rawGasBalance,
      columnSymbol: symbol,
      columnGasSymbol: gasSymbol,
      columnDecimals: decimals,
      columnTimestamp: DateTime.now().millisecondsSinceEpoch
    };

    int result = 0;
    try{
      result = await db?.insert(tableBalances, data) ?? 0;
      LoggerUtil.info('insert balance : $data - result: $result' , tag: tag);
    } catch(exc){
      LoggerUtil.error('insert balance error: $exc');
    } finally {
      await closeDb();
    }

    return result;
  }

  Future<List<Balance>> getBalances(String walletId) async {
    await openDb();
    List<Map>? maps = [];
    try{
      maps = await db?.query(tableBalances,
        where: '`$columnWalletId` = ?',
        whereArgs: [walletId],
        orderBy: '`$columnSymbol` ASC',
      );
    } catch(_){

    }

    List<Balance> results = [];
    if (maps != null) {
      for (var item in maps) {
        final balance = Balance.fromDbMap(item);
        results.add(balance);
      }
    }
    await closeDb();
    return results;
  }

  Future<Balance?> getChainBalance({required String walletId, bool autoOpenDb = true}) async {
    if(autoOpenDb){
      await openDb();
    }
    List<Map>? maps = [];

    try{
      maps = await db?.query(tableBalances,
        where: '`$columnWalletId` = ? AND `$columnTokenAddress` IS NULL',
        whereArgs: [walletId],
        orderBy: '`$columnSymbol` ASC',
      );
    } catch(_){
    }


    List<Balance> results = [];
    if (maps != null && maps.isNotEmpty) {
      for (final item in maps) {
        final balance = Balance.fromDbMap(item);
        results.add(balance);
      }
    }

    if(autoOpenDb){
      await closeDb();
    }
    return results.isNotEmpty ? results.first : null;
  }

  Future<bool> updateBalance({
    required String walletId,
    required String? tokenAddress,
    required double balance,
    required double rawBalance,
    required double gasBalance,
    required double rawGasBalance,
  }) async {
    await openDb();

    final Map<String, dynamic> data = {
      columnBalance: balance.toString(),
    };
    final where = '$columnWalletId = ? AND ' + (tokenAddress == null ? '$columnTokenAddress IS NULL' : '$columnTokenAddress = ?');
    final whereArgs = [walletId];
    if(tokenAddress != null){
      whereArgs.add(tokenAddress);
    }
    try{
      final result = await db?.update(tableBalances, data, where: where, whereArgs: whereArgs);
      return result != null && result > 0;
    } catch(e){
      LoggerUtil.error('error update balance: $e');
    } finally {
      await closeDb();
    }
    return false;
  }
}
