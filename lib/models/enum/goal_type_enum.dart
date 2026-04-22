enum GoalTypes{
  ACTIVE,
  COMPLETED,
  GIVEUP;

  factory GoalTypes.getType(String? type){
    switch(type?.toLowerCase()){
      case "active":
        return GoalTypes.ACTIVE;
      case "completed":
        return GoalTypes.COMPLETED;
      case "given-up":
        return GoalTypes.GIVEUP;
        default:
          return GoalTypes.GIVEUP;
    }
  }


}