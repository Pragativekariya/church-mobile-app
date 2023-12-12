import 'package:churchapp_flutter/audio_player/miniPlayer.dart';
import 'package:churchapp_flutter/screens/Downloader.dart';
import 'package:churchapp_flutter/screens/DrawerScreen.dart';
import 'package:churchapp_flutter/screens/SearchScreen.dart';
import 'package:churchapp_flutter/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/Categories.dart';
import '../models/ScreenArguements.dart';
import '../providers/CategoriesModel.dart';
import '../screens/NoitemScreen.dart';
import '../screens/CategoriesMediaScreen.dart';
import '../i18n/strings.g.dart';

class CategoriesScreen extends StatefulWidget {
  static const routeName = "/categories";
  CategoriesScreen();

  @override
  CategoriesScreenRouteState createState() => new CategoriesScreenRouteState();
}

class CategoriesScreenRouteState extends State<CategoriesScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CategoriesModel(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60.0,
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "BIOPHONICS",
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(AppBar().preferredSize.height),
                  child: Icon(
                    Icons.cloud_download,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, Downloader.routeName,
                        arguments: ScreenArguements(
                          position: 0,
                          items: null,
                        ));
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: (() {
                    Navigator.pushNamed(context, SearchScreen.routeName);
                  })),
            )
          ],
        ),
        //  appBar: AppBar(
        //    centerTitle: true,
        //       elevation: 0,
        //   title: Text(t.categories),
        //  ),
        drawer: Container(
          color: MyColors.grey_95,
          width: 300,
          child: Drawer(
            key: scaffoldKey,
            child: DrawerScreen(),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 0),
          child: Column(
            children: [
              Expanded(
                child: CategoriesPageBody(),
              ),
              MiniPlayer(),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CategoriesModel categoriesModel = Provider.of<CategoriesModel>(context);
    List<Categories> items = categoriesModel.categories;
    if (categoriesModel.isLoading) {
      return Center(
          child: CupertinoActivityIndicator(
        radius: 20,
      ));
    } else if (categoriesModel.isError) {
      return NoitemScreen(
          title: t.oops,
          message: t.dataloaderror,
          onClick: () {
            categoriesModel.loadItems();
          });
    } else
      return ListView.builder(
        itemCount: categoriesModel.categories.length,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(20),

        //  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 1,
        //    crossAxisSpacing: 10.0,
        //    mainAxisSpacing: 8.0,
        //   childAspectRatio: 1),
        itemBuilder: (BuildContext context, int index) {
          return ItemTile(
            index: index,
            categories: items[index],
          );
        },
      );
  }
}

class ItemTile extends StatelessWidget {
  final Categories categories;
  final int index;

  const ItemTile({
    Key key,
    @required this.index,
    @required this.categories,
  })  : assert(index != null),
        assert(categories != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: InkWell(
        child: Container(
          height: 350.0,
          //width: 120.0,
          child: Column(
            children: <Widget>[
              Container(
                height: 300,
                //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: categories.thumbnailUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        Center(child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) => Center(
                        child: Icon(
                      Icons.error,
                      color: Colors.grey,
                    )),
                  ),
                ),
              ),
              SizedBox(height: 7.0),
              Container(
                alignment: Alignment.center,
                child: Text(
                  categories.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 3.0),
              Container(
                alignment: Alignment.center,
                child: Text(
                  categories.mediaCount.toString() + " " + "Warm Ups",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                    color: Colors.blueGrey[300],
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            CategoriesMediaScreen.routeName,
            arguments: ScreenArguements(position: 0, items: categories),
          );
        },
      ),
    );
  }
}
