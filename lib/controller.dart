import 'model.dart';
import 'package:http/http.dart' as http;

class Controller{
  static Future<Mynumber>getWhatsappNumber() async{

    String url = "http://affilate.webigosolutions.com/crickapi/fetchnum.php";
    final response = await http.get(url);

    return mynumberFromJson(response.body);
  }

}


