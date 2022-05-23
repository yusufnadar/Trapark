// ignore_for_file: unrelated_type_equality_checks
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:otopark/constants/local_storage.dart';
import 'package:otopark/constants/size_config.dart';
import 'package:otopark/models/user.dart';
import 'package:otopark/providers/user_provider.dart';
import 'package:otopark/ui/pages/login.dart';
import 'package:otopark/ui/pages/parking.dart';
import 'package:otopark/ui/widgets/custom/custom_button.dart';
import 'package:otopark/ui/widgets/custom/custom_input.dart';
import 'package:provider/provider.dart';
import '../../constants/theme/theme.dart';
import 'package:http/http.dart' as http;

class OtoparkModel {
  int id;
  String name;
  LocationModel location;
  int? kapasite;
  int? doluluk;
  var time;
  var distance;
  var roadName;

  OtoparkModel({
    required this.name,
    required this.id,
    required this.location,
    this.kapasite,
    this.doluluk,
    this.time,
    this.distance,
    this.roadName,
  });

  factory OtoparkModel.fromJson(Map<String, dynamic> json) => OtoparkModel(
        name: json['name'],
        id: json['id'],
        location: LocationModel.fromJson(json["location"]),
        kapasite: json['kapasite'],
        doluluk: json['doluluk'],
        roadName: json['roadName'] ?? '',
      );
}

class LocationModel {
  double lat;
  double lng;

