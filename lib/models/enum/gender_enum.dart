enum Gender {
  Male(name: 'Male', selected: false),
  Female(name: 'Female', selected: false),
  Other(name: 'Other', selected: false);

  final String name;
  final bool selected;

  const Gender({required this.name, this.selected = false});

}