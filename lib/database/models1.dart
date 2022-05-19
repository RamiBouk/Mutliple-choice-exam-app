class MyAnswer {
  String? answerId;
  String? name;
  String? group;

  MyAnswer({
    this.answerId,
    this.name,
    this.group,
  });

  MyAnswer.fromMap(Map<String, dynamic> res)
      : answerId = res["answerId"],
        name = res["name"],
        group = res["group"];

  Map<String, Object?> toMap() {
    return {
      'answerId': answerId,
      'name': name,
      'group': group,
    };
  }
}