  LocationModel({required this.lat, required this.lng});

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        lat: json['lat'],
        lng: json['lng'],
      );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final startController = TextEditingController();
  final endController = TextEditingController();
  final startFocusNode = FocusNode();
  final endFocusNode = FocusNode();
  bool startPlaceWriting = false;
  bool endPlaceWriting = false;
  String? startPlace;
  String? endPlace;
  bool? isLoading = false;
  var startList = [];
  var endList = [];
  var liste = <OtoparkModel>[];
  var otogarList = [
    // OtoparkModel(
    //   name: 'Pazarkapı Otogar',
    //   id: 1,
    //   location: LocationModel(lat: 41.007447569526505, lng: 39.71904167998957),
    // ),
    // OtoparkModel(
    //   name: 'Tabakhane Otopark',
    //   id: 2,
    //   location: LocationModel(lat: 41.006181292592544, lng: 39.722633997780356),
    // ),
    // OtoparkModel(
    //   name: 'Tanjant Otopark',
    //   id: 3,
    //   location: LocationModel(lat: 41.005011834429475, lng: 39.71416725776969),
    // ),
    // OtoparkModel(
    //   name: 'Yavuz Selim Kapalı Otoparkı',
    //   id: 4,
    //   location: LocationModel(lat: 41.0055092336037, lng: 39.723175455453436),
    // ),
    // OtoparkModel(
    //   name: 'Çömlekçi Cemiyet Sokak No:11',
    //   id: 5,
    //   location: LocationModel(lat: 41.00442862837544, lng: 39.733631163947486),
    // ),
  ];

  UserModel? user;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false)
        .getUser()
        .then((value) => user = value);
    startFocusNode.addListener(() async {
      if (startFocusNode.hasFocus) {
        setState(() {
          startPlaceWriting = true;
        });
      } else {
        setState(() {
          startPlaceWriting = false;
        });
      }
    });
    endFocusNode.addListener(() async {
      if (endFocusNode.hasFocus) {
        setState(() {
          endPlaceWriting = true;
        });
      } else {
        setState(() {
          endPlaceWriting = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            buildLogout(),
            const Spacer(),
            buildParkingDates(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: Get.height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                buildStartPoint(),
                startPlace != null ? buildStartPointText() : Container(),
                if (startPlace != null)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        startPlace = null;
                        startController.text = '';
                        startList = [];
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: Get.height * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Icon(
                            Icons.close,
                            size: 20,
                          ),
                          Text(
                            'Vazgeç',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Container()
              ],
            ),
            startPlaceWriting == true ? buildListOfStartPlaces() : Container(),
            Column(
              children: [
                buildEndPoint(),
                endPlace != null ? buildEndPointText() : Container(),
                if (endPlace != null)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        endPlace = null;
                        endController.text = '';
                        endList = [];
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: Get.height * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Icon(
                            Icons.close,
                            size: 20,
                          ),
                          Text(
                            'Vazgeç',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Container()
              ],
            ),
            endPlaceWriting == true ? buildListOfEndPlaces() : Container(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildGetParkingButton(),
                Text('Otoparklar', style: regularFontStyle(size: 18)),
                SizedBox(height: screenHeight * 0.01),
                buildListOfParking(),
              ],
            )
          ],
        ),
      ),
    );
  }

  ListView buildListOfEndPlaces() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: endPlace != null ? Get.height * 0.02 : 0),
      itemCount: endList.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          setState(() {
            endPlace = endList[index]['description'];
            endFocusNode.unfocus();
            endController.text = endList[index]['title'];
          });
        },
        child: Container(
          margin: EdgeInsets.only(bottom: Get.height * 0.01),
          child: Card(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.02,
                vertical: Get.height * 0.015,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    endList[index]['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(endList[index]['description']),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildEndPointText() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Get.height * 0.02),
      padding: EdgeInsets.symmetric(
        horizontal: Get.width * 0.02,
        vertical: Get.height * 0.01,
      ),
      alignment: Alignment.center,
      height: screenHeight * 0.075,
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.red,
      ),
      child: Text(
        endPlace!,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  ListView buildListOfStartPlaces() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: startPlace != null ? Get.height * 0.02 : 0),
      itemCount: startList.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          setState(() {
            startPlace = startList[index]['description'];
            startFocusNode.unfocus();
            startController.text = startList[index]['title'];
          });
        },
        child: Container(
          margin: EdgeInsets.only(bottom: Get.height * 0.01),
          child: Card(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.02,
                vertical: Get.height * 0.015,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    startList[index]['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(startList[index]['description']),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildStartPointText() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Get.height * 0.02),
      padding: EdgeInsets.symmetric(
        horizontal: Get.width * 0.02,
        vertical: Get.height * 0.01,
      ),
      alignment: Alignment.center,
      height: screenHeight * 0.075,
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.red,
      ),
      child: Text(
        startPlace!,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  GestureDetector buildLogout() {
    return GestureDetector(
      onTap: () async {
        await GetStorage().remove(userToken);
        Get.offAll(
          () => const Login(),
        );
      },
      child: Container(
        color: whiteColor,
        child: Row(
          children: [
            Transform.rotate(
              angle: pi,
              child: Image.asset(
                'assets/images/right.png',
                width: 24,
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Text(
              'Çıkış Yap',
              style: regularFontStyle(),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildParkingDates() {
    return GestureDetector(
      onTap: () => Get.to(() => const Parking())
          ?.then((value) => otoparklariGetir(newPage: true)),
      child: Container(
        color: whiteColor,
        child: Row(
          children: [
            Text('Randevularım', style: regularFontStyle()),
            SizedBox(width: screenWidth * 0.02),
            Image.asset(
              'assets/images/right.png',
              width: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListOfParking() {
    if (isLoading == true) {
      return Center(
        child: Container(
          margin: EdgeInsets.only(top: Get.height * 0.05),
          child: const CircularProgressIndicator(
            color: Colors.red,
          ),
        ),
      );
    } else {
      if (liste.isNotEmpty) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: screenHeight * 0.03),
          itemCount: liste.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return buildOneOfParking(index);
          },
        );
      } else {
        return Container();
      }
    }
  }

  Container buildOneOfParking(int index) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenHeight * 0.01,
      ),
      height: screenHeight * 0.12,
      margin: EdgeInsets.only(bottom: screenHeight * 0.03),
      decoration: BoxDecoration(
        color: grayColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildParkingNameAndRate(index),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                liste[index].distance.toString(),
                style: regularFontStyle(color: whiteColor, size: 12),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                child: Text(
                  '-',
                  style: regularFontStyle(color: whiteColor),
                ),
              ),
              Text(
                liste[index].time.toString(),
                style: regularFontStyle(color: whiteColor, size: 12),
              ),
              const Spacer(),
              buildTakeDate(liste[index].id),
              buildTakeDirection(index, liste[index].location),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTakeDirection(int index, LocationModel? location2) {
    return GestureDetector(
      onTap: () async {
        var response = await http.get(Uri.parse(
            'https://maps.googleapis.com/maps/api/geocode/json?address=$startPlace&key=AIzaSyBeW4LYpiJruypAbQLAY8YFzavUUyyL8As'));
        var location =
            json.decode(response.body)['results'][0]['geometry']['location'];
        if (await MapLauncher.isMapAvailable(MapType.google) == true) {
          MapLauncher.showDirections(
            mapType: MapType.google,
            destination: Coords(location2!.lat, location2.lng),
            origin: Coords(
              location['lat'],
              location['lng'],
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: screenWidth * 0.02),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02,
          vertical: screenHeight * 0.008,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.blue,
        ),
        child: Text(
          'Yol Tarifi',
          style: mediumFontStyle(
            color: whiteColor,
            size: 12,
          ),
        ),
      ),
    );
  }

  var sonuc;
  var sonuc2;
  var deger;
  var deger2;

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  GestureDetector buildTakeDate(otoID) {
    sonuc = null;
    sonuc2 = null;
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.close,
                    size: 26,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.75,
                  child: ElevatedButton(
                    onPressed: () async {
                      deger = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                            hour: DateTime.now().hour,
                            minute: DateTime.now().minute),
                      );
                      if (deger != null) {
                        var today = DateTime.now();
                        sonuc = today.toString().substring(0, 11) +
                            '${deger.hour >= 10 ? deger.hour : '0${deger.hour}'}:${deger.minute >= 10 ? deger.minute : '0${deger.minute}'}:00';
                        if (sonuc != null) {
                          if (toDouble(deger) < toDouble(TimeOfDay.now())) {
                            Get.snackbar('Uyarı',
                              'Geçmiş saat için bir seçim yapamazsınız!',
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 1),
                              colorText: Colors.white,);
                          } else {
                            Get.snackbar(
                              'Başarılı',
                              'Başlangıç Saati Seçildi',
                              backgroundColor: Colors.yellow,
                              duration: const Duration(seconds: 1),
                            );
                          }
                        }
                      }
                    },
                    child: const Text('Başlangıç Saati Seçiniz'),
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.75,
                  child: ElevatedButton(
                    onPressed: () async {
                      deger2 = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: DateTime.now().hour,
                          minute: DateTime.now().minute,
                        ),
                      );
                      if (deger2 != null) {
                        var today = DateTime.now();
                        sonuc2 = today.toString().substring(0, 11) +
                            '${(deger2.hour as int) >= 10 ? deger2?.hour : '0${deger2?.hour}'}:${(deger2?.minute as int) >= 10 ? deger2?.minute : '0${deger2?.minute}'}:00';
                        if (sonuc2 != null) {
                          if (toDouble(deger2) > toDouble(deger)) {
                            Get.snackbar(
                              'Başarılı',
                              'Bitiş Saati Seçildi',
                              backgroundColor: Colors.yellow,
                              duration: const Duration(seconds: 1),
                            );
                          } else {
                            Get.snackbar(
                              'Uyarı',
                              'Başlangıç saatinden daha ileri bir saat seçiniz!',
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 1),
                              colorText: Colors.white,
                            );
                          }
                        }
                      }
                    },
                    child: const Text('Bitiş Saati Seçiniz'),
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.75,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (sonuc == null || sonuc2 == null) {
                        Get.closeAllSnackbars();
                        Get.snackbar('Uyarı',
                            'Lütfen başlangıç ve bitiş saatini giriniz',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 1));
                      } else {
                        if (DateTime.parse(sonuc)
                                    .isAfter(DateTime.parse(sonuc2)) ==
                                true ||
                            DateTime.parse(sonuc) == DateTime.parse(sonuc2)) {
                          Get.closeAllSnackbars();
                          Get.snackbar('Uyarı',
                              'Bitiş saati başlangıç saatinden erken olmalıdır!',
                              duration: const Duration(seconds: 2),
                              backgroundColor: Colors.red);
                          return;
                        }
                        var res = await http.post(
                          Uri.parse(
                              'https://yusufnadar.com/api/otopark/addDate'),
                          headers: {'Content-Type': 'application/json'},
                          body: json.encode(
                            {
                              'startDate': sonuc,
                              'endDate': sonuc2,
                              'userId': user!.id,
                              'plaka': user!.plate,
                              'otoparkId': otoID
                            },
                          ),
                        );
                        if (res.statusCode == 200) {
                          otoparklariGetir();
                          if (Get.isSnackbarOpen == true) {
                            Get.closeAllSnackbars();
                            Get.back();
                          } else {
                            Get.back();
                          }
                          Get.closeAllSnackbars();
                          Get.snackbar('Başarılı', 'İşlem Başarılı',
                              duration: const Duration(seconds: 1),
                              backgroundColor: Colors.green,
                              colorText: Colors.white);
                        } else {
                          Get.closeAllSnackbars();
                          Get.snackbar('Başarısız', res.body,
                              duration: const Duration(seconds: 1),
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                        }
                      }
                    },
                    child: const Text('Tamamla'),
                  ),
                ),
              ],
            ),
          ),
          isScrollControlled: true,
          backgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02,
          vertical: screenHeight * 0.008,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.red,
        ),
        child: Text(
          'Randevu Al',
          style: mediumFontStyle(
            color: whiteColor,
            size: 12,
          ),
        ),
      ),
    );
  }

  Row buildParkingNameAndRate(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          liste[index].name,
          style: regularFontStyle(color: whiteColor),
        ),
        Text(
          '${liste[index].doluluk} / ${liste[index].kapasite}',
          style: regularFontStyle(color: whiteColor),
        )
      ],
    );
  }

  Container buildGetParkingButton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
      child: CustomButton(
        text: 'Otoparkları Getir',
        icon: 'assets/images/download.png',
        onTap: () async {
          otoparklariGetir();
        },
      ),
    );
  }

  otoparklariGetir({newPage}) async {
    if (startPlace != null && endPlace != null) {
      setState(() {
        isLoading = true;
        liste = <OtoparkModel>[];
      });
      var date = DateTime.now().toString().substring(0, 19);
      var res = await http.post(
        Uri.parse('https://yusufnadar.com/api/otopark/getOtopark'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'date': date}),
      );
      if (res.statusCode != 200) {
        print(res.body);
      } else {

      }
      liste = List<OtoparkModel>.from(
        jsonDecode(res.body).map((x) => OtoparkModel.fromJson(x)),
      );
      for (int i = 0; i < liste.length; i++) {
        var response = await http.get(
          Uri.parse(
            'https://maps.googleapis.com/maps/api/distancematrix/json?origins=$endPlace&key=AIzaSyBeW4LYpiJruypAbQLAY8YFzavUUyyL8As&destinations=${liste[i].roadName}',
          ),
        );
        liste[i].distance = json.decode(response.body)['rows'][0]['elements'][0]
            ['distance']['text'];
        liste[i].time = json.decode(response.body)['rows'][0]['elements'][0]
            ['duration']['text'];
      }
      liste.sort((a, b) => a.distance.compareTo(b.distance));
      setState(() {
        isLoading = false;
      });
    } else {
      if (newPage != true) {
        Get.snackbar(
          'Uyarı',
          'Lütfen Başlangıç Ve Bitiş Konumlarını Seçiniz',
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Widget buildEndPoint() {
    return SizedBox(
      height: screenHeight * 0.075,
      width: screenWidth,
      child: CustomInput(
        controller: endController,
        hintText: 'Bitiş Noktası',
        focusNode: endFocusNode,
        onChanged: (value) async {
          var result = await http.get(Uri.parse(
              'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$value}&key=AIzaSyBeW4LYpiJruypAbQLAY8YFzavUUyyL8As'));
          setState(() {
            setState(() {
              endList = [];
            });
            for (int i = 0;
                i < (json.decode(result.body)['predictions']).length;
                i++) {
              setState(() {
                endList.add({
                  'description': json.decode(result.body)['predictions'][i]
                      ['description'],
                  'title': json.decode(result.body)['predictions'][i]
                      ['structured_formatting']['main_text']
                });
              });
            }
          });
        },
      ),
    );
  }

  Widget buildStartPoint() {
    return Container(
      margin:
          EdgeInsets.only(bottom: startPlace != null ? 0 : Get.height * 0.02),
      height: screenHeight * 0.075,
      width: screenWidth,
      child: CustomInput(
        controller: startController,
        hintText: 'Başlangıç Noktası',
        focusNode: startFocusNode,
        onChanged: (value) async {
          var result = await http.get(Uri.parse(
              'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$value}&key=AIzaSyBeW4LYpiJruypAbQLAY8YFzavUUyyL8As'));
          setState(() {
            setState(() {
              startList = [];
            });
            for (int i = 0;
                i < (json.decode(result.body)['predictions']).length;
                i++) {
              setState(() {
                startList.add({
                  'description': json.decode(result.body)['predictions'][i]
                      ['description'],
                  'title': json.decode(result.body)['predictions'][i]
                      ['structured_formatting']['main_text']
                });
              });
            }
          });
        },
      ),
    );
  }
}
