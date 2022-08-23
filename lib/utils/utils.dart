import 'package:flutter/cupertino.dart';
import 'package:qr_reader/models/models.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlFunction(BuildContext context, ScanModel? scan) async {
  //recordar el archivo android.xml que esta en android/src/ en este hay que hacer
  //ciertas modificaciones que son las siguientes

  /*
   <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
 
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
 
                <data android:scheme="https" />
                
  </intent-filter>
  */

  //esto se debe a que canlaunchUrl retorna siempre false porque android 11 da
  //problemas al paquete url_launcher y sus querys... XD????

  final Uri url = Uri.parse(scan!.valor);
  if (scan.tipo == 'http') {
    //si es web:
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url, /*mode: LaunchMode.externalApplication*/
      );
    } else {
      throw 'Error al intentar abrir: $url';
    }
  } else {
    //si es geo
    Navigator.pushNamed(context, 'map', arguments: scan);
  }
}
