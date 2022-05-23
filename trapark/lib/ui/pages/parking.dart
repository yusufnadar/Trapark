import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:otopark/constants/size_config.dart';
import 'package:otopark/constants/theme/theme.dart';
import 'package:http/http.dart' as http;
import 'package:otopark/models/user.dart';
import 'package:otopark/providers/auth_provider.dart';
import 'package:otopark/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Parking extends StatefulWidget {
  const Parking({Key? key}) : super(key: key);

  @override
  State<Parking> createState() => _ParkingState();
}

class _ParkingState extends State<Parking> {

  UserModel? user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context,listen: false).user;
    print(user?.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          'Randevularım',
          style: regularFontStyle(color: blackColor, size: 18),
        ),
        titleSpacing: 0,
        backgroundColor: whiteColor,
        elevation: 0,
        iconTheme: IconThemeData(color: blackColor),
      ),
      body: FutureBuilder<List<DateModel>?>(
          future: randevulariGetir(context),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                padding: EdgeInsets.only(
                  top: screenHeight * 0.03,
                  right: screenWidth * 0.05,
                  left: screenWidth * 0.05,
                ),
                itemCount: snapshot.data!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => buildOneOfParking(index,snapshot.data![index]),
              );
            }
          }),
    );
  }

  Container buildOneOfParking(int index,DateModel randevu) {
    if (DateTime.now().difference(DateTime.parse((randevu.endDate.toString()).replaceAll('Z', ''))).isNegative == false) {
      return Container();
    } else {
      return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenHeight * 0.01,
      ),
      height: screenHeight * 0.2,
      margin: EdgeInsets.only(bottom: screenHeight * 0.03),
      decoration: BoxDecoration(
        color: grayColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildParkingNameAndRate(index,randevu),
        ],
      ),
    );
    }
  }

  buildParkingNameAndRate(int index,DateModel randevu) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${randevu.name}',
          style: mediumFontStyle(color: whiteColor,size: 18),
        ),
        const SizedBox(height: 10),
        Text(
          'Başlangıç: ${(randevu.startDate).toString().substring(0,19)}',
          style: regularFontStyle(color: whiteColor),
        ),
        const SizedBox(height: 10),
        Text(
          'Bitiş: ${(randevu.endDate).toString().substring(0,19)}',
          style: regularFontStyle(color: whiteColor),
        ),
        const SizedBox(height: 10),
        buildTakeDate(randevu),
      ],
    );
  }

  GestureDetector buildTakeDate(DateModel? randevu) {
    print(randevu?.id);
    return GestureDetector(
      onTap: () {
        Get.dialog(
          AlertDialog(
            title: const Text(
              'Randevuyu iptal etmek istediğinize emin misiniz?',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  'Vazgeç',
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () async{
                  var res = await http.delete(Uri.parse('https://yusufnadar.com/api/otopark/delete/${randevu!.id}'));
                  if(res.statusCode == 200){
                    Get.closeAllSnackbars();
                    Get.back();
                    setState(() {});
                    Get.snackbar('Başarılı', 'Silme İşlemi Başarılı',duration: const Duration(seconds: 1),backgroundColor: Colors.green,colorText: Colors.white);
                  }
                },
                child: const Text(
                  'Evet',
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02,
          vertical: screenHeight * 0.015,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.red,
        ),
        child: Text(
          'Randevuyu İptal Et',
          style: mediumFontStyle(
            color: whiteColor,
            size: 13,
          ),
        ),
      ),
    );
  }

  Future<List<DateModel>?> randevulariGetir(context) async {
    var res = await http.post(
      Uri.parse('https://yusufnadar.com/api/otopark/getDates'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId':user?.id})
    );
    if (res.statusCode == 200) {
        print(res.body);
      return List<DateModel>.from(json.decode(res.body).map((x)=>DateModel.fromJson(x)));
    } else {
      print(res.body);
      Get.snackbar('Hata', res.body);
    }
  }
}


List<DateModel> dateModelFromJson(String str) => List<DateModel>.from(json.decode(str).map((x) => DateModel.fromJson(x)));

String dateModelToJson(List<DateModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DateModel {
  DateModel({
    this.id,
    this.startDate,
    this.endDate,
    this.name,
  });

  int? id;
  DateTime? startDate;
  DateTime? endDate;
  String? name;

  factory DateModel.fromJson(Map<String, dynamic> json) => DateModel(
    id: json["id"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "name": name,
  };
}


