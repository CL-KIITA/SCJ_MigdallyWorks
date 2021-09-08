import "dart:math";
import "package:SCJ_MigdallyWorks/stdLib.dart";

extension StaticsCalc on List<num>{
  num sSum(){
    return this.fold(0,(num curr, num next) => curr + next);
  }
  double sMean(){
    return this.sSum() / this.length;
  }
  double sVar(){
    double mean = this.sMean();
    return this.map((num elm)=> pow(elm - mean,2)).toList().sMean();
  }
  double sSD(){
    return sqrt(this.sVar());
  }
  double mixtureOfTuple(List<num> ratio){
    if(this.length==ratio.length){
      return this.indexedMap((int ind,num elm)=>elm*ratio[ind]).toList().sSum() / ratio.sSum();
    }else{
      throw FormatException("不正な入力: データと比の個数が一致しない",[this,ratio]);
    }
  }
}
