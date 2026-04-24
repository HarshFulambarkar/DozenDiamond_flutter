'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "43c7938d6713d0287f1c7c5efba89711",
"version.json": "4b50c29f03fae6384225a8cf60de3074",
"index.html": "82b00d78ea1a81189c13788cea54f671",
"/": "82b00d78ea1a81189c13788cea54f671",
"main.dart.js": "c5360206a574d703d73e81b24ff5d437",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"dozendiamond_logo.jpeg": "76309ac5b290652ff8600b86f049ab1b",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "008e492f1749564b5f3884ba0777e173",
"dd_logo.png": "6b8824e2cefd934529ec38b9bc26e287",
"assets/NOTICES": "0afad8916d66b108bfc50ede2401bab9",
"assets/FontManifest.json": "61e363511a622c9e9492048250a5240e",
"assets/AssetManifest.bin.json": "3cd31b096d890d012a91c8782c7ec317",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "863b65eeaafd669d88240bf01cf860ff",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Regular-400.otf": "b2703f18eee8303425a5342dba6958db",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Brands-Regular-400.otf": "1fcba7a59e49001aa1b4409a25d425b0",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Solid-900.otf": "bd0b6e525827b8d91d5dd0d03486b450",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/flutter_tex/core/mathjax_core.js": "bdcf952800b9ddf46fa37fe538998af0",
"assets/packages/flutter_tex/core/flutter_tex.html": "b81cac5261651ce858b042f29e1dab82",
"assets/packages/flutter_tex/core/flutter_tex.css": "062a3279da48d0913eeeeb0d2266e26f",
"assets/packages/flutter_tex/core/flutter_tex.js": "ef7d2eb428e17c123a71674439b9d892",
"assets/packages/flutter_tax/js/flutter_tex.js": "84d34be9f6b2f779d2a31430c8b08756",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/lib/manage_brokers/assets/shoonya.png": "33279d21a59e39f211255f4db0938ee8",
"assets/lib/manage_brokers/assets/profitmart.jpeg": "da8b163b4df5e85071b1b518e3ef2d0a",
"assets/lib/manage_brokers/assets/iifl.png": "feb31920f5c1152b2636bfc26c2b5072",
"assets/lib/manage_brokers/assets/icici.png": "02435e9cec5d9f80dab52534d70ff663",
"assets/lib/manage_brokers/assets/paach_paisa_logo.png": "fec2c38b15f576c728cacf73a298c50e",
"assets/lib/manage_brokers/assets/motilal_oswal.jpg": "0e8cb08ed62d9046d130effefd8194c1",
"assets/lib/manage_brokers/assets/angel_one.png": "ab50f4af09320392ab8dfbcdb566a02f",
"assets/lib/manage_brokers/assets/smc_logo.png": "2d2288a2a2a370f1cd4a5d7605e51190",
"assets/lib/manage_brokers/assets/kotak_neo.png": "85c77ca8066c553ff30847db201981e1",
"assets/lib/manage_brokers/assets/upstox.jpeg": "cfb1389f74d9c3493bd5d9c826f1ddc1",
"assets/lib/manage_brokers/assets/zerodha.jpeg": "1c05ece9956979d6e4d63750df6a4bd3",
"assets/lib/manage_brokers/assets/sherkhan.jpg": "48cbdd8f941ca1bd025d67555f46935b",
"assets/lib/ZH_analysisAlpha/assets/JSON/dummy_actual_vs_computed_alpha_us.json": "9903b186f3f622b3e30fb4b3acc82123",
"assets/lib/ZH_analysisAlpha/assets/JSON/dummy_actual_vs_computed_alpha.json": "9903b186f3f622b3e30fb4b3acc82123",
"assets/lib/welcome_screens/assets/images/welcome_image_2.png": "472ef978c68dce6deaf7383c3d0b1ae8",
"assets/lib/welcome_screens/assets/images/welcome_image_3.png": "991a6f1bbffc5078773ed34ab0933200",
"assets/lib/welcome_screens/assets/images/welcome_image_1.png": "a2625749b2a6aace2a713e3e05cc99d0",
"assets/lib/welcome_screens/assets/icons/kosh_icon.svg": "23869581c054f95ec5b402e7031fcd36",
"assets/lib/ZH_analysisSettledRecentTrade/assets/JSON/dummy_settled_recent_trade_table_stocks.json": "2855b233bbe2447f45ef3a22921f82ec",
"assets/lib/ZH_analysisSettledRecentTrade/assets/JSON/dummy_settled_recent_trade_table_stocks_us.json": "2855b233bbe2447f45ef3a22921f82ec",
"assets/lib/AB_Ladder/assets/WIPRO.csv": "2ba2ef762033cf6fb49fe686a436806b",
"assets/lib/AB_Ladder/assets/ladder_assets_dummy.txt": "d41d8cd98f00b204e9800998ecf8427e",
"assets/lib/AB_Ladder/assets/AARTIIND.csv": "f58775782dd2ca0aacbc664f71757781",
"assets/lib/AB_Ladder/assets/AMZN.csv": "f4ef019e0c173b4ffcbcc91fce884389",
"assets/lib/AB_Ladder/assets/TCS.csv": "49a0047981d6c6b8ed5c68aa14c8f2cf",
"assets/lib/AB_Ladder/assets/MSFT.csv": "96bc29f95019c2a178691dbe92f6fd13",
"assets/lib/AB_Ladder/assets/GOOG.csv": "b820696113787c58c713bb805b0c08d5",
"assets/lib/ZL_register/assets/images/flags1/che.png": "d44e6f4633f3a31c5b9362ee3f4a0108",
"assets/lib/ZL_register/assets/images/flags1/civ.png": "eb48d98bf2e6c5f7ee76d675bb87b322",
"assets/lib/ZL_register/assets/images/flags1/asm.png": "e97f26092908af1444f6c43a7f2b79fa",
"assets/lib/ZL_register/assets/images/flags1/qat.png": "3e3e61b453ea4758d2fbfc66ebb45a08",
"assets/lib/ZL_register/assets/images/flags1/gha.png": "7704b982e13de49c6c2d6ab36b4e2b63",
"assets/lib/ZL_register/assets/images/flags1/bvt.png": "dbdb9f8ac5d68206d2594c794cc40337",
"assets/lib/ZL_register/assets/images/flags1/phl.png": "0d0a3524a936051c844942be722123ad",
"assets/lib/ZL_register/assets/images/flags1/ggy.png": "e85196fff070146110f1b0248ecb2745",
"assets/lib/ZL_register/assets/images/flags1/blz.png": "b45b7b8986577fde99e5e45ade93b908",
"assets/lib/ZL_register/assets/images/flags1/blm.png": "25422782415b282a34fdcbacb33b5d2d",
"assets/lib/ZL_register/assets/images/flags1/khm.png": "f84f1d590e658107b07c467d3d3aad6e",
"assets/lib/ZL_register/assets/images/flags1/isr.png": "df890d0e43a14a93c1b5477a885d8a9c",
"assets/lib/ZL_register/assets/images/flags1/prt.png": "edba0baadd1ba7de1ffb4da0f178f883",
"assets/lib/ZL_register/assets/images/flags1/nzl.png": "836bd352344bc6cae216eb399284ee2f",
"assets/lib/ZL_register/assets/images/flags1/esh.png": "3fb86e5734f13adf07014f39c8b81a6f",
"assets/lib/ZL_register/assets/images/flags1/sur.png": "f67c7a9bed31d5df5813684a198a2d50",
"assets/lib/ZL_register/assets/images/flags1/swz.png": "7b261a4bcd414e1d2a3221775b9b20aa",
"assets/lib/ZL_register/assets/images/flags1/sle.png": "366f205ef6e9f4683e01d836731a5ffd",
"assets/lib/ZL_register/assets/images/flags1/sau.png": "70d94858c3038ac3623c273a3f215408",
"assets/lib/ZL_register/assets/images/flags1/svk.png": "afdcf56b8681539ed5db07855403d29d",
"assets/lib/ZL_register/assets/images/flags1/ven.png": "cf33a99e4f006817501dba105df3fb4a",
"assets/lib/ZL_register/assets/images/flags1/idn.png": "13d83641ab0410d67137ddfc113f988f",
"assets/lib/ZL_register/assets/images/flags1/ncl.png": "0490327003e80c67a54410e8d4158a0f",
"assets/lib/ZL_register/assets/images/flags1/pse.png": "3849363b230766e5d939bba6925c4378",
"assets/lib/ZL_register/assets/images/flags1/grl.png": "83d4e2e1bdf77b8c6b9c4f1d41fc6260",
"assets/lib/ZL_register/assets/images/flags1/egy.png": "af46dac212edcc1cd3cd91ba7c46ccdd",
"assets/lib/ZL_register/assets/images/flags1/syr.png": "8dbbffc2b525081c7ef9ab4d9c37d861",
"assets/lib/ZL_register/assets/images/flags1/flk.png": "4815dfb9ce0569e01cca267753091cf8",
"assets/lib/ZL_register/assets/images/flags1/cri.png": "3d750d2970ac13aaa40721d68f42457c",
"assets/lib/ZL_register/assets/images/flags1/cpv.png": "5f899343bf87b961eb14d8867c58db81",
"assets/lib/ZL_register/assets/images/flags1/aia.png": "bfeaa23e93cb0d509692e9270da7c68c",
"assets/lib/ZL_register/assets/images/flags1/mkd.png": "5df6906e82f1f8c4255dd37c598cb988",
"assets/lib/ZL_register/assets/images/flags1/mex.png": "6c6e7f803183e4eb8bb5d86790051a71",
"assets/lib/ZL_register/assets/images/flags1/mhl.png": "5ef95bae70ff566e440cbb39a7a0c96c",
"assets/lib/ZL_register/assets/images/flags1/svn.png": "fcfb3104092ef9ec9dffa7eeee768f9d",
"assets/lib/ZL_register/assets/images/flags1/hmd.png": "77f2e7ee2d97218ebfa17930dce31ba8",
"assets/lib/ZL_register/assets/images/flags1/bwa.png": "1bdd05578dc0f9f1dbd6c796c2edc268",
"assets/lib/ZL_register/assets/images/flags1/ltu.png": "93b6befaabd88449595682a8231d2c00",
"assets/lib/ZL_register/assets/images/flags1/irq.png": "033533dcabe60bea53bc4818b6afc5ee",
"assets/lib/ZL_register/assets/images/flags1/lbn.png": "acbaca76ba6c3c69c08d595f9687f2ef",
"assets/lib/ZL_register/assets/images/flags1/lby.png": "30352d56fa4ef01d060a2c19abd6a9da",
"assets/lib/ZL_register/assets/images/flags1/gib.png": "879c75052710a3b20121a522ca9327af",
"assets/lib/ZL_register/assets/images/flags1/dza.png": "a69c10dccfb7144bbc9c0ed34fc232c5",
"assets/lib/ZL_register/assets/images/flags1/mrt.png": "7a3f46aab6c61a816306f38c919e11a3",
"assets/lib/ZL_register/assets/images/flags1/vgb.png": "e660ba41b8a6f2bb26fcd849978494ca",
"assets/lib/ZL_register/assets/images/flags1/ago.png": "0a021aa386233a6a0634012526964713",
"assets/lib/ZL_register/assets/images/flags1/stp.png": "f3de3395128822611cf9914a10ae3859",
"assets/lib/ZL_register/assets/images/flags1/som.png": "b60a94c20fba00bb08ee97ea3b8c61ea",
"assets/lib/ZL_register/assets/images/flags1/slv.png": "110bf04c9526acd86157fd44f89cab11",
"assets/lib/ZL_register/assets/images/flags1/smr.png": "88c3a7ee8d0148dc8b5b2dc1f68e051f",
"assets/lib/ZL_register/assets/images/flags1/msr.png": "bfbe0a5369bd84f04252aefb794c9eb6",
"assets/lib/ZL_register/assets/images/flags1/btn.png": "9bb93973bd80fb494ec19b7ceaf73906",
"assets/lib/ZL_register/assets/images/flags1/ken.png": "88f1ce97e902e6e072473657977f78d5",
"assets/lib/ZL_register/assets/images/flags1/nld.png": "ffe75d56f7360956472f7f1807dc2498",
"assets/lib/ZL_register/assets/images/flags1/wlf.png": "c6ab4417eeed2098b7072a94ea9f6007",
"assets/lib/ZL_register/assets/images/flags1/eri.png": "45f75d722ad5fc35094d53df39bd5fe5",
"assets/lib/ZL_register/assets/images/flags1/syc.png": "29cdc895bd25f4129a42dd2cdcab686c",
"assets/lib/ZL_register/assets/images/flags1/slb.png": "5d52f2b8b4b30a8a1f5d50fe1254f35e",
"assets/lib/ZL_register/assets/images/flags1/arm.png": "9db5a093861b35bdb365902fb6b222cb",
"assets/lib/ZL_register/assets/images/flags1/maf.png": "a318d23e4fea530988e8cf7aa5cf9d5b",
"assets/lib/ZL_register/assets/images/flags1/vut.png": "d77623f401909c659209ee069cd1d139",
"assets/lib/ZL_register/assets/images/flags1/mmr.png": "a380a899645be150fe562254792ebce5",
"assets/lib/ZL_register/assets/images/flags1/sdn.png": "59a1b1252d40015d6c2864d0682c6f30",
"assets/lib/ZL_register/assets/images/flags1/moz.png": "8d061cb78ae08201c9486439f55594fa",
"assets/lib/ZL_register/assets/images/flags1/and.png": "0db09d038dcf38b2354f1d8ba76b977a",
"assets/lib/ZL_register/assets/images/flags1/tuv.png": "ad1800f4198ee6bbd4964ba7aaa0ec76",
"assets/lib/ZL_register/assets/images/flags1/gnb.png": "ddad04d24851749be07ac84bc0475f17",
"assets/lib/ZL_register/assets/images/flags1/usa.png": "9dccd8bbf59e3fbfe40e0e5e6bcac9c4",
"assets/lib/ZL_register/assets/images/flags1/pyf.png": "0d4d0fea078370e3bfec2d1c727d09fe",
"assets/lib/ZL_register/assets/images/flags1/npl.png": "357704329167475c1ea77252f5eaf155",
"assets/lib/ZL_register/assets/images/flags1/gtm.png": "cc64f14d924f41302dbcf90a2471b568",
"assets/lib/ZL_register/assets/images/flags1/mtq.png": "889434ebd4bb2b22fa13dd4dfb9deba0",
"assets/lib/ZL_register/assets/images/flags1/srb.png": "6db0b9672ff7489e8a7e32ef859b02a4",
"assets/lib/ZL_register/assets/images/flags1/ton.png": "713e97b946f076c069e5684482e0bf93",
"assets/lib/ZL_register/assets/images/flags1/dji.png": "14fe386216d32aa66415d6e3feef6e49",
"assets/lib/ZL_register/assets/images/flags1/mco.png": "974075e82842d952dcb6c44e8e361e88",
"assets/lib/ZL_register/assets/images/flags1/mar.png": "c198a6d35238225776ebb637e6bf8f6d",
"assets/lib/ZL_register/assets/images/flags1/shn.png": "236542c5c401fdd92ae88506e520f11a",
"assets/lib/ZL_register/assets/images/flags1/fro.png": "b5eb9a76d949d4ce6978ed25ea4646c9",
"assets/lib/ZL_register/assets/images/flags1/ssd.png": "e3aad65d0bd4cca98bd1c8f0734dd372",
"assets/lib/ZL_register/assets/images/flags1/myt.png": "66d194d51c512ff6c591d3c238fc8d36",
"assets/lib/ZL_register/assets/images/flags1/fji.png": "95a2df6c7c5da507537804fff80a8b63",
"assets/lib/ZL_register/assets/images/flags1/hku.png": "784fd8dc37554c1bc9546a5ab17cfab4",
"assets/lib/ZL_register/assets/images/flags1/zwe.png": "6d6649684865d196e6285cd12ec5c094",
"assets/lib/ZL_register/assets/images/flags1/rus.png": "a4d200c25e0b52fceade0017f8eac7a7",
"assets/lib/ZL_register/assets/images/flags1/bhr.png": "4eb8c6f5b79eafa6059afe4f48cbe459",
"assets/lib/ZL_register/assets/images/flags1/ita.png": "386e416002ca741c8d025414e7f46f5f",
"assets/lib/ZL_register/assets/images/flags1/ukr.png": "851d1e6d2d549d2d037a02741791673b",
"assets/lib/ZL_register/assets/images/flags1/bhs.png": "29fade24bf6601fe8638e7dad830d9e0",
"assets/lib/ZL_register/assets/images/flags1/cym.png": "87b9295926a3dcc5620352dc28768f0a",
"assets/lib/ZL_register/assets/images/flags1/mwi.png": "ecb712b61ef8d6b91bc74837626f5ee5",
"assets/lib/ZL_register/assets/images/flags1/mlt.png": "dffc17b29cf76d36aa37e23763a5f74b",
"assets/lib/ZL_register/assets/images/flags1/hrv.png": "1c9c4fabf228cf5f08d985b0543a3927",
"assets/lib/ZL_register/assets/images/flags1/jey.png": "f967e0f27b45d745390f4ed09606aa93",
"assets/lib/ZL_register/assets/images/flags1/cod.png": "60b703060db810388780501f51680c5f",
"assets/lib/ZL_register/assets/images/flags1/sgs.png": "a588d9232a23a26a15d7b33b3596d910",
"assets/lib/ZL_register/assets/images/flags1/spm.png": "6961e743779da221fc17de2664430c07",
"assets/lib/ZL_register/assets/images/flags1/hkg.png": "ff16522077088e3294e5c6e7eb513970",
"assets/lib/ZL_register/assets/images/flags1/cze.png": "56e3674893a39f31a861a15fb106087c",
"assets/lib/ZL_register/assets/images/flags1/brn.png": "37fb71582de829255ab89a3a5729f2f4",
"assets/lib/ZL_register/assets/images/flags1/eth.png": "b62d6aac8dffb850d3cfa1ccb85e973f",
"assets/lib/ZL_register/assets/images/flags1/pcn.png": "7e49332f6bf6305666792b96856a1b77",
"assets/lib/ZL_register/assets/images/flags1/guy.png": "cb05e193d32e6d1ca09b9dab90f4b710",
"assets/lib/ZL_register/assets/images/flags1/nru.png": "c0a8ebd32710006ab1e62240fd9a5d90",
"assets/lib/ZL_register/assets/images/flags1/pol.png": "1a16f62ac0e4397b0ccb70042faf46a7",
"assets/lib/ZL_register/assets/images/flags1/plw.png": "92a62cb13405f05ee61325da82dd2e73",
"assets/lib/ZL_register/assets/images/flags1/jpn.png": "013523c5acbc480143ef03eb4197c468",
"assets/lib/ZL_register/assets/images/flags1/mus.png": "eed56e32aa04396f227421f4e57a8b77",
"assets/lib/ZL_register/assets/images/flags1/abw.png": "c57c8193f40cf63b02ddefc21b139738",
"assets/lib/ZL_register/assets/images/flags1/twn.png": "1a1fad8a41aff77b3f96679201757ed3",
"assets/lib/ZL_register/assets/images/flags1/can.png": "08d6b60bd214d5a88daad803c12655f9",
"assets/lib/ZL_register/assets/images/flags1/tls.png": "76c4df3980561dacb8e7b52e6bec0bd7",
"assets/lib/ZL_register/assets/images/flags1/mac.png": "95507c6896574475ebc11767e1892f53",
"assets/lib/ZL_register/assets/images/flags1/fsm.png": "4a5d33eabe04ab744663eeca1c2ddd2d",
"assets/lib/ZL_register/assets/images/flags1/cog.png": "b26299ac47576178b9b65ee8ae5f7b6a",
"assets/lib/ZL_register/assets/images/flags1/deu.png": "94a3db23f1d0539d0646ed4f1f713d66",
"assets/lib/ZL_register/assets/images/flags1/sgp.png": "a784c8536396f4848955bfd2f61013b6",
"assets/lib/ZL_register/assets/images/flags1/vat.png": "40ebda892355114966c600b2b6ea2f36",
"assets/lib/ZL_register/assets/images/flags1/nga.png": "c35e24338e7144f9add7a09ac3853e20",
"assets/lib/ZL_register/assets/images/flags1/gum.png": "3ff905619541fcd22647beff2fab1e84",
"assets/lib/ZL_register/assets/images/flags1/bes.png": "32a4e6792fe7bff3e92619e46f4edcff",
"assets/lib/ZL_register/assets/images/flags1/ecu.png": "cf9f2282a4636efd980489eba3a189dd",
"assets/lib/ZL_register/assets/images/flags1/uga.png": "ab024779afeb2f2920d64e464483cf6a",
"assets/lib/ZL_register/assets/images/flags1/lka.png": "001f61f99d4718b554a504eeb8082c63",
"assets/lib/ZL_register/assets/images/flags1/gbr.png": "73c3cbcddc091966bde35f446c96055d",
"assets/lib/ZL_register/assets/images/flags1/gnq.png": "5603a141e9f4f18504cb4eab343b7905",
"assets/lib/ZL_register/assets/images/flags1/mys.png": "1cb1a85e1ed042c443dbebab83944f3a",
"assets/lib/ZL_register/assets/images/flags1/tur.png": "22f10c2ef19152d17955a1b8fb33d2de",
"assets/lib/ZL_register/assets/images/flags1/vnm.png": "a61c8b3642e61d5a8c54d3c42eb106d3",
"assets/lib/ZL_register/assets/images/flags1/aze.png": "e1579fbff5c945abd40d755e50bb3e4a",
"assets/lib/ZL_register/assets/images/flags1/sen.png": "2e82ba838ccb1a75d424437c0f5c5b5e",
"assets/lib/ZL_register/assets/images/flags1/cok.png": "98bac5a590f87fe9b18c11e17d6c4656",
"assets/lib/ZL_register/assets/images/flags1/omn.png": "18eb107e024517da448544f930f76797",
"assets/lib/ZL_register/assets/images/flags1/bra.png": "8456a4639f62a18cfe0c7f8655b7c75c",
"assets/lib/ZL_register/assets/images/flags1/ner.png": "195c53a9328c3da8334a8ff5f1f81491",
"assets/lib/ZL_register/assets/images/flags1/ind.png": "74fb4d265341d42e8422a6584ab55396",
"assets/lib/ZL_register/assets/images/flags1/lie.png": "508bd2b649c262690b93c0d41fde6610",
"assets/lib/ZL_register/assets/images/flags1/png.png": "e828558961e130103a8d7ac5c97f2c3f",
"assets/lib/ZL_register/assets/images/flags1/cyp.png": "4438d0c7cd046ac53f8612a8de9c2529",
"assets/lib/ZL_register/assets/images/flags1/fin.png": "cf07cc15a112623c4f6fdf6f65efb44b",
"assets/lib/ZL_register/assets/images/flags1/tcd.png": "50af69bf9db863810c942e93c19edd2f",
"assets/lib/ZL_register/assets/images/flags1/mli.png": "0683cd775f941c28bfd7b2d9e8770a5b",
"assets/lib/ZL_register/assets/images/flags1/sjm.png": "dbdb9f8ac5d68206d2594c794cc40337",
"assets/lib/ZL_register/assets/images/flags1/aus.png": "77f2e7ee2d97218ebfa17930dce31ba8",
"assets/lib/ZL_register/assets/images/flags1/zmb.png": "07646c15260c4885d761162fd57bb738",
"assets/lib/ZL_register/assets/images/flags1/cck.png": "3384914cf2dc99c2e2cfa7ed41d279d7",
"assets/lib/ZL_register/assets/images/flags1/tto.png": "fe1eb7e34d44d795e5c2153128b5f91d",
"assets/lib/ZL_register/assets/images/flags1/brb.png": "5ead64a1f351b5b95b3c2cf659587af6",
"assets/lib/ZL_register/assets/images/flags1/iot.png": "b8b58395b45faa34769178f8c740d51b",
"assets/lib/ZL_register/assets/images/flags1/bih.png": "ebab19e5e3f1a9aa04126618afc17f2f",
"assets/lib/ZL_register/assets/images/flags1/rou.png": "8929eb91cc2e717a903fbeb00aebf303",
"assets/lib/ZL_register/assets/images/flags1/pak.png": "314926d92541e90daebc99c589c96cdf",
"assets/lib/ZL_register/assets/images/flags1/ury.png": "3f6e7796adf8c177b4bc56ad97cfae0d",
"assets/lib/ZL_register/assets/images/flags1/nfk.png": "5b9f96b0738662f9bf5a3a302eb5686d",
"assets/lib/ZL_register/assets/images/flags1/ata.png": "a8858d876c5f990108bbb108f6558e87",
"assets/lib/ZL_register/assets/images/flags1/com.png": "5c6a991942aea19f19c62ad8f0b4140d",
"assets/lib/ZL_register/assets/images/flags1/cmr.png": "1ba4e2ffd0c59138e980bce0bfa04e70",
"assets/lib/ZL_register/assets/images/flags1/caf.png": "ef912e1657e02fa67d774356bc986a82",
"assets/lib/ZL_register/assets/images/flags1/tun.png": "635faffc46bfa5ff8f865fd8c8d3159f",
"assets/lib/ZL_register/assets/images/flags1/tza.png": "d12c9145999df9b4eb0d2c64c5a26b0b",
"assets/lib/ZL_register/assets/images/flags1/gab.png": "1188189d37cee29fd44bc030b5c1385c",
"assets/lib/ZL_register/assets/images/flags1/imn.png": "97d3111637f30a869d0ee3587e2fa6f7",
"assets/lib/ZL_register/assets/images/flags1/ben.png": "7a8cb4ebc9e14bb5f18234e5c9752f84",
"assets/lib/ZL_register/assets/images/flags1/kos.png": "fdcca26afc5f017d24f5bddb003481f2",
"assets/lib/ZL_register/assets/images/flags1/kor.png": "347e3f67ab4b6117e42b8e12b369716f",
"assets/lib/ZL_register/assets/images/flags1/kna.png": "e2857f64bbd8c1597dcdc686427da6b4",
"assets/lib/ZL_register/assets/images/flags1/guf.png": "108f04a4998e93da5cd6e53a50a357e0",
"assets/lib/ZL_register/assets/images/flags1/wsm.png": "7a803133ad6451beea44281c4fc22d78",
"assets/lib/ZL_register/assets/images/flags1/kwt.png": "52bbfff669ffcfd810b6e3b07ce10c72",
"assets/lib/ZL_register/assets/images/flags1/pan.png": "f87bee4b7d9b9b3665717f656a368824",
"assets/lib/ZL_register/assets/images/flags1/rwa.png": "3b6a2b4c5534b2eeabfc9e45ec189d6e",
"assets/lib/ZL_register/assets/images/flags1/cxr.png": "35389c9b393d168bc333c2da4d031b2f",
"assets/lib/ZL_register/assets/images/flags1/cub.png": "a4fe95bfea0fbb0e34bccd1fe8aadc08",
"assets/lib/ZL_register/assets/images/flags1/alb.png": "5d3630f58937059269efdd952203f40c",
"assets/lib/ZL_register/assets/images/flags1/mnp.png": "ae24d1d0137f018602ac2b6b4c908359",
"assets/lib/ZL_register/assets/images/flags1/mng.png": "091a4443de228168a92b3ce1453ac236",
"assets/lib/ZL_register/assets/images/flags1/col.png": "928a9a409e581e74ab0c6c6a4638665c",
"assets/lib/ZL_register/assets/images/flags1/atf.png": "ff7ae5f4face0222fe9197200e8e0d88",
"assets/lib/ZL_register/assets/images/flags1/mne.png": "b71d8b3240d1a33cbadcad9837fcbe78",
"assets/lib/ZL_register/assets/images/flags1/cuw.png": "cbea59d1e09a24806409b0a23cb9041c",
"assets/lib/ZL_register/assets/images/flags1/gmb.png": "4d44046d66a964666f8315fd036f0981",
"assets/lib/ZL_register/assets/images/flags1/yem.png": "4bcf117adb59ccfcdac94353c79da8c8",
"assets/lib/ZL_register/assets/images/flags1/nic.png": "52eccf8a59c564198d9709bb00de71a1",
"assets/lib/ZL_register/assets/images/flags1/lso.png": "f690c75a370656e8ea48f3ec292a012f",
"assets/lib/ZL_register/assets/images/flags1/bdi.png": "f72d526cf2b8d5365358225ade59cfe5",
"assets/lib/ZL_register/assets/images/flags1/bgr.png": "f68718cbc8755f6352af306e384d4915",
"assets/lib/ZL_register/assets/images/flags1/bfa.png": "3b5d8e39c8a4267dfdbf1a1e41bfc824",
"assets/lib/ZL_register/assets/images/flags1/bgd.png": "cd8cbe6e8ef2ebfc86d73fc8bfc093cb",
"assets/lib/ZL_register/assets/images/flags1/bel.png": "acb49af404eb9679be5047aae0157475",
"assets/lib/ZL_register/assets/images/flags1/kaz.png": "bc6dcfc7fda8b5e4cd4d2599e25ae28e",
"assets/lib/ZL_register/assets/images/flags1/niu.png": "50a0921e32baf80eaa2c514af8060ae3",
"assets/lib/ZL_register/assets/images/flags1/glp.png": "827eac513c414bc10b29cbbfe4e9e959",
"assets/lib/ZL_register/assets/images/flags1/vct.png": "dbfbd63a6f46c5eeb6c16127e446fcc3",
"assets/lib/ZL_register/assets/images/flags1/ala.png": "cf5cf6fc9282503aed29f7b783091bca",
"assets/lib/ZL_register/assets/images/flags1/tca.png": "53168910b6b047a2c700339c66e82c73",
"assets/lib/ZL_register/assets/images/flags1/atg.png": "5ff70e9225a7a7a953f521de45863c4f",
"assets/lib/ZL_register/assets/images/flags1/fra.png": "a318d23e4fea530988e8cf7aa5cf9d5b",
"assets/lib/ZL_register/assets/images/flags1/zaf.png": "38737b75bbbd94c2865549a11bc40057",
"assets/lib/ZL_register/assets/images/flags1/aut.png": "57a8facf75e7b0f484ec6613eb20185c",
"assets/lib/ZL_register/assets/images/flags1/tha.png": "d39d3d0ca5fc7f6fd3d4e03f7fd3807e",
"assets/lib/ZL_register/assets/images/flags1/chl.png": "e70f0d73fd2d8513a34b433382ba8af0",
"assets/lib/ZL_register/assets/images/flags1/tkm.png": "073b37304c35b4f32cd31cd244ae910a",
"assets/lib/ZL_register/assets/images/flags1/hti.png": "a5e760a756b61a8ecf197736259ef07f",
"assets/lib/ZL_register/assets/images/flags1/swe.png": "7c17433894c167a65224a814bf09216c",
"assets/lib/ZL_register/assets/images/flags1/nor.png": "dbdb9f8ac5d68206d2594c794cc40337",
"assets/lib/ZL_register/assets/images/flags1/geo.png": "498638f192aa6a56d91587d4f97a6ff9",
"assets/lib/ZL_register/assets/images/flags1/prk.png": "bba4b51a730f15f8e6dbbc2f5f6a9829",
"assets/lib/ZL_register/assets/images/flags1/isl.png": "ef1b637ab33ba82b5649cd14fa9b343e",
"assets/lib/ZL_register/assets/images/flags1/blr.png": "5b05e797cc8c209070b8192c19d1b06f",
"assets/lib/ZL_register/assets/images/flags1/tgo.png": "5ca8348a187f61ac4a5f3a6f068ce269",
"assets/lib/ZL_register/assets/images/flags1/mda.png": "51017a6885ab1eedd620aae36be9104f",
"assets/lib/ZL_register/assets/images/flags1/dnk.png": "f6a6be8d88db90ed6958e2ca231021eb",
"assets/lib/ZL_register/assets/images/flags1/tkl.png": "4b5e1fd9bc8323ab5a028b55ff36b5c1",
"assets/lib/ZL_register/assets/images/flags1/mdv.png": "27d07854c646f5991e5fef895a74ddd6",
"assets/lib/ZL_register/assets/images/flags1/dom.png": "f02810f6e0bbc22bd6cb540400bfd521",
"assets/lib/ZL_register/assets/images/flags1/hun.png": "06a584530e4f21c2a291ac2f08d40de3",
"assets/lib/ZL_register/assets/images/flags1/hnd.png": "fdd8bf6ccba3ff6ad0df4e082d52a539",
"assets/lib/ZL_register/assets/images/flags1/nam.png": "d18363d4e916a31ccb778dceb26a7c27",
"assets/lib/ZL_register/assets/images/flags1/est.png": "0249dc8c30729ccc0e84ac23aeb227bf",
"assets/lib/ZL_register/assets/images/flags1/lao.png": "b82792a90b25c9f936d474b898917e71",
"assets/lib/ZL_register/assets/images/flags1/reu.png": "a318d23e4fea530988e8cf7aa5cf9d5b",
"assets/lib/ZL_register/assets/images/flags1/pri.png": "cdcd9119db789cf29f15f814542543a7",
"assets/lib/ZL_register/assets/images/flags1/bmu.png": "6115a3595b7027fde1ba5f9dcc9a1d3c",
"assets/lib/ZL_register/assets/images/flags1/grd.png": "e5473b8c438a2f964a7f1d4a203c768f",
"assets/lib/ZL_register/assets/images/flags1/gin.png": "6fb63a74fc0998f8e79507f3bdc776b7",
"assets/lib/ZL_register/assets/images/flags1/afg.png": "0005a1af5f7e362f1a6da1afa4b42474",
"assets/lib/ZL_register/assets/images/flags1/vir.png": "7ca3c745ccf5494aefd4fb9987dfdab7",
"assets/lib/ZL_register/assets/images/flags1/chn.png": "9cc597ef64ddbd396cff82ef14cb5d15",
"assets/lib/ZL_register/assets/images/flags1/tjk.png": "425ea7ad94d377677da610313cbf86ed",
"assets/lib/ZL_register/assets/images/flags1/lux.png": "f73e6d5e9f13596a2b58abff55ef5c13",
"assets/lib/ZL_register/assets/images/flags1/uzb.png": "2673747d1f0cb6dbd6ec897e2edbd5ae",
"assets/lib/ZL_register/assets/images/flags1/irn.png": "fc8f0cc6efeb0132904be687d56d747a",
"assets/lib/ZL_register/assets/images/flags1/kgz.png": "0901a0c5ebf03e45a5624133a2cf709a",
"assets/lib/ZL_register/assets/images/flags1/per.png": "23aff2caee7f0f9ab14573f4082934bd",
"assets/lib/ZL_register/assets/images/flags1/esp.png": "79c229a16fb9988ededf51cd945f141e",
"assets/lib/ZL_register/assets/images/flags1/sxm.png": "3e43e3c8724767a9b8fe4a7e5114c509",
"assets/lib/ZL_register/assets/images/flags1/dma.png": "d4f062d5c6395d9493c63a242ab8da6e",
"assets/lib/ZL_register/assets/images/flags1/arg.png": "3bb3447d54e802428c137dd156160acb",
"assets/lib/ZL_register/assets/images/flags1/jam.png": "d8f17b6c9310767ba860dc8093f19ca5",
"assets/lib/ZL_register/assets/images/flags1/mdg.png": "3ab542eb331283fb19646730272170e5",
"assets/lib/ZL_register/assets/images/flags1/are.png": "76afb78795d6aa62518cf1884c7e3c3e",
"assets/lib/ZL_register/assets/images/flags1/lca.png": "71d9b373b07964557500fd1d339c5385",
"assets/lib/ZL_register/assets/images/flags1/lbr.png": "d5654f5aacfd27997a6f4b9ff682dc1c",
"assets/lib/ZL_register/assets/images/flags1/grc.png": "7302c125501a68bf31a9ab363a484f6b",
"assets/lib/ZL_register/assets/images/flags1/pry.png": "a2a24ebb5646d098e7f401204746663c",
"assets/lib/ZL_register/assets/images/flags1/irl.png": "16e8b035c0ca8ee3365a82b837bc41eb",
"assets/lib/ZL_register/assets/images/flags1/kir.png": "321476970521ecbd29755b2c85077494",
"assets/lib/ZL_register/assets/images/flags1/umi.png": "9dccd8bbf59e3fbfe40e0e5e6bcac9c4",
"assets/lib/ZL_register/assets/images/flags1/bol.png": "27f4ece266cd8f3bd942d1d08e601f64",
"assets/lib/ZL_register/assets/images/flags1/lva.png": "d26769f4011230359ee65cff6d3e6a4c",
"assets/lib/ZL_register/assets/images/flags1/jor.png": "aaf6e014793f2e9229f45f210db20ca8",
"assets/lib/ZH_analysisSettledClosestTrade/assets/JSON/dummy_settled_closest_trade_table_stocks.json": "6f2828978f1689d1a77ecbcea6302dab",
"assets/lib/ZH_analysisSettledClosestTrade/assets/JSON/dummy_settled_closest_trade_table_stocks_us.json": "6f2828978f1689d1a77ecbcea6302dab",
"assets/lib/ZH_analysisPriceVsNumberOfStocks/assets/JSON/dummy_closed_order_price_and_units.json": "b3aa97a4eb8195c160e64857807c6611",
"assets/lib/ZH_analysisPriceVsNumberOfStocks/assets/JSON/dummy_closed_order_price_and_units_us.json": "cb5244a6e126eaad8d0d323f1bfeefb2",
"assets/lib/ZH_analysisPriceVsNumberOfStocks/assets/JSON/dummy_extra_cash_vs_price.json": "e50a9c8b51d7de75b1a10d57f56fbfa9",
"assets/lib/ZH_Analysis/assets/JSON/dummy_trade_analytics_stocks.json": "9d23c543b4e71d385c8e3ddaeda86c31",
"assets/lib/ZH_Analysis/assets/JSON/dummy_trade_analytics_stocks_us.json": "6c5c0196b8e18d6b933744899620c379",
"assets/lib/DD_Navigation/assets/home_icon_image.png": "53354423292ec646795c8a8c6a4c68c7",
"assets/lib/DD_Navigation/assets/watchlist_icon_image.png": "eb89e7b999abd0e4ed30c26ed546c4a2",
"assets/lib/DD_Navigation/assets/analytics_icon_image.png": "b0c60234c3356d5963104e6097c92dc9",
"assets/lib/DD_Navigation/assets/ladder_icon_image.png": "f3bc0f8aa11555d2d83be5e6bdb99589",
"assets/lib/DD_Navigation/assets/trade_icon_image.png": "b60b76b50f562cba6ba452ebe43bcd93",
"assets/lib/Splash_Screen/assets/dozen-unscreen.gif": "0fc358e533c99007575e17694a816b49",
"assets/lib/ZH_analysisTradeAnalytics/assets/JSON/dummy_all_trade_analytics_table.json": "6831ccc468f6e1eeb7ec3b387f94fe96",
"assets/lib/ZH_analysisTradeAnalytics/assets/JSON/dummy_all_trade_analytics_table_us.json": "c2aa874d8c7e31891af082db34e70e66",
"assets/lib/terms_of_use/assets/terms_of_use.pdf": "9d4a995689204bada8db22f9800406da",
"assets/lib/create_ladder_detailed/assets/images/formula_complete_bg_image.png": "60f99305f4c2300c38df423481be0ce6",
"assets/lib/create_ladder_detailed/assets/images/multiple_waves_image.png": "192e46c6b735bf0702dee92f037dc4cb",
"assets/lib/create_ladder_detailed/assets/images/bars_image.png": "3b55397d59a39499e53dcc69069dd2d7",
"assets/lib/create_ladder_detailed/assets/images/wave_image.png": "5ba94d68cc0320dc02f385870d6167b4",
"assets/lib/create_ladder_detailed/assets/images/pi_bar_image.png": "d6868488d47436c252328cc688b3b93e",
"assets/lib/create_ladder_detailed/assets/images/formula_complete_bg_image_2.png": "e0c97f48d64035fad114d72b7ac5666c",
"assets/lib/create_ladder_detailed/assets/images/big_formula_complete_bg_image.png": "cf2785e0fbce626f2d869308bcd889ea",
"assets/lib/ZH_analysisProfitVsPrice/assets/JSON/dummy_analytics_profit_vs_price_graph.json": "b54e26b51f7b23d0b832fc14ebcf1052",
"assets/lib/ZH_analysisProfitVsPrice/assets/JSON/dummy_analytics_profit_vs_price_graph_us.json": "ec63ceb8b8a5b9f2dce2816f7da93333",
"assets/lib/ZH_analysisUnsettledClosestBuy/assets/JSON/dummy_analytics_unsettled_closest_buy_table.json": "753a8cff7a2aa21100ad578c49720f6f",
"assets/lib/ZH_analysisUnsettledClosestBuy/assets/JSON/dummy_analytics_unsettled_closest_buy_table_us.json": "b44082302d0b621059ecddeac8bbd03b",
"assets/lib/global/assets/images/first_news.jpg": "088099a60a7728d0e922cff55b367274",
"assets/lib/global/assets/images/graph_image.png": "7aa51c73fe2b1c139278afd07d9e9078",
"assets/lib/global/assets/images/gain_loss.jpg": "3ecc844df204152d09dd38dd6ca4d96c",
"assets/lib/global/assets/images/home_bg2.png": "046406e3c037439cd7afb47768280a6b",
"assets/lib/global/assets/images/repurchase.png": "0fa976e4a9bcfe529fc5a935cf8ddcda",
"assets/lib/global/assets/images/home_bg3.png": "6c47a2339cd84b67bec70066cb483786",
"assets/lib/global/assets/images/home_bg1.png": "0d703cb6b7b1267c16454df57fc68cf7",
"assets/lib/global/assets/images/gp_logo.png": "fa70fabb7a29d575d5e5d29989709b1f",
"assets/lib/global/assets/images/ic_profile.png": "26c3cf6eb051b75ac3f249a3fc388371",
"assets/lib/global/assets/images/balance_chart1.png": "673b94463963004aed357fb38f2312e2",
"assets/lib/global/assets/images/11104.jpg": "832b35389ac6853fad9cd98de54f9531",
"assets/lib/global/assets/images/fingerprint.png": "c17b76bb8377d3cca281a51bcb6397fa",
"assets/lib/global/assets/images/apple.png": "1be8de544ba5972870816d98c71e83d5",
"assets/lib/global/assets/images/animatedtrade.gif": "4448dc98bd9bbfac94911301a18f8658",
"assets/lib/global/assets/images/home_bg.png": "c0c6d7ecc49cff09681347e6a2046371",
"assets/lib/global/assets/images/img1.jpeg": "191894022b1583b63849096a7a930cf4",
"assets/lib/global/assets/images/img1.png": "c1cdbb32391ff821953b6d8a66b9a232",
"assets/lib/global/assets/images/frame.jpg": "05f5328b2b4c3d91a647fe2e74b56407",
"assets/lib/global/assets/images/bhim_upi_icon.png": "8780e4f629fef60a345fcf7e1ad2edda",
"assets/lib/global/assets/images/wallet_image.png": "4808e03865165de452f1eef5430a749c",
"assets/lib/global/assets/images/google.png": "937c87b4439809d5b17b82728df09639",
"assets/lib/global/assets/images/imgbgpg.jpg": "519e41ccfbc5f5fca0ea1e1eb6b6f19e",
"assets/lib/global/assets/images/under_maintenance.png": "9cf6cc6f8362b6e0a785fd3ee08f7989",
"assets/lib/global/assets/images/facebook.png": "ac65533df079a192ce511d1c1e5889d6",
"assets/lib/global/assets/images/balance_chart.png": "b5f32a3f68a5e43f61a18adcfb9f7bf7",
"assets/lib/global/assets/logos/kosh_logo_without_bg.png": "27e2439438c2852ce5d629bdd6880fdd",
"assets/lib/global/assets/logos/ladder.png": "0b098defd238f5fee27722aaf318bdbd",
"assets/lib/global/assets/logos/kosh_logo_with_bg.jpeg": "6a302508d734e2440df0e0acb00df9a0",
"assets/lib/global/assets/logos/dozendiamond_logo.jpeg": "76309ac5b290652ff8600b86f049ab1b",
"assets/lib/global/assets/logos/logodrawer1.png": "bde81cf5f3f5cdb2ff1ebebd65bbbcc6",
"assets/lib/global/assets/icons/bullet.png": "5ba5b199722d110238a3c8f18e783102",
"assets/lib/global/assets/icons/ic_market.png": "98c6cd67be19f5391159de141ca55458",
"assets/lib/global/assets/icons/ic_about.png": "a4f64a3cfbb14922b400bb5ebda6385a",
"assets/lib/global/assets/icons/ic_investments.png": "ed108e10b36c48c1db1805a93f7a0c8e",
"assets/lib/global/assets/icons/ic_loss.png": "101d90bf3ba05f23b93938a43d2bd676",
"assets/lib/global/assets/icons/ic_faqs.png": "a41e2fa0247701f0b0a6e8d175b8f194",
"assets/lib/global/assets/icons/ic_news.png": "82b6a76a4d9e1e540e57f35d940f65c1",
"assets/lib/global/assets/icons/sell_buy_icon.png": "c29a792896f2dba0f33cf2bd98f3d7ce",
"assets/lib/global/assets/icons/ic_profit.png": "75ae4a1382bd6cbe2c5fdbd1429f63d3",
"assets/lib/global/assets/icons/ic_profile.png": "1e1844bd0875e65bbb939283fe5644b7",
"assets/lib/global/assets/icons/ladder_one_click_icon.png": "f00ff51e4bf51f7edc8dfe377d92bf07",
"assets/lib/global/assets/icons/ic_logout.png": "cca0256e7696cb44dc7cd4261b931d03",
"assets/lib/global/assets/icons/ic_subscribe.png": "d26664ac991b53eb40113646aac65ae6",
"assets/lib/global/assets/icons/diamond1.png": "265fae071d5e093f68cc50d1a9438ef9",
"assets/lib/global/assets/icons/frequency.png": "049541659ea135a735534cbc70a8fc18",
"assets/lib/global/assets/icons/order_book.png": "ffaa14ab2cd3f063bf29a27a6aeb81db",
"assets/lib/global/assets/icons/ladder_icon.gif": "73d5b44b7c684278761acf617a3fc23f",
"assets/lib/global/assets/icons/ic_change_password.png": "3243d9adff2851f6e91ce12471d8be59",
"assets/lib/global/assets/icons/suitcase.png": "b2c48da8cf2c582049312b29ba98ce86",
"assets/lib/global/assets/icons/ladder4.png": "ecfa75ac9f34046f875e3b9d84194185",
"assets/lib/global/assets/icons/filter.png": "4dde110e29dc1550ca4040bf85e2f5ad",
"assets/lib/global/assets/icons/notification_asset.png": "b8b206ebfc31e7f0ed33d0eb35558a87",
"assets/lib/global/assets/icons/money.png": "7cbe793f7907beaebc106df03ce8c73c",
"assets/lib/global/assets/icons/sort.png": "1fa518ef0cc3394389f12284ecb0d4e7",
"assets/lib/global/assets/icons/ic_terms_of_use.png": "72b42d48a672a7a68591837a92dc3138",
"assets/lib/global/assets/icons/docs.png": "776533f30c4ef6dc078a7a1d04928f55",
"assets/lib/global/assets/icons/ic_privacy_policy.png": "a3b7700a41cf652d3848112c7a1ad0dc",
"assets/lib/global/assets/icons/ic_wallet.png": "15a374da15c34627b4c2e76b45a85bec",
"assets/lib/global/assets/icons/ic_support.png": "4b940c629e77a881e4d7ef275d9f9762",
"assets/lib/global/assets/icons/data-analytics-icon.png": "58998bdae5b1c692bdd825657892ed99",
"assets/lib/global/assets/icons/ic_popular_icon.png": "1a52c4400f6569ba077d4d9dd6f3550e",
"assets/lib/global/assets/icons/setting.png": "560d9713a4b4c1dc23b599ed7f5abab7",
"assets/lib/global/assets/lottie/under_maintenance.gif": "1dcc95e3dc991cb97b124487a4716eb1",
"assets/lib/global/assets/fonts/Britanica/Britanica-Bold%2520Regular.ttf": "3e22b708fbe751e691bb13c597e57a40",
"assets/lib/global/assets/fonts/Britanica/Britanica-ExtraBold%2520Regular.ttf": "11415cddf6bab4ea3c18b1b1e0fab28c",
"assets/lib/global/assets/fonts/Poppins/Poppins-Regular.ttf": "093ee89be9ede30383f39a899c485a82",
"assets/lib/global/assets/fonts/Poppins/Poppins-Bold.ttf": "08c20a487911694291bd8c5de41315ad",
"assets/lib/global/assets/fonts/Poppins/Poppins-Italic.ttf": "c1034239929f4651cc17d09ed3a28c69",
"assets/lib/login/assets/images/google_icon.png": "647686d2ffde10dc2a13f02d6b5f29c0",
"assets/lib/login/assets/images/facebook_icon.png": "4fb65998b377cbedadbee97690d02e1a",
"assets/lib/ZH_analysisUnsettledRecentBuy/assets/JSON/dummy_analytics_unsettled_recent_buy_table_us.json": "c9163d1308f7ee59080f3644a1b5e14f",
"assets/lib/ZH_analysisUnsettledRecentBuy/assets/JSON/dummy_analytics_unsettled_recent_buy_table.json": "1af1be2e4338cd397b8a1cde6a3c2477",
"assets/lib/watchlist/assets/empty_watchlist_icon_image.png": "dd831d72c233f768aa210f0cb94c3050",
"assets/AssetManifest.bin": "114ed20e63b2dbd5725ebc39131e176b",
"assets/fonts/MaterialIcons-Regular.otf": "654b82f2d759b106c738bbabd9462ecd",
"assets/assets/worldcities.json": "4ba033ce8ce80e08b23e565eb0f3c1f4",
"dozendiamond_logo.png": "203db30a0c07628a5470710e941427c0",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
