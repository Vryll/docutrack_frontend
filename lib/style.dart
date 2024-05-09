import 'package:flutter/material.dart';

const primaryColor = Color(0xFF800000);
const secondaryColor = Color(0xFFFFFFFF);
const grey = Color(0xFF9F9F9F);

/// RESPONSIVE DESIGNS (font sizes, image sizes, buttons sizes, container sizes)

///FONTS
// Used in all AdminPages
double size50_40(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 600) {
    return 40;
  } else {
    return 50;
  }
}

// Used in SigningPage
double size70_37(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 320) {
    return 40;
  } else if (screenWidth < 600) {
    return 53;
  } else if (screenWidth < 1100) {
    return 60;
  } else {
    return 70;
  }
}
double size58_27(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 320) {
    return 27;
  } else if (screenWidth < 600) {
    return 25;
  } else if (screenWidth < 1100) {
    return 45;
  } else {
    return 58;
  }
}
double size14_07(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 320) {
    return 7;
  } else if (screenWidth < 600) {
    return 6;
  } else if (screenWidth < 1100) {
    return 11;
  } else {
    return 14;
  }
}

// Used in HomePage
double size70_27(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 350) {
    return 27;
  } else if (screenWidth < 500) {
    return 30;
  } else if (screenWidth < 600) {
    return 35;
  } else if (screenWidth < 800) {
    return 40;
  } else if (screenWidth < 900) {
    return 45;
  } else if (screenWidth < 1000) {
    return 50;
  } else if (screenWidth < 1100) {
    return 55;
  } else if (screenWidth < 1200) {
    return 60;
  } else if (screenWidth < 1300) {
    return 65;
  } else {
    return 70;
  }
}
double size20_15(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 400) {
    return 15;
  } else if (screenWidth < 500) {
    return 15.5;
  } else if (screenWidth < 600) {
    return 16;
  } else if (screenWidth < 700) {
    return 16.5;
  } else if (screenWidth < 800) {
    return 17;
  } else if (screenWidth < 900) {
    return 17.5;
  } else if (screenWidth < 1000) {
    return 18;
  } else if (screenWidth < 1100) {
    return 18.5;
  } else if (screenWidth < 1200) {
    return 19;
  } else if (screenWidth < 1300) {
    return 19.5;
  } else {
    return 20;
  }
}

// Used in SplashPage
// double size80_24(context) {
//   final screenWidth = MediaQuery.of(context).size.width;
//
//   if (screenWidth < 350) {
//     return 28;
//   } else if (screenWidth < 400) {
//     return 34;
//   } else if (screenWidth < 620) {
//     return 38;
//   } else if (screenWidth < 750) {
//     return 45;
//   } else if (screenWidth < 900) {
//     return 55;
//   } else if (screenWidth < 1100) {
//     return 70;
//   } else {
//     return 80;
//   }
// }
// double size19_06(context) {
//   final screenWidth = MediaQuery.of(context).size.width;
//
//   if (screenWidth < 300) {
//     return 6.3;
//   }
//   // else if (screenWidth < 500) {
//   //   return 7.8;
//   // }
//   else if (screenWidth < 620) {
//     return 8;
//   } else if (screenWidth < 750) {
//     return 11;
//   } else if (screenWidth < 900) {
//     return 13.5;
//   } else if (screenWidth < 1100) {
//     return 17;
//   } else {
//     return 19;
//   }
// }

// Used in ProfilePage, EditProfilePage, OverviewPage
double size40_18(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 300) {
    return 18;
  } else if (screenWidth < 500) {
    return 22;
  } else if (screenWidth < 620) {
    return 25;
  } else if (screenWidth < 780) {
    return 27;
  } else if (screenWidth < 870) {
    return 30;
  } else if (screenWidth < 920) {
    return 35;
  } else if (screenWidth < 1100) {
    return 38;
  } else {
    return 40;
  }
}
double size18_15(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 600) {
    return 15;
  } else if (screenWidth < 900) {
    return 16;
  } else {
    return 18;
  }
}
double size16_10(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 300) {
    return 12;
  } else if (screenWidth < 900) {
    return 14;
  } else {
    return 16;
  }
}
double size40_20(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 680) {
    return 20;
  } else if (screenWidth < 800) {
    return 25;
  } else if (screenWidth < 850) {
    return 23;
  } else if (screenWidth < 920) {
    return 25;
  } else if (screenWidth < 1050) {
    return 30;
  } else if (screenWidth < 1200) {
    return 35;
  } else {
    return 40;
  }
}

