class Job {
  Job({this.jobId, this.price, this.name});

  Job.fromFirestore(Map<String, dynamic> firestore)
      : jobId = firestore['JobId'] as String,
        name = firestore['name'] as String,
        price = firestore['price'] as double;
  final String? jobId;
  final String? name;
  final double? price;

  Map<String, dynamic> toMap() =>
      {'JobId': jobId, 'name': name, 'price': price};
}
