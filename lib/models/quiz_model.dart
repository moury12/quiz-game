class QuizModel {
  String? question;
  Answers? answers;
  String? questionImageUrl;
  String? correctAnswer;
  int? score;

  QuizModel(
      {this.question,
        this.answers,
        this.questionImageUrl,
        this.correctAnswer,
        this.score});

  QuizModel.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answers =
    json['answers'] != null ? Answers.fromJson(json['answers']) : null;
    questionImageUrl = json['questionImageUrl'];
    correctAnswer = json['correctAnswer'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question;
    if (answers != null) {
      data['answers'] = answers!.toJson();
    }
    data['questionImageUrl'] = questionImageUrl;
    data['correctAnswer'] = correctAnswer;
    data['score'] = score;
    return data;
  }
}

class Answers {
  String? A;
  String? B;
  String? C;
  String? D;

  Answers({this.A, this.B, this.C, this.D});

  Answers.fromJson(Map<String, dynamic> json) {
    A = json['A'];
    B = json['B'];
    C = json['C'];
    D = json['D'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['A'] = A;
    data['B'] = B;
    data['C'] = C;
    data['D'] = D;
    return data;
  }
}
