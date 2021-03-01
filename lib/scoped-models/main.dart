import 'package:flutter_course/scoped-models/connecteModel.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model with ConnectedModel, UserModel, ProductsModel {}
