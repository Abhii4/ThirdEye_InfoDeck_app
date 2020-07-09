class Package{
  final String name;
  final bool check;

  Package({this.name, this.check});

  Map<String,dynamic> toMap(){
    return {
      'name' : name,
      'check' : check,
    };
  }

  Package.fromFirestore(Map<String, dynamic> firestore)
      :
        name = firestore['name'],
        check = firestore['check'];
}