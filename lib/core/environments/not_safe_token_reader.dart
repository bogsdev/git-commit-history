import 'package:git_commit_history/core/encryption/encryption_util.dart';
import 'package:git_commit_history/core/reader/asset_reader.dart';

class NotSafeTokenReader{
  Future<String> read() async{
    NotSoSafeDecryptionUtil decryptionUtil = NotSoSafeDecryptionUtil();
    AssetReader assetReader = AssetReader();
    String notSoEncryptedToken = await assetReader.readAsset('assets/key/not_so_safe_token');
    return decryptionUtil.decrypt(notSoEncryptedToken);
  }
}