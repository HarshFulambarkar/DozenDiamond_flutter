import 'package:dozen_diamond/DD_Navigation/widgets/nav_drawer_new.dart';
import 'package:dozen_diamond/articles/models/article_model.dart';
import 'package:dozen_diamond/articles/stateManagement/article_provider.dart';
import 'package:dozen_diamond/global/functions/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/functions/screenWidthRecoginzer.dart';

class ArticleDetailsScreen extends StatefulWidget {
  final ArticleModel article;
  const ArticleDetailsScreen({super.key, required this.article});

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  late ThemeProvider themeProvider;
  late ArticleProvider articleProvider;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    articleProvider = Provider.of<ArticleProvider>(context, listen: true);

    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    return Container(
      width: screenWidth,
      child: Scaffold(
        key: _key,
        resizeToAvoidBottomInset: false,
        backgroundColor: (themeProvider.defaultTheme)
            ? Color(0xfff0f0f0) //Color(0XFFF5F5F5)
            : Color(0xFF15181F),
        body: Center(
          child: SafeArea(
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
                  padding: const EdgeInsets.only(
                    top: 45.0,
                    left: 12,
                    right: 12,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      color: (themeProvider.defaultTheme)
                          ? Color(0XFFF5F5F5)
                          : Colors.transparent,
                      width: screenWidth,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            SizedBox(height: 10),
                            if (widget.article.articleImage != null)
                              SizedBox(
                                width: double.infinity,
                                child: Image.network(
                                  widget.article.articleImage ?? "",
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            // SizedBox(height: 10),
                            // Text(
                            //   '${widget.article.title}',
                            //   overflow: TextOverflow.ellipsis,
                            //   style: GoogleFonts.poppins(
                            //     color: (themeProvider.defaultTheme)
                            //         ? Color(0xff141414)
                            //         : Color(0xfff0f0f0),
                            //     fontSize: 20,
                            //     fontWeight: FontWeight.w400,
                            //   ),
                            // ),
                            SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '${Utility().formatUtcToLocal(widget.article.createdAt) ?? "-"}',
                                style: TextStyle(
                                  color: (themeProvider.defaultTheme)
                                      ? Color(0xff141414)
                                      : Color(0xffa2b0bc), //Color(0xff545455),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  // Optional: limits the text to 2 lines
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'Author - ${widget.article.author}',
                                style: GoogleFonts.poppins(
                                  color: (themeProvider.defaultTheme)
                                      ? Color(0xff141414)
                                      : Color(0xfff0f0f0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Markdown(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              data: widget.article.content,
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
                        ),
                      ),
                    ),
                  ),
                ),
                CustomHomeAppBarWithProviderNew(
                  backButton: true,
                  leadingAction: _triggerDrawer,
                  isForPop: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
