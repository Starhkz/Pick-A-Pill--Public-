class Drug {
  String name, description, photoUrl, time, reply;
  int amount;
  bool isAvailable, ordered, unread, accepted, rejected, replied;
  Drug(
      {this.name,
      this.description,
      this.photoUrl,
      this.time,
      this.amount,
      this.isAvailable,
      this.reply,
      this.ordered,
      this.unread,
      this.accepted,
      this.rejected,
      this.replied});
}
