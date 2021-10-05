class Pharm {
  final String uid;
  final double id;
  final String name;
  final String imageUrl;
  final String location;

  Pharm({this.uid, this.id, this.name, this.imageUrl, this.location});
}

class OrderPharm {
  final String name;
  final String imageUrl;
  final String uid;
  OrderPharm({this.imageUrl, this.name, this.uid});
}
