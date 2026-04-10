class AadhaarData {
  String? documentType;
  String? name;
  String? dateOfBirth;
  String? gender;
  String? careOf;
  String? house;
  String? street;
  String? district;
  String? subDistrict;
  String? landmark;
  String? locality;
  String? postOfficeName;
  String? state;
  String? pincode;
  String? country;
  String? vtcName;
  String? mobile;
  String? email;
  String? photoBase64;
  String? xmlBase64;

  AadhaarData(
      {this.documentType,
        this.name,
        this.dateOfBirth,
        this.gender,
        this.careOf,
        this.house,
        this.street,
        this.district,
        this.subDistrict,
        this.landmark,
        this.locality,
        this.postOfficeName,
        this.state,
        this.pincode,
        this.country,
        this.vtcName,
        this.mobile,
        this.email,
        this.photoBase64,
        this.xmlBase64});

  AadhaarData.fromJson(Map<String, dynamic> json) {
    documentType = json['document_type'];
    name = json['name'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    careOf = json['care_of'];
    house = json['house'];
    street = json['street'];
    district = json['district'];
    subDistrict = json['sub_district'];
    landmark = json['landmark'];
    locality = json['locality'];
    postOfficeName = json['post_office_name'];
    state = json['state'];
    pincode = json['pincode'];
    country = json['country'];
    vtcName = json['vtc_name'];
    mobile = json['mobile'];
    email = json['email'];
    photoBase64 = json['photo_base64'];
    xmlBase64 = json['xml_base64'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['document_type'] = this.documentType;
    data['name'] = this.name;
    data['date_of_birth'] = this.dateOfBirth;
    data['gender'] = this.gender;
    data['care_of'] = this.careOf;
    data['house'] = this.house;
    data['street'] = this.street;
    data['district'] = this.district;
    data['sub_district'] = this.subDistrict;
    data['landmark'] = this.landmark;
    data['locality'] = this.locality;
    data['post_office_name'] = this.postOfficeName;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['country'] = this.country;
    data['vtc_name'] = this.vtcName;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['photo_base64'] = this.photoBase64;
    data['xml_base64'] = this.xmlBase64;
    return data;
  }
}