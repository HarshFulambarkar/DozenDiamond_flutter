class ApiConstant {
  // static const domain = 'http://localhost:3000';
  static const wsDomain = 'wss://uat.dozendiamonds.com';
  // static const wsDomain = 'wss://zdmwd9k5-3000.inc1.devtunnels.ms'; // suraj new
  // static const wsDomain = 'wss://dqwh49qv-8000.inc1.devtunnels.ms'; // saif new
  // static const wsDomain = 'wss://dh9hsj16-3000.inc1.devtunnels.ms'; // harshal
  // static const wsDomain = 'wss://a8c70ae41d58.ngrok-free.app'; // harshalngrok
  // static const domain = 'https://api-app-backup-1.dozendiamonds.com'; // backup1
  // static const wsDomain = 'wss://api-app.dozendiamonds.com';
  // static const wsDomain = 'wss://jhthkkgf-3000.inc1.devtunnels.ms';
  // static const wsDomain = 'wss://jhthkkgf-8000.inc1.devtunnels.ms';
  static const wsDomain_new = 'wss://uat.dozendiamonds.com';
  // static const wsDomain_new = 'wss://zdmwd9k5-3000.inc1.devtunnels.ms'; // suraj new
  // static const wsDomain_new = 'wss://dqwh49qv-8000.inc1.devtunnels.ms'; // saif new
  // static const wsDomain_new = 'wss://dh9hsj16-3000.inc1.devtunnels.ms'; // harshal
  // static const wsDomain_new = 'wss://a8c70ae41d58.ngrok-free.app'; // harshal ngrok
  // // static const wsDomain = 'wss://2fw8x25q-3000.inc1.devtunnels.ms';
  // static const domain = 'https://uat.dozendiamonds.com'; //app.dozendiamonds.com
  static const domain =
      // "http://localhost:3000";
      // 'https://dev.dozendiamonds.com';
      // 'https://temp.dozendiamonds.com';
      'https://uat.dozendiamonds.com'; //app.dozendiamonds.com
      // 'https://8q9xl3gc-3000.inc1.devtunnels.ms'; // Nitesh
      // 'https://w9xkc9m0-3000.inc1.devtunnels.ms'; //Ayush
      // 'https://jrvtgmq3-3000.inc1.devtunnels.ms'; //Arman
      // 'https://pxkjng5f-3000.inc1.devtunnels.ms';    //Khomesh

  // "https://3.109.144.93";
  // 'https://temp.dozendiamonds.com'; //app.dozendiamonds.com
  // 'https://2fw8x25q-3000.inc1.devtunnels.ms'; // chaitanya
  // 'https://jhthkkgf-3000.inc1.devtunnels.ms'; // saif
  // 'https://8d22b8b5acc8.ngrok-free.app'; // saif new
  // 'https://dqwh49qv-3000.inc1.devtunnels.ms'; // saif new new
  // 'https://6f5100397c1b.ngrok-free.app'; // saif ngrok
  //  'https://xtmwvk5p-3000.inc1.devtunnels.ms'; // suraj
  // 'https://2fw8x25q-3000.inc1.devtunnels.ms'; //app.dozendiamonds.com
  // 'https://dh9hsj16-3000.inc1.devtunnels.ms'; // harshal
  //'https://3mnkf809-3000.inc1.devtunnels.ms'; // sohel
  // "https://dqwh49qv-3001.inc1.devtunnels.ms"; // saif
  // "https://zdmwd9k5-3000.inc1.devtunnels.ms"; // suraj new
  static const api = '/api';
  static const version = '1';
  static const baseUrl_v2 = "$domain/api/v1/user/";
  static const baseUrl_withoutUser = "$domain/api/v1/";
  static const baseurl_version_v2 = "$domain/v2/";
  static const baseUrl = "$domain/user/";
  static const baseUrl1 = "$domain/stocks/";
  static const baseUrl2 = "$domain/ladderRouter/user/";

  static const healthKey = "adbc678dozen";
  static const bearer = "Bearer";

  static const simpleBaseUrl = "$domain$api/v$version/";
  static const clientID = "DOZEN_DIAMONDS_CLIENT_ID";
  static const secretKey =
      "5+5`3LaZLjE[>nBq10tLcZ-{?/HlG]:uJZZ[A@LJZ/q+BcG^bBMtA(POv!}l2IohUBB/,%tNMep=B5]6GMLi:uJ}Bpm89`/FRlPG)Q8;K)~`:gI+I?";
  static const authorizationHeaderKeyName = "Authorization";
  static const Duration timeoutDuration = Duration(seconds: 30);

  static const String clientIdWeb =
      '486769585980-9pdlherrdr1ihv8tbp8v1qgjip1r070n.apps.googleusercontent.com';
}
