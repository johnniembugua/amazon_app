import 'package:amazon_clone/features/home/models/push_notification_model.dart';
import 'package:amazon_clone/features/home/widgets/addressbox.dart';
import 'package:amazon_clone/features/home/widgets/carousel_image.dart';
import 'package:amazon_clone/features/home/widgets/deal_of_day.dart';
import 'package:amazon_clone/features/home/widgets/top_categories.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../../constants/global_variables.dart';
import '../../search/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  //initialize some values
  late final FirebaseMessaging _messaging;
  late int _totalNotificationCounter;
  String? _fcmToken;
  //model
  PushNotification? _notificationInfo;

  //register notification
  void registerNotification() async {
    await Firebase.initializeApp();
    // instance for firebase messaging
    _messaging = FirebaseMessaging.instance;

    // three types of states
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permision");
      //main message

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        PushNotification notification = PushNotification(
          title: message.notification!.title,
          body: message.notification!.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );
        setState(() {
          _totalNotificationCounter++;
          _notificationInfo = notification;
        });

        //show the actual notification
        if (notification != null) {
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            leading: CircleAvatar(
              radius: 10,
              child: Text(_totalNotificationCounter.toString()),
              
            ),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.cyan,
            duration: const Duration(seconds: 2),
          );
        }
      });
    } else {
      print("Permissions Declined by user");
    }
  }

  @override
  void initState() {
    // normal notification
    registerNotification();
    _totalNotificationCounter = 0;
// when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification!.title,
        body: message.notification!.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );
      setState(() {
        _totalNotificationCounter++;
        _notificationInfo = notification;
      });
    });

    //when app is in terminated state
    checkInitialMessage();

    //fcmtoken
    FirebaseMessaging.instance.getToken().then((newToken) {
      _fcmToken = newToken;
      Logger().i("Firebase Token $_fcmToken");
    });

    super.initState();
  }

//check the initial message that we receive
  checkInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification!.title,
        body: initialMessage.notification!.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );
      setState(() {
        _totalNotificationCounter++;
        _notificationInfo = notification;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
Logger().e(_fcmToken);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: GlobalVariables.appBarGradient,
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: 42,
                      margin: const EdgeInsets.only(left: 15),
                      alignment: Alignment.topLeft,
                      child: Material(
                        borderRadius: BorderRadius.circular(7),
                        elevation: 1,
                        child: TextFormField(
                          onFieldSubmitted: navigateToSearchScreen,
                          decoration: InputDecoration(
                            prefixIcon: InkWell(
                              onTap: () {},
                              child: const Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                  size: 23,
                                ),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(top: 10),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(7),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(7),
                              ),
                              borderSide:
                                  BorderSide(color: Colors.black38, width: 1),
                            ),
                            hintText: 'Search for products, brands and more',
                            hintStyle: const TextStyle(
                                color: Colors.black38,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    height: 42,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Icon(
                      Icons.mic,
                      color: Colors.black,
                      size: 25,
                    ),
                  )
                ],
              ),
            )),
        body: SingleChildScrollView(
          child: Column(
            children: const [
              AddressBox(),
              SizedBox(height: 10),
              TopCategories(),
              SizedBox(height: 10),
              CarouselImage(),
              SizedBox(height: 10),
              DealOfTheDay(),
            ],
          ),
        ));
  }
}
