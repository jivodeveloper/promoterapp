class SalesItem {

  int itemid=0,pieces=0,quantity=0;

  SalesItem(this.itemid, this.pieces, this.quantity);

  Map toJson() => {
    'itemId': itemid,
    'itemPieces': pieces,
    'itemQuantity': quantity,
  };

}