import "package:SCJ_MigdallyWorks/stdLib.dart";
import "package:matrix2d/matrix2d.dart";
enum Location{
  Top,
  Bottom,
  None,
}
enum NumStyle{
  Normal,
}
class FigureNum{
  NumStyle _ns;
  String _prefix;
  String _suffix;
  FigureNum.setStyle(String prefix, String suffix, NumStyle ns){
    this._ns = ns;
    this._prefix = prefix;
    this._suffix = suffix;
  }
  String getFigureNum(int number){
    if(this._ns == NumStyle.Normal){
      return this._prefix + number.toString() + this._suffix;
    }else{
      return "";
    }
  }
}
class Caption{
  int _index;
  FigureNum _fn;
  Location _captLocs;
  List<String> _captStrs;
  Caption(FigureNum fn, Location loc){
    this._index = 0;
    this._fn = fn;
    this._captLocs = loc;
    this._captStrs = <String>[];
  }
  Location get location => this._captLocs;
  Caption add(String title){
    this._captStrs.add(title);
  }
  String getCaptionString(){
    this._index++;
    return this._fn.getFigureNum(this._index) + "\t" + this._captStrs[this._index-1];
  }
  bool isLocNone(){
    return this._captLocs == Location.None;
  }
  bool isntEmpty(){
    return this._captStrs.length - this._index > 0;
  }
  bool isEmpty(){
    return !(this.isntEmpty());
  }
}
extension TableMDS on List<List<String>>{
  String toTableString(Caption title,[bool needBorder = false]){
    //各列の最大文字数
    List<List<int>> tblTrand = this.map((List<String> elm)=>elm.map((String elm2)=>elm2.length).toList()).toList().transpose;
    List<int> maxLen = tblTrand.map((List<int> elm)=>elm.reduce((int curr, int next){
      if(curr > next){
        return curr;
      }else{
        return next;
      }
    })).toList();
    int lineLen = maxLen.reduce((int curr, int next) => curr + next) + 3*maxLen.length + 4;
    String delimLine = List.filled(lineLen,"-").join("");
    String tableString = this.map((List<String> elm)=>elm.indexedMap((int ind,String elm2)=>elm2.padRight(maxLen[ind])).join("   ")).join("\n$delimLine\n");
    String bordered;
    if(needBorder){
      bordered = "$delimLine\n$tableString\n$delimLine";
    }else{
      bordered = tableString;
    }
    if(title.isLocNone() || title.isEmpty()){
      return bordered;
    }else{
      String returning;
      String capt = title.getCaptionString();
      Location loc = title.location;
      if(loc == Location.Top){
        if(needBorder){
          returning = capt + "\n" + bordered;
        }else{
          returning = capt + "\n\n" + bordered;
        }
      }else if(loc == Location.Bottom){
        if(needBorder){
          returning = bordered + "\n" + capt;
        }else{
          returning = bordered + "\n\n" + capt;
        }
      }else{
        returning = "";
      }
      return returning;
    }
  }
}