void main(List<String> args){
  //引数からフラグを抽出
  List<String> param = args.where((String arg)=> arg.startsWith("-")).toList();
  if(param.length > 0){
    //フラグがある場合はフラグごとの挙動
    print("running with ${param.length} params\n\n${param}\n\n");
    if(args.contains("-test")){
      //-testフラグでtest running
      print("test running\n\n");
      test_MDD();
    }
  }else{
    //フラグがない場合はメインルーチン
    print("running with no param\n\n");
    mainLT();
  }
}
void mainLT(){
  //人工言語関連の言語に関する記念日
  List<List<String>> migdalDaysWithNotes = [
    ["7/26","エスペラント"],
    ["6/12","エスペラント(日本)"],
    ["12/15","ザメンホフ"],
    ["1/15","インターリングア"]];
  //累積日数を算出
  List<int> migdalCumDays = migdalDaysWithNotes.map((List<String> elm)=>elm[0]).map((String day)=> DateJP.fromString(day)).map((DateJP date)=>date.cumDays()).toList();
  //平均を取り整数に切り上げ
  int migdalCumDaysMean = (migdalCumDays.reduce((int curr, int next) => curr + next) / migdalCumDays.length).ceil();
  //累積日数からコンストラクトし日付表記の文字列へ
  String migdalDaysMean = (DateJP.fromCumDays(migdalCumDaysMean)).toString();
}
//日本式の日付表記と年内累積日数に関するクラス
//年内累積日数の定義：n月m日のときn-1月までの日数の和＋m
class DateJP{
  int _month;
  int _day;
  //各月の日数。閏年の2月はコンストラクタで変更
  List<int> _daysOfMonth = [31,28,31,30,31,30,31,31,30,31,30,31];
  //月の数値と日の数値からコンストラクト。オプション引数のbool isLeapは閏年かどうか。デフォルトは平年でfalse。閏年の場合はtrueを明示する。
  DateJP(int month,int day, [bool isLeap = false]){
    if(isLeap){
      this._daysOfMonth[1]=29;
    }
    if(month > 0 && month <= 12){
      this._month = month;
      if(day > 0 && day <=this._daysOfMonth[month-1]){
        this._day= day;
      }else{
        int val = this._daysOfMonth[this._month-1];
        throw FormatException("Invalid Imput: Parse failure in the 'day' part | Not in range 1-$val}",day);
      }
    }else{
      throw FormatException("Invalid Imput: Parse failure in the 'month' part | Not in range 1-12",month);
    }
  }
  //月日の日本式文字列表記からコンストラクト。オプション引数のbool isLeapは閏年かどうか。デフォルトは平年でfalse。閏年の場合はtrueを明示する。
  DateJP.fromString(String dateStr, [bool isLeap = false]){
    if(isLeap){
      this._daysOfMonth[1]=29;
    }
    if(dateStr.contains("/")){
      List<int> temp = dateStr.split("/").map((String elm)=> int.parse(elm)).toList();
      if(temp.length == 2){
        if(temp[0] > 0 && temp[0] <= 12){
          this._month = temp[0];
          if(temp[1] > 0 && temp[1] <=this._daysOfMonth[temp[0]-1]){
            this._day= temp[1];
          }else{
            int val = this._daysOfMonth[this._month-1];
            throw FormatException("Invalid Imput: Parse failure in the 'day' part | Not in range 1-$val",temp[1]);
          }
        }else{
          throw FormatException("Invalid Imput: Parse failure in the 'month' part | Not in range 1-12",temp[0]);
        }
      }else{
        throw FormatException("Invalid Imput: Parse failure | The number separated by '/' is not two pairs",temp);
      }
    }else{
      throw FormatException("Invalid Imput: Parse failure | '/' does not exist",dateStr);
    }

  }
  //年内累積日数からコンストラクト。オプション引数のbool isLeapは閏年かどうか。デフォルトは平年でfalse。閏年の場合はtrueを明示する。
  DateJP.fromCumDays(int cumDays, [bool isLeap = false]){
    if(isLeap){
      this._daysOfMonth[1]=29;
    }
    //各月DateJP.fromCumDays
    int backLen = (List<int>.generate(12, (int x)=>x+1).map((int days)=>this._daysOfMonth.indexOf(days)).map((int id)=>this._daysOfMonth.take(id+1).toList())).map((List<int> days){
      if(days.length > 0){
        days.reduce((int curr, int next) => curr + next);
      }else{
        return 0;
      }
    }).where((int sum)=>sum >= cumDays).toList().length;
    int monthID = 12 - backLen;
    print(backLen);
  }
  //年内累積日数を算出
  int cumDays(){
    List<int> backDays = this._daysOfMonth.take(this._month-1).toList();
    if(backDays.length > 0){
      return backDays.reduce((int curr, int next) => curr + next) + this._day;
    }else{
      return this._day;
    }
  }
  //文字列表記へ
  @override
  String toString() {
    return "${this._month}/${this._day}";
  }
}
//テスト
void test_MDD(){
  print("This is Test!\n\n");
  DateJP migd = DateJP.fromString("3/1");
  DateJP migd2 = DateJP.fromCumDays(migd.cumDays());
  //print(migd2);
}