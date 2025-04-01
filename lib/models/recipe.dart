class Recipe{
  final String title;

  Recipe(this.title);

  factory Recipe.fromJson(Map<String, dynamic> json){
    return Recipe(json['title'] as String);
  }
}