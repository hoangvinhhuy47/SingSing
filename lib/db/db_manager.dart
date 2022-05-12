import 'package:sing_app/data/models/balance.dart';
import 'package:sing_app/data/models/log_transaction.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sqflite/sqflite.dart';

import 'db_constants.dart';

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
    db ??= await openDatabase('data.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          create table $tableHideToken (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          $columnWalletId TEXT NOT NULL,
          $columnTokenAddress TEXT NOT NULL,
          UNIQUE($columnWalletId, $columnTokenAddress)
          )
          ''');
      await db.execute('''
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
    });
  }

  closeDb() async {
    LoggerUtil.info('closeDb' , tag: tag);
    await db?.close();
    db = null;
  }

  Future<int> hideBalance(Balance balance) async {
    await openDb();
    final Map<String, dynamic> data = <String, dynamic>{};
    data[columnWalletId] = balance.walletId;
    data[columnTokenAddress] = balance.tokenAddress ?? balance.secretType;

    final result = await db?.insert(tableHideToken, data) ?? 0;
    await closeDb();
    return result;
  }

  Future<List<String>> getListHideToken(String walletId) async {
    await openDb();
    List<Map>? maps = await db?.query(tableHideToken,
        columns: [columnWalletId, columnTokenAddress],
        where: '$columnWalletId = ?',
        whereArgs: [walletId]);

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
    final result = await db?.rawDelete(query,
            [balance.walletId, balance.tokenAddress ?? balance.secretType]) ?? 0;
    await closeDb();
    return result;
  }

  void showTableHideToken() async {
    await openDb();
    List<Map<String, Object?>>? list =
        await db?.rawQuery('SELECT * FROM $tableHideToken');
    LoggerUtil.info('showTable $tableHideToken: $list', tag: tag);
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

    final result = await db?.insert(tableLogTransactions, data) ?? 0;
    LoggerUtil.info('insertTransaction : $transactionHash - result: $result' , tag: tag);
    await closeDb();
    return result;
  }

  Future<List<LogTransaction>> getLogTransactions(String walletId, String tokenContractOrSecretType) async {
    await openDb();
    List<Map>? maps = await db?.query(tableLogTransactions,
        // columns: [columnWalletId, columnTokenAddress],
        where: '$columnWalletId = ? AND $columnTokenAddress = ?',
        whereArgs: [walletId, tokenContractOrSecretType]);

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
    // List<Map<String, Object?>>? list = await db?.rawQuery('SELECT * FROM $tableLogTransactions');
    List<Map<String, Object?>>?  list = await db?.query(tableHideToken);
    LoggerUtil.info('showTableLogTransactions $tableLogTransactions: $list', tag: tag);
    await closeDb();

  }

}
