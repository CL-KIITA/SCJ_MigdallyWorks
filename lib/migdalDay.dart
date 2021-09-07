void main(List<String> args){
  List<String> param = args.where((String arg)=> arg.startsWith("-")).toList();
  if(param.length > 0){
    print("running with ${param.length} params\n\n${param}\n\n");
    if(args.contains("-test")){
      print("test running\n\n");
      test_MDD();
    }
  }else{
    print("running with no param\n\n");
    mainLT();
  }
}
void mainLT(){

  List<List<String>> migdalDaysWithNotes = [
    ["7/26","エスペラント"],
    ["6/12","エスペラント(日本)"],
    ["12/15","ザメンホフ"],
    ["1/15","インターリングア"]];
  List<int> migdalCumDays = migdalDaysWithNotes.map((List<String> elm)=>elm[0]).map((String day)=> new DateJP.fromString(day)).map((DateJP date)=>date.cumDays()).toList();
  int migdalCumDaysMean = (migdalCumDays.reduce((int curr, int next) => curr + next) / migdalCumDays.length).ceil();
  String migdalDaysMean = (new DateJP.fromCumDays(migdalCumDaysMean)).toString();
}
class DateJP{
  int _month;
  int _day;
  List<int> _daysOfMonth = [31,28,31,30,31,30,31,31,30,31,30,31];
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
  DateJP.fromCumDays(int cumDays, [bool isLeap = false]){
    if(isLeap){
      this._daysOfMonth[1]=29;
    }
    int backLen = this._daysOfMonth.map((int days)=>this._daysOfMonth.indexOf(days)).map((int id)=>this._daysOfMonth.take(id+1)).map((List<int> days)=> days.reduce((int curr, int next) => curr + next)).where((int sum)=>sum >= cumDays).toList().length;
    int monthID = 12 - backLen;
    print(monthID+1);
  }
  int cumDays(){
    List<int> backDays = this._daysOfMonth.take(this._month-1);
    if(backDays.length > 0){
    return backDays.reduce((int curr, int next) => curr + next) + this._day;
    }else{
      return this._day;
    }
  }
  @override
  String toString() {
    return "${this._month}/${this._day}";
  }
}

void test_MDD(){
  print("This is Test!\n\n");
  DateJP migd = new DateJP.fromString("1/1");
  DateJP migd2 = new DateJP.fromCumDays(migd.cumDays());
  print(migd);
}