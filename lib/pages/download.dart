import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadImageFromNet extends StatefulWidget {
  const DownloadImageFromNet({Key? key}) : super(key: key);

  @override
  _DownloadImageFromNetState createState() => _DownloadImageFromNetState();
}

class _DownloadImageFromNetState extends State<DownloadImageFromNet> {
  bool isLoading = false;
  double progress = 0.0;
  final Dio dio = Dio();

  Future<bool> saveFile(String url, String name) async{
    Directory? directory;
    try{
      if(Platform.isAndroid){
        if(await _requestPermission(Permission.storage)){
          directory = await getExternalStorageDirectory();
          if (kDebugMode) {
            print(directory?.path);
          }
          // to create our own folder in /storage/emulated/0/
          String newPath = '';
          List<String>? folders = directory?.path.split('/');
          for(int i = 1; i < folders!.length; i++){
            if(folders[i] != 'Android'){
              newPath += '/${folders[i]}';
            } else {
              break;
            }
          }
          newPath += '/Download';
          directory = Directory(newPath);
          if (kDebugMode) {
            print(directory.path);
          }
        }else{
          return false;
        }
      }else if(Platform.isIOS){
        if(await _requestPermission(Permission.photos)){
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
      if(directory != null && !await directory.exists()){
        await directory.create(recursive: true);
      }
      if(directory != null && await directory.exists()){
        File saveFile = File(directory.path + '/$name');
        await dio.download(url, saveFile.path, onReceiveProgress: (downloaded, totalSize){
          setState(() {
            progress = downloaded / totalSize;
          });
        });
        if(Platform.isIOS){
          await ImageGallerySaver.saveFile(saveFile.path, isReturnPathOfIOS: true);
        }
        return true;
      }
    } catch(e){
      print(e);
    }
    return false;
  }

  Future<bool> _requestPermission(Permission permission) async{
    if(await permission.isGranted){
      return true;
    } else{
      var result = await permission.request();
      if(result == PermissionStatus.granted){
        return true;
      } else{
        return false;
      }
    }
  }

  downloadFile() async{
  setState(() {
    isLoading = true;
  });

  bool isDownloaded = await saveFile('https://w-dog.ru/wallpapers/9/19/528797241274826/more-kamni-skaly-zelenye-solnce.jpg', 'nature.jpg');
  if(isDownloaded){
    print('The image is downloaded!');
  } else {
    print('The image is not downloaded!');
  }

  setState(() {
    isLoading = true;
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading ? SizedBox(
          width: 200,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(seconds: 4),
                builder: (BuildContext context, value, _) => CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 20,
                  // minHeight: 10,
                ),
              ),
              // Text('${progress * 100}%')
              Text('${double.parse((progress * 100).toStringAsFixed(1))}%')
            ],
          ),
        ) : FlatButton.icon(
          icon: const Icon(
            Icons.download_rounded,
            color: Colors.white,
          ),
          color: Colors.black,
          onPressed: downloadFile,
          padding: const EdgeInsets.all(10),
          label: const Text('Download Image', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
