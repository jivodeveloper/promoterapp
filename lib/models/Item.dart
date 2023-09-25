class Item {
  int? itemID;
  String? itemName;
  String? itemCode;
  num? quantity;
  bool? status;
  int? mrp;
  int? piecesPerCase;
  int? uOMId;
  int? typeNameId;
  bool? visibleToSO;
  bool? visibleToPromoter;
  int? itemTypeId;
  bool? isScheme;
  int? gst;
  String? hsnCode;
  bool? isCashback;
  String? options;
  bool? isVisibleToRetailer;
  bool? isRedeemable;
  num? boxes;

  Item(
      {this.itemID,
        this.itemName,
        this.itemCode,
        this.quantity,

        this.status,
        this.mrp,
        this.piecesPerCase,

        this.uOMId,

        this.typeNameId,
        this.options,
        this.visibleToSO,
        this.visibleToPromoter,
        this.itemTypeId,
        this.isScheme,
        this.gst,
        this.hsnCode,
        this.isCashback,
        this.isVisibleToRetailer,
        this.isRedeemable,
        this.boxes,
     });

  Item.fromJson(Map<String, dynamic> json) {
    itemID = json['itemID'];
    itemName = json['itemName'];
    itemCode = json['itemCode'];
    quantity = json['quantity'];
    status = json['status'];
    mrp = json['mrp'];
    piecesPerCase = json['piecesPerCase'];
    uOMId = json['UOMId'];
    typeNameId = json['typeNameId'];
    visibleToSO = json['visibleToSO'];
    visibleToPromoter = json['visibleToPromoter'];
    itemTypeId = json['itemTypeId'];
    isScheme = json['isScheme'];
    gst = json['gst'];
    hsnCode = json['hsnCode'];
    isCashback = json['isCashback'];
    isVisibleToRetailer = json['isVisibleToRetailer'];
    isRedeemable = json['isRedeemable'];
    options = json['options'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemID'] = this.itemID;
    data['itemName'] = this.itemName;
    data['quantity'] = this.quantity;
    data['piecesPerCase'] = this.piecesPerCase;
    data['itemTypeId'] = this.itemTypeId;
    data['options'] = this.options;
    return data;
  }
}