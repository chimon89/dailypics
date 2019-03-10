import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:daily_pics/misc/bean.dart';

class Tools {
  static Future<File> cacheImage(Picture source) async {
    Uri uri = Uri.parse(source.url);
    String dest = (await getTemporaryDirectory()).path;
    HttpClient client = HttpClient();
    HttpClientRequest request = await client.getUrl(uri);
    HttpClientResponse response = await request.close();
    String filename;
    String s = response.headers.value('Content-Disposition') ?? '';
    if (s.isEmpty) {
      s = source.url;
      filename = s.split('?')[0].substring(s.lastIndexOf('/') + 1);
    } else {
      filename = s.replaceRange(0, s.indexOf('filename=') + 9, '');
    }
    String suffix = filename.substring(filename.lastIndexOf('.'));
    File file = File('$dest/${source.id}$suffix');
    await response.pipe(file.openWrite());
    return file;
  }
}