library my_prj.globals;

import 'package:kapture_aio/localization/i18n.dart';

void resetUser(){
  isLoggedIn = false;
  userid = 0;
  username = I18n.roleVisitor;
  displayname = I18n.roleVisitor;
  email = "";
  userimg = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";
  role = setRole("visitor");
}

// id, username, displayname, email, role
String setRole(String role){
  switch(role){
    case "visitor": return I18n.roleVisitor;
    case "rookie": return I18n.roleRookie;
    case "intermediate": return I18n.roleIntermediate;
    case "advanced": return I18n.roleAdvanced;
    case "master": return I18n.roleMaster;
    default: return role;
  }
}

bool isLoggedIn = false;
int userid = 0;
String username = isLoggedIn?username:I18n.roleVisitor;
String displayname = isLoggedIn?displayname:I18n.roleVisitor;
String email = isLoggedIn?email:"";
String userimg = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";
String role = isLoggedIn?setRole(role):setRole("visitor");
int pageIndex = 0;

enum PageIndex{
  env,
  cam,
  r7d,
  forum,
  login,
  book,
}

enum Role{
  visitor,
  rookie,
  intermediate,
  advanced,
  master,
}
