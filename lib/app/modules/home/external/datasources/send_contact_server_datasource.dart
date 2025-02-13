import 'package:flutterando/app/modules/home/domain/entities/send_contact/result_contact.dart';
import 'package:flutterando/app/modules/home/domain/errors/errors_send_contact.dart';
import 'package:flutterando/app/modules/home/infra/datasources/send_contact_datasource.dart';
import 'package:flutterando/app/modules/home/infra/models/send_contact/contact_model.dart';
import 'package:hasura_connect/hasura_connect.dart';

class SendContactServerDatasource implements SendContactDatasource {
  final HasuraConnect connection;
  late Map<String, dynamic> envVars;
  SendContactServerDatasource(this.connection, this.envVars);

  @override
  Future<ResultContact> sendContact(ContactModel contact) async {
    
    var query = """ 
    mutation sendEmail(\$description: String, \$email: String, \$name: String, \$phone_number: String, \$route_id: Int, \$subject: String) {
      insert_mail_box(objects: {description: \$description, email: \$email, name: \$name, phone_number: \$phone_number, route_id: \$route_id, subject: \$subject}) {
        affected_rows
      }
    }
    """;

    var data = await connection.mutation(query, variables: {
      "description": contact.message,
      "email": contact.email,
      "name": contact.name,
      "phone_number": "",
      "route_id": 2,
      "subject": "Flutterando - Contato",
    });
    
    var id = data["data"]["insert_mail_box"]["affected_rows"];
    
    if(id != null) {
      return ResultContact('O seu email foi enviado com sucesso!'); 
    } else {
      throw SendContactExternalError(message: "Erro ao enviar o Email!");
    }
  }
}
