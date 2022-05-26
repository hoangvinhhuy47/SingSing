const String tableHideToken = 'hide_token';
const String tableLogTransactions = 'log_transactions';
const String tableWallets = 'wallets';
const String tableBalances = 'balances';

const String columnWalletId = 'wallet_id';
const String columnTokenAddress = 'token_address';
const String columnReceiveAddress = 'receive_address';
const String columnAmount = 'amount';
const String columnTransactionHash = 'transaction_hash';
const String columnTimestamp = 'timestamp';
const String columnDescription = 'description';
const String columnName = 'name';
const String columnMnemonic = 'mnemonic';
const String columnPrivateKey = 'private_key';
const String columnAddress = 'address';
const String columnBalance = 'balance';
const String columnSecretType = 'secret_type';
const String columnImportMethod = 'import_method';//0 user create, 1 mnemonic, 2 private key

//balance
const String columnId = 'id';
const String columnSymbol = 'symbol';
const String columnGasSymbol = 'gas_symbol';
const String columnGasBalance = 'gas_balance';
const String columnRawGasBalance = 'raw_gas_balance';
const String columnDecimals = 'decimals';
const String columnRawBalance = 'raw_balance';

enum WalletImportMethod{
  create,
  mnemonic,
  privateKey
}