// Used in AdminDrawerPage
double size22_14(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth <= 600) {
    return 22;
  } else if (screenWidth < 950) {
    return 20;
  } else {
    return 23;
  }
}
double size05_04(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth <= 600) {
    return 5.5;
  } else if (screenWidth < 950) {
    return 4.5;
  } else {
    return 6;
  }
}

// Used in DashboardPage & WorkspacePage
double size60_30(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth <= 350) {
    return 30;
  } else if (screenWidth < 400) {
    return 40;
  } else if (screenWidth < 950) {
    return 50;
  } else if (screenWidth < 1100) {
    return 40;
  } else if (screenWidth < 1300) {
    return 55;
  } else {
    return 70;
  }
}
double size18_12(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth <= 350) {
    return 11;
  } else if (screenWidth < 400) {
    return 13;
  } else if (screenWidth < 950) {
    return 15;
  } else if (screenWidth < 1100) {
    return 13;
  } else if (screenWidth < 1300) {
    return 16;
  } else {
    return 18;
  }
}
double size15_12(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth <= 600) {
    return 12;
  } else if (screenWidth < 800) {
    return 13;
  } else if (screenWidth < 1000) {
    return 14;
  } else {
    return 15;
  }
}

// Used in AboutUsPage
double size16_14(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 320) {
    return 12;
  } else if (screenWidth < 600) {
    return 14;
  } else if (screenWidth < 900) {
    return 15;
  } else {
    return 16;
  }
}
double size12_10(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 300) {
    return 9;
  } else if (screenWidth < 600) {
    return 10;
  } else if (screenWidth < 800) {
    return 11;
  } else if (screenWidth < 1000) {
    return 13;
  } else if (screenWidth < 1200) {
    return 14;
  } else {
    return 15;
  }
}
double size11_09(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 300) {
    return 8;
  } else if (screenWidth < 600) {
    return 9;
  } else if (screenWidth < 800) {
    return 10;
  } else if (screenWidth < 1000) {
    return 11;
  } else if (screenWidth < 1200) {
    return 12;
  } else {
    return 13;
  }
}

// Used in GenerateQRCodePage
double size18_14(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 300) {
    return 12;
  } else if (screenWidth < 900) {
    return 18;
  } else if (screenWidth < 1055) {
    return 16;
  } else if (screenWidth < 1200) {
    return 17;
  } else {
    return 20;
  }
}

// Used in GenerateAccountPage
double size40_25(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 700) {
    return 25;
  } else if (screenWidth < 850) {
    return 30;
  } else if (screenWidth < 900) {
    return 35;
  } else if (screenWidth < 1200) {
    return 38;
  } else {
    return 40;
  }
}


/// IMAGES
// Used in ProfilePage, EditProfilePage, OverviewPage
double size200_70(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 300) {
    return 70;
  } else if (screenWidth < 500) {
    return 100;
  } else if (screenWidth < 620) {
    return 110;
  } else if (screenWidth < 750) {
    return 130;
  } else if (screenWidth < 900) {
    return 150;
  } else if (screenWidth < 1100) {
    return 180;
  } else {
    return 200;
  }
}
double size100_40(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 300) {
    return 40;
  } else if (screenWidth < 500) {
    return 50;
  } else if (screenWidth < 620) {
    return 55;
  } else if (screenWidth < 750) {
    return 65;
  } else if (screenWidth < 900) {
    return 75;
  } else if (screenWidth < 1100) {
    return 90;
  } else {
    return 100;
  }
}
double size100_50(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 680) {
    return 35;
  } else if (screenWidth < 800) {
    return 40;
  } else if (screenWidth < 850) {
    return 35;
  } else if (screenWidth < 920) {
    return 40;
  } else if (screenWidth < 1050) {
    return 50;
  } else if (screenWidth < 1200) {
    return 60;
  } else {
    return 80;
  }
}
double size50_25(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 680) {
    return 18;
  } else if (screenWidth < 800) {
    return 20;
  } else if (screenWidth < 850) {
    return 18;
  } else if (screenWidth < 920) {
    return 20;
  } else if (screenWidth < 1050) {
    return 25;
  } else if (screenWidth < 1200) {
    return 30;
  } else {
    return 40;
  }
}

// Used in SplashPage
double size80_28(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 300) {
    return 28;
  } else if (screenWidth < 350) {
    return 33;
  } else if (screenWidth < 400) {
    return 37;
  } else if (screenWidth < 450) {
    return 39;
  } else if (screenWidth < 500) {
    return 42;
  } else if (screenWidth < 550) {
    return 44;
  } else if (screenWidth < 600) {
    return 48;
  } else if (screenWidth < 650) {
    return 49;
  } else if (screenWidth < 700) {
    return 53;
  } else if (screenWidth < 750) {
    return 57;
  } else if (screenWidth < 800) {
    return 60;
  } else if (screenWidth < 850) {
    return 62;
  } else if (screenWidth < 900) {
    return 66;
  } else if (screenWidth < 1000) {
    return 69;
  } else if (screenWidth < 1100) {
    return 72;
  } else if (screenWidth < 1200) {
    return 75;
  } else if (screenWidth < 1300) {
    return 77;
  } else {
    return 80;
  }
}
double size19_06(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 300) {
    return 7;
  } else if (screenWidth < 350) {
    return 8;
  } else if (screenWidth < 400) {
    return 8.9;
  } else if (screenWidth < 450) {
    return 10;
  } else if (screenWidth < 500) {
    return 11;
  } else if (screenWidth < 550) {
    return 11.5;
  } else if (screenWidth < 600) {
    return 12;
  } else if (screenWidth < 650) {
    return 12.5;
  } else if (screenWidth < 700) {
    return 13.9;
  } else if (screenWidth < 750) {
    return 14;
  } else if (screenWidth < 800) {
    return 15;
  } else if (screenWidth < 850) {
    return 15.5;
  } else if (screenWidth < 900) {
    return 16.5;
  } else if (screenWidth < 1000) {
    return 17;
  } else if (screenWidth < 1100) {
    return 17.5;
  } else if (screenWidth < 1200) {
    return 18;
  } else if (screenWidth < 1300) {
    return 18.5;
  } else {
    return 19.5;
  }
}
double size200_60(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 300) {
    return 60;
  } else if (screenWidth < 350) {
    return 70;
  } else if (screenWidth < 500) {
    return 80;
  } else if (screenWidth < 600) {
    return 110;
  } else if (screenWidth < 750) {
    return 120;
  } else if (screenWidth < 800) {
    return 130;
  } else if (screenWidth < 850) {
    return 140;
  } else if (screenWidth < 900) {
    return 150;
  } else if (screenWidth < 1000) {
    return 160;
  } else if (screenWidth < 1100) {
    return 170;
  } else if (screenWidth < 1200) {
    return 180;
  } else if (screenWidth < 1300) {
    return 190;
  } else {
    return 200;
  }
}

// Used in SigningPage
double size130_70(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 320) {
    return 70;
  } else if (screenWidth < 1100) {
    return 70;
  } else {
    return 130;
  }
}


/// BUTTONS
// Used in ProfilePage & EditProfilePage
double size200_100(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 320) {
    return 100;
  } else if (screenWidth < 600) {
    return 130;
  } else if (screenWidth < 1100) {
    return 170;
  } else {
    return 200;
  }
}
double size55_35(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 320) {
    return 35;
  } else if (screenWidth < 600) {
    return 40;
  } else if (screenWidth < 800) {
    return 45;
  } else if (screenWidth < 1100) {
    return 50;
  } else {
    return 55;
  }
}

// Used in SigningPage
double size350_200(context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 320) {
    return 200;
  } else if (screenWidth < 600) {
    return 270;
  } else if (screenWidth < 1100) {
    return 300;
  } else {
    return 350;
  }
}


/// DRAWER
double size300_80(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth < 800) {
    return 130;
  } else if (screenWidth < 1000) {
    return 250;
  } else if (screenWidth < 1200) {
    return 300;
  } else {
    return 350;
  }
}

