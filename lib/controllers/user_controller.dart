import 'package:food_delivery/data/repository/user_repo.dart';
import 'package:food_delivery/models/response_model.dart';
import 'package:food_delivery/models/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController implements GetxService{
  final UserRepo userRepo;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  UserController({required this.userRepo});

  Future<ResponseModel> getUserInfo() async {
    _isLoading = true;
    Response response = await userRepo.getUserInfo();
    late ResponseModel responseModel;
    print(response.body.toString());
    if(response.statusCode == 200){
      _userModel = UserModel.fromJson(response.body);
      responseModel = ResponseModel(true, 'successfully');
    } else {
      responseModel = ResponseModel(false, response.statusText!);
      print(response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  void clearData(){
    _userModel = null;
  }
}