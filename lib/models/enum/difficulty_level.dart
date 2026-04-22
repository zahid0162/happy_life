enum DifficultyLevel {
  LOW(name: 'Low', selected: false),
  MEDIUM(name: 'Medium', selected: false),
  HIGH(name: 'High', selected: false),
  NOT_DEFINED(name: '', selected: false);


  final String name;
  final bool selected;

  const DifficultyLevel({required this.name, this.selected = false});

  factory DifficultyLevel.getLevelByString(String? level){
    switch(level?.toLowerCase()){
      case("low"):
        return DifficultyLevel.LOW;
      case("medium"):
        return DifficultyLevel.MEDIUM;
      case("high"):
        return DifficultyLevel.HIGH;
        default:
          return DifficultyLevel.NOT_DEFINED;
    }
  }

}