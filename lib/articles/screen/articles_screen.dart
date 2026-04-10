import 'dart:math';

import 'package:dozen_diamond/DD_Navigation/widgets/nav_drawer_new.dart';
import 'package:dozen_diamond/articles/models/article_model.dart';
import 'package:dozen_diamond/articles/screen/article_details_screen.dart';
import 'package:dozen_diamond/articles/stateManagement/article_provider.dart';
import 'package:dozen_diamond/create_ladder_easy/widgets/custom_container.dart';
import 'package:dozen_diamond/global/functions/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/functions/screenWidthRecoginzer.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  late ThemeProvider themeProvider;
  late ArticleProvider articleProvider;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArticleProvider>().getArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    articleProvider = Provider.of<ArticleProvider>(context, listen: true);

    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    return Center(
      child: Container(
        width: screenWidth,
        child: Scaffold(
          key: _key,
          resizeToAvoidBottomInset: false,

          drawer: NavDrawerNew(),
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Container(
                    color: (themeProvider.defaultTheme)
                        ? Color(0XFFF5F5F5)
                        : Colors.transparent,
                    height: MediaQuery.of(context).size.height,
                    width: screenWidth,
                  ),
                ),
                Padding(
                  // padding: const EdgeInsets.only(top: 60.0),
                  padding: const EdgeInsets.only(top: 45.0),
                  child: Center(
                    child: Container(
                      color: (themeProvider.defaultTheme)
                          ? Color(0XFFF5F5F5)
                          : Colors.transparent,
                      width: screenWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Articles",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Britanica',
                                    color: (themeProvider.defaultTheme)
                                        ? Color(0xff141414)
                                        : Color(0xFFffffff),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 10),

                          Expanded(
                            child: articleProvider.isGettingArticles
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : articleProvider.articleList.isEmpty
                                ? Center(child: Text("No Articles"))
                                : ListView.builder(
                                    itemCount:
                                        articleProvider.articleList.length,
                                    itemBuilder: (context, index) {
                                      return articleCard(
                                        articleProvider.articleList[index],
                                        context,
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                CustomHomeAppBarWithProviderNew(
                  backButton: false,
                  leadingAction: _triggerDrawer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget articleCard(ArticleModel article, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12.0, bottom: 0),
      child: InkWell(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) {
          //       return ArticleDetailsScreen(article: article);
          //     },
          //   ),
          // );

          articleProvider.isExpanded[article.id] = !(articleProvider.isExpanded[article.id] ?? true);

          setState(() {

          });
          print("below is isExpanded section");
          print(articleProvider.isExpanded[article.id]);
        },
        child: CustomContainer(
          borderRadius: 15,
          // backgroundColor: Color(0xff28282a),
          backgroundColor: (themeProvider.defaultTheme)
              ? Color(0xffdadde6)
              : Color(0xff2c2c31),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // width: screenWidthRecognizer(context) * 0.63,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (article.articleImage != null)
                        SizedBox(
                          width: double.infinity,
                          child: Image.network(
                            article.articleImage ?? "",
                            height: 100,
                            fit: BoxFit.fill,
                          ),
                        ),
                      SizedBox(height: 10),
                      Text(
                        '${article.title}',
                        style: GoogleFonts.poppins(
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff141414)
                              : Color(0xfff0f0f0),
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Author - ${article.author}',
                        style: GoogleFonts.poppins(
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff141414)
                              : Color(0xfff0f0f0),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${Utility().formatUtcToLocal(article.createdAt) ?? "-"}',
                        style: TextStyle(
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff141414)
                              : Color(0xffa2b0bc), //Color(0xff545455),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          // Optional: limits the text to 2 lines
                        ),
                      ),
                      SizedBox(height: 10),
                      // Markdown(
                      //   padding: EdgeInsets.zero,
                      //   shrinkWrap: true,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   data: article.content.substring(
                      //     0,
                      //     min(150, article.content.length),
                      //   ),
                      // ),
                    ],
                  ),
                ),

                (articleProvider.isExpanded[article.id] == true)
                    ?buildExpandedSection(context, article)
                    :Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildExpandedSection(BuildContext context, ArticleModel article) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(height: 20),
        // SizedBox(height: 10),
        // if (article.articleImage != null)
        //   SizedBox(
        //     width: double.infinity,
        //     child: Image.network(
        //       article.articleImage ?? "",
        //       height: 250,
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        // SizedBox(height: 10),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 10),
        //   child: Text(
        //     '${Utility().formatUtcToLocal(article.createdAt) ?? "-"}',
        //     style: TextStyle(
        //       color: (themeProvider.defaultTheme)
        //           ? Color(0xff141414)
        //           : Color(0xffa2b0bc), //Color(0xff545455),
        //       fontSize: 16,
        //       fontWeight: FontWeight.w400,
        //       // Optional: limits the text to 2 lines
        //     ),
        //   ),
        // ),
        // SizedBox(height: 10),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 10),
        //   child: Text(
        //     'Author - ${article.author}',
        //     style: GoogleFonts.poppins(
        //       color: (themeProvider.defaultTheme)
        //           ? Color(0xff141414)
        //           : Color(0xfff0f0f0),
        //       fontSize: 16,
        //       fontWeight: FontWeight.w400,
        //     ),
        //   ),
        // ),
        SizedBox(height: 10),
        Markdown(
          padding: EdgeInsets.symmetric(horizontal: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          data: article.content,
          onTapLink: (text, href, title) {
            if (href != null) {
              launchUrl(
                Uri.parse(href),
                mode: LaunchMode.externalApplication,
              );
            }
          },
        ),
      ],
    );
  }
}
