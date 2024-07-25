class User {
  User({
      this.id, 
      this.password, 
      this.userName, 
      this.userAvatar, 
      this.numItinerary, 
      this.numMemory, 
      this.visitHistory,});

  User.fromJson(dynamic json) {
    id = json['id'];
    password = json['password'];
    userName = json['user_name'];
    userAvatar = json['user_avatar'];
    numItinerary = json['num_itinerary'];
    numMemory = json['num_memory'];
    visitHistory = json['visit_history'] != null ? json['visit_history'].cast<String>() : [];
  }
  String? id;
  String? password;
  String? userName;
  String? userAvatar;
  num? numItinerary;
  num? numMemory;
  List<String>? visitHistory;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['password'] = password;
    map['user_name'] = userName;
    map['user_avatar'] = userAvatar;
    map['num_itinerary'] = numItinerary;
    map['num_memory'] = numMemory;
    map['visit_history'] = visitHistory;
    return map;
  }

}