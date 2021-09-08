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
        throw FormatException("不正な入力: 「日」部で解析失敗 | 1-$val の範囲にない}",day);
      }
    }else{
      throw FormatException("不正な入力: 「月」部で解析失敗 | 1-12 の範囲にない",month);
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
            throw FormatException("不正な入力: 「日」部で解析失敗 | 1-$val の範囲にない",temp[1]);
          }
        }else{
          throw FormatException("不正な入力: 「月」部で解析失敗 | 1-12 の範囲にない",temp[0]);
        }
      }else{
        throw FormatException("不正な入力: 解析失敗 | \"/\" で区切られる数が2組でない",temp);
      }
    }else{
      throw FormatException("不正な入力: 解析失敗 | \"/\" が存在しない",dateStr);
    }

  }
  //年内累積日数からコンストラクト。オプション引数のbool isLeapは閏年かどうか。デフォルトは平年でfalse。閏年の場合はtrueを明示する。
  DateJP.fromCumDays(int cumDays, [bool isLeap = false]){
    if(isLeap){
      this._daysOfMonth[1]=29;
    }
    //1間隔1～12のリストを生成、各月までの月の日数の和、年内累積日数以上の和のみを抽出し個数を数える
    int backLen = List<int>.generate(12, (int x)=>x+1).map((int x)=>this.sumDaysOfManthes(x)).where((int sum)=>sum >= cumDays).toList().length;
    //年の月数12に+1した13から先の個数を減じたものが求めたかった月部分
    this._month = 13 - backLen;
    //月が分かったので月と年内累積日数から日を算出
    if(this._month==1){
      this._day = cumDays;
    }else{
      this._day = cumDays - this.sumDaysOfManthes(this._month - 1);
    }
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
  //全月分の月の日数の和
  int sumDaysOfManthesAll() => this.listDaysOfManthesAll().reduce((int curr, int next) => curr + next);
  //x月までの月の日数の和
  int sumDaysOfManthes(int x) => this.listDaysOfManthes(x).reduce((int curr, int next) => curr + next);
  //全月分の月の日数のリスト
  List<int> listDaysOfManthesAll() => this._daysOfMonth;
  //x月までの月の日数のリスト
  List<int> listDaysOfManthes(int x) => this._daysOfMonth.take(x).toList();
  //文字列表記へ
  @override
  String toString() {
    return "${this._month}/${this._day}";
  }
}