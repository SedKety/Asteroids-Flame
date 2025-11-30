import 'dart:collection';

import 'package:flame/components.dart';


class ObjectPool<T> extends Component{
  //Usage of an Queue to ensure FIFO
  Queue<T> objectPool = Queue();

  //Maximum items allowed to be in the queu at once, will discard additional pooled items after this threshold has been reached.
  int maxItems = 50; //Set to 50 as a base value


  void poolItem(T item){
    if(objectPool.length >= maxItems) {
      print("Pool filled. ${objectPool.length}");
      return;
    }
    objectPool.add(item);
  } 
  
  T? depoolItem()  {
    if(!objectPool.isEmpty) return objectPool.removeLast();
    return null;
  }
} 