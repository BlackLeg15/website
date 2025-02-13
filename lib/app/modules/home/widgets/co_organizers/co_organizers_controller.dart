import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutterando/app/modules/home/domain/entities/result_co_organizers.dart';
import 'package:flutterando/app/modules/home/domain/usecases/get_co_organizers.dart';
import 'package:flutterando/app/utils/screen/screen_size.dart';
import 'package:flutterando/app/utils/url_launcher/url_launcher.dart';
import 'package:mobx/mobx.dart';

part 'co_organizers_controller.g.dart';

@Injectable()
class CoOrganizersController = _CoOrganizersControllerBase
    with _$CoOrganizersController;

abstract class _CoOrganizersControllerBase with Store {
  final ScreenSize screen;
  final GetCoOrganizers usecase;
  final UrlLauncher urlLauncher;
  _CoOrganizersControllerBase(this.screen, this.usecase, this.urlLauncher) {
    fetchPartners();
  }

  @observable
  ObservableList<ResultCoOrganizers> coOrganizers = <ResultCoOrganizers>[].asObservable();

  @observable
  String error = "";

  @action
  fetchPartners() async {
    var response = await usecase.call();
    response.fold(
          (l) => error = l.toString(),
          (r) => coOrganizers = r.asObservable(),
        );
  }
}
