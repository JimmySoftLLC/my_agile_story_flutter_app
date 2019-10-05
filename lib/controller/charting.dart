import 'package:my_agile_story_flutter_app/controller/user_story.dart';

generateBurnChartData() {
  orderUserStorysBySprintId();
  calculateDataForBurnDownChart();
}

int totalProjectPoints = 0;
List<int> sprints = [];
List<int> todo = [];
List<int> done = [];
List<String> labelsForChart = [];
List<double> burndown = [];
List<int> myXs = [];

orderUserStorysBySprintId(){
  totalProjectPoints = 0;
  sprints = [];
  var myUserStorysTemp = [];
  for (int i =0; i < myUserStorys.length; i++ ){
    myUserStorysTemp.add(new UserStory(myUserStorys[i].id,
        myUserStorys[i].userStoryTitle,
        myUserStorys[i].userRole,
        myUserStorys[i].userWant,
        myUserStorys[i].userBenefit,
        myUserStorys[i].acceptanceCriteria,
        myUserStorys[i].conversation,
        myUserStorys[i].estimate,
        myUserStorys[i].phase,
        myUserStorys[i].percentDone,
        myUserStorys[i].priority,
        myUserStorys[i].sprint,
        myUserStorys[i].projectId));
  }
  myUserStorysTemp.sort((obj1, obj2) {return obj1.sprint - obj2.sprint;});
  var mySprindId = 0;
  for (int i = 0; i < myUserStorysTemp.length; i++) {
    if (mySprindId != myUserStorysTemp[i].sprint) {
      mySprindId = myUserStorysTemp[i].sprint;
      sprints.add(0);
    }
    if (sprints.length > 0) {
      sprints[sprints.length-1] += myUserStorysTemp[i].estimate;
    }
    totalProjectPoints += myUserStorysTemp[i].estimate;
  }
}

calculateDataForBurnDownChart() {
  todo = [];
  done = [];
  burndown = [];
  done.add(0);
  int tempDoneSoFar=0;
  myXs = [];

  for (int i = 0; i < sprints.length; i++) {
    todo.add(totalProjectPoints-sprints[i]-done[i]);
    done.add(sprints[i] + tempDoneSoFar);
    myXs.add(i);
    burndown.add(totalProjectPoints.toDouble() - tempDoneSoFar.toDouble());
    tempDoneSoFar += sprints[i];
  }
  StraightLineFit();
}

StraightLineFit() {
  var mySlopeIntercept = linearRegression(burndown,myXs);
  int i = 0;
  labelsForChart = [];
  burndown =[];
  burndown.add(mySlopeIntercept['slope'] * i + mySlopeIntercept['intercept']);
  String myItem = 'S' + (i + 1).toString();
  labelsForChart.add(myItem);
  while (burndown[i] > 0 && i < sprints.length +10) {
    i +=1;
    burndown.add(mySlopeIntercept['slope'] * i + mySlopeIntercept['intercept']);
    myItem = 'S'+(i+1).toString();
    labelsForChart.add(myItem);
    sprints.add(0);
    todo.add(0);
  }
}

linearRegression(y,x){
  var lr = {};
  int n = y.length;
  double sum_x = 0;
  double sum_y = 0;
  double sum_xy = 0;
  double sum_xx = 0;

  for (var i = 0; i < y.length; i++) {
    sum_x += x[i];
    sum_y += y[i];
    sum_xy += (x[i] * y[i]);
    sum_xx += (x[i] * x[i]);
  }

  lr['slope'] = (n * sum_xy - sum_x * sum_y) / (n*sum_xx - sum_x * sum_x);
  lr['intercept'] = (sum_y - lr['slope'] * sum_x)/n;

  return lr;
}
