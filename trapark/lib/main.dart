import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otopark/providers/auth_provider.dart';
import 'package:otopark/providers/user_provider.dart';
import 'package:otopark/ui/pages/landing.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(create: (_)=>UserProvider()),
          ChangeNotifierProvider<AuthProvider>(create: (_)=>AuthProvider()),
        ],
        child: GetMaterialApp(
          title: 'Otopark',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const Landing(),
        ),
      ),
    );
  }
}
