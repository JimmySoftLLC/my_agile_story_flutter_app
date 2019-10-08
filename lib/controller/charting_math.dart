import 'package:my_agile_story_flutter_app/controller/user_story.dart';

generateBurnChartData() {
  orderUserStorysBySprintId();
  calculateDataForBurnDownChart();
}

int totalProjectPoints = 0;
List<int> sprints = [];
List<int> todo = [];
List<int> done = [];
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
  straightLineFit();
}

straightLineFit() {
  var mySlopeIntercept = linearRegression(burndown,myXs);

  int i = 0;
  burndown =[];
  burndown.add(mySlopeIntercept['slope'] * i + mySlopeIntercept['intercept']);
  while (burndown[i] > 0 && i < sprints.length +10) {
    i +=1;
    burndown.add(mySlopeIntercept['slope'] * i + mySlopeIntercept['intercept']);
    sprints.add(0);
    todo.add(0);
  }
}

linearRegression(y,x){
  var lr = {};
  int n = y.length;
  double sumX = 0;
  double sumY = 0;
  double sumXY = 0;
  double sumXX = 0;

  for (var i = 0; i < y.length; i++) {
    sumX += x[i];
    sumY += y[i];
    sumXY += (x[i] * y[i]);
    sumXX += (x[i] * x[i]);
  }
  lr['slope'] = (n * sumXY - sumX * sumY) / (n*sumXX - sumX * sumX);
  lr['intercept'] = (sumY - lr['slope'] * sumX)/n;
  return lr;
}


