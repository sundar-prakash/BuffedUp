class expensesCardType {
  String name;
  String? imageurl;
  int count;
  int price;
  String? description;
  DateTime purchasedon;
  expensesCardType(
      {required this.count,
      required this.name,
      required this.price,
      this.imageurl,
      required this.purchasedon,
      this.description});
}
