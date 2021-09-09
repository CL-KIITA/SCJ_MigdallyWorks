import "package:SCJ_MigdallyWorks/dateLib.dart";
import "package:SCJ_MigdallyWorks/docLib.dart";
import "package:SCJ_MigdallyWorks/statLib.dart";

void main(List<String> args){
  //引数からフラグを抽出
  List<String> param = args.where((String arg)=> arg.startsWith("-")).toList();
  if(param.length > 0){
    //フラグがある場合はフラグごとの挙動
    print("running with ${param.length} params\n${param}\n");
    if(args.contains("-test")){
      //-testフラグでtest running
      print("test running\n");
      test_MDD();
    }
  }else{
    //フラグがない場合はメインルーチン
    print("running with no param\n");
    mainLT();
  }
}
void mainLT(){
  Caption cap = Caption(FigureNum.setStyle("Tbl.","",NumStyle.Normal),Location.Bottom);
  bool borderd = false;
  //閏年か
  bool isLeap = false;
  //人工言語関連の言語に関する記念日
  cap.add("人工言語関連の言語に関する記念日");
  List<List<String>> migdalDaysWithNotes = [
    ["7/26","エスペラント","不明"],
    ["6/12","エスペラント(日本)","不明"],
    ["12/15","エスペラント","ザメンホフの日"],
    ["1/15","インターリングア","不明"],
    ["7/19","アルカ","アルシディア(アルカの架空世界)での一年で一番大きな祭りであるディアセルの日"],
    ["6/2","リパライン語","修正リパライン暦の紀元(2012年)"],
    ["1/23","シャレイア語","ハイリア暦1月1日"],
    ["4/7","オ゛ェｼﾞｭルニョェーッ語","原作者のコロカさんが最初に発案した日(2021年)"],
    ["11/1","SCJ創設日","最初にDiscord鯖としってSCJが建った日(2020年)"],
    ["8/26","SCJ改革日","分離派運動、改革派有志結集を経て公開会議にて改革が決断された日(2021年)"]
  ];
  //累積日数を算出
  List<int> migdalCumDays = migdalDaysWithNotes.map((List<String> elm)=>elm[0]).map((String day)=> DateJP.fromString(day, isLeap)).map((DateJP date)=>date.cumDays()).toList();
  //各種統計値を取り整数に切り上げ
  double migdalCumDaysMean = migdalCumDays.sMean();
  double migdalCumDaysSD = migdalCumDays.sSD();
  double migdalCumDaysMix35 = [migdalCumDaysMean,migdalCumDaysSD].mixtureOfTuple([3,5]);

  //累積日数からコンストラクトし日付表記の文字列へ
  String migdalDaysMean = (DateJP.fromCumDays(migdalCumDaysMean.ceil(), isLeap)).toString();
  String migdalDaysSD = (DateJP.fromCumDays(migdalCumDaysSD.ceil(), isLeap)).toString();
  String migdalDaysMix35 = (DateJP.fromCumDays(migdalCumDaysMix35.ceil(), isLeap)).toString();
  //元データの表示
  print(migdalDaysWithNotes.toTableString(cap,borderd));
  print("\n");
  //各種統計値
  cap.add("記念日の各種統計値");
  List<List<String>> migdalDaysStats =[
    ["平均",migdalDaysMean,migdalCumDaysMean.toString()],
    ["標準偏差",migdalDaysSD,migdalCumDaysSD.toString()],
    ["平均:標準偏差=3:5",migdalDaysMix35,migdalCumDaysMix35.toString()]];
  print(migdalDaysStats.toTableString(cap,borderd));
  print("\n");
}

//テスト
void test_MDD(){
  print("This is Test!\n\n");
  DateJP migd = DateJP.fromString("12/1");
  DateJP migd2 = DateJP.fromCumDays(migd.cumDays());
  List<DateJP> migdL = List<int>.generate(12, (int x)=>x+1).map((int x)=>DateJP.fromCumDays(DateJP.fromString("$x/1").cumDays())).toList();
  //print(migd2);
}