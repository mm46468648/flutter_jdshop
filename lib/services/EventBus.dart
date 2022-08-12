
import 'package:event_bus/event_bus.dart';

EventBus eventBus = new EventBus();

class ProductContentEvent{
  String? str;

  ProductContentEvent(String str){
    this.str = str;
  }
}

class AddressEvent{
  String? str;

  AddressEvent(String str){
    this.str = str;
  }
}

class ChangeAddressEvent{
  String? str;

  ChangeAddressEvent(String str){
    this.str = str;
  }
}