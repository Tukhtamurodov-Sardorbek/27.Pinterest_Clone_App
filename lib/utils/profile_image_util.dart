class ProfileImage{
  var image;
}

ProfileImage A = ProfileImage();

class UpdateProfileImage{
  static setImage(var _image){
    A.image = _image;
  }

  static getImage(){
    return A.image;
  }
}