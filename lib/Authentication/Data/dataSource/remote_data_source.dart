import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kids_learning/Authentication/Data/models/user_model.dart';
import 'package:kids_learning/Authentication/Domain/useCase/facebook_sign_in_use_case.dart';
import 'package:kids_learning/core/error/error_message_model.dart';
import 'package:kids_learning/core/error/exceptions.dart';
import 'package:kids_learning/core/error/failure.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Domain/entities/user_entities.dart';
import '../../Domain/repository/base_authentication_repository.dart';

abstract class BaseAuthenticationRemoteDataSource{
  Future<void> signUpAuthentication(UserData user,File? image);
  Future<UserDataModel> emailAndPasswordSignInAuthentication(SignInParameters parameters);
  Future<UserDataModel> googleSignInAuthentication();
  Future<UserDataModel> facebookSignInAuthentication();
  Future<String> forgetPasswordAuthentication(String email);
  Future<void> storeUserData(UserData user,File? image);
  Future<UserDataModel> getUserData();
  Future<String> logOutAuthentication();
}
class AuthenticationRemoteDataSource extends BaseAuthenticationRemoteDataSource{
  @override
  Future<UserDataModel> emailAndPasswordSignInAuthentication(SignInParameters parameters)async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signOut();
      }
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: parameters.email, password: parameters.password);
      if (credential.user!.emailVerified==false) {
        throw ServerException(errorMessageModel: ErrorMessageModel(statusCode: '',
            statusMessage:'Email has not been activated. Please check your email'));
      }
      return await getUserData();

    }on FirebaseAuthException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel(
          statusCode: e.code,
          statusMessage:"Sign in failed",
        ),
      );
    }
  }

  @override
  Future<UserDataModel> facebookSignInAuthentication()async {
    try{
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signOut();
      }
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

       if (result.status == LoginStatus.success) {

         final accessToken = result.accessToken;
        final OAuthCredential credential = FacebookAuthProvider.credential(accessToken!.token);
        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final user = userCredential.user;
         final userData = await FacebookAuth.instance.getUserData(
           fields: "name,email,picture.width(200)",
         );
         final String name = userData['name'] ?? '';
         final String email = userData['email'] ?? '';
         final String imageUrl = userData['picture']['data']['url'] ?? '';
        if (user != null) {
          UserDataModel userDataModel=new UserDataModel(
            password: '',
              userId: user.uid,
              name: name??'',
              email: email!,
              phone: '',
              profile: imageUrl!);

          final userDoc = FirebaseFirestore.instance.collection('users').doc(userDataModel.userId);
          final doc = await userDoc.get();
          if (!doc.exists) {
            await userDoc.set({
              'userId': userDataModel.userId,
              'name': userDataModel.name ?? '',
              'email': userDataModel.email ?? '',
              'profile': userDataModel.profile ?? '',
              'phone': userDataModel.phone ?? '',
              'password':''
            });
          }
           return userDataModel;
        }else{
          throw ServerException(
            errorMessageModel: ErrorMessageModel(
              statusCode: '',
              statusMessage: 'Facebook login failed',
            ),
          );

        }
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
            statusCode: '',
            statusMessage: 'Facebook login failed',
          ),
        );
      }
    }on FirebaseAuthException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel(
          statusCode: e.code,
          statusMessage: 'Facebook login failed',
        ),
      );
    }
  }

  @override
  Future<String> forgetPasswordAuthentication(String email) async{
    try {
      if (email.isEmpty || !email.contains('@gmail.com') ){
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
            statusCode: '',
            statusMessage: 'Please enter correct email',
          ),
        );
      }
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return "A password reset link has been sent to your email";
    } on FirebaseAuthException catch (e) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
            statusCode: e.code,
            statusMessage: 'Tray again later',
          ),
        );
      }
  }

  @override
  Future<UserDataModel> googleSignInAuthentication() async {
    try{
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signOut();
      }
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      if (googleAuth == null) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
            statusCode: '',
            statusMessage: 'Google login failed',
          ),
        );
      }
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final  user = userCredential.user;
      if (user != null) {
        UserDataModel userDataModel = new UserDataModel(
            password: '',
            userId: user.uid,
            name: user.displayName ?? '',
            email: googleUser?.email??'',
            phone: user.phoneNumber ?? '',
            profile: googleUser?.photoUrl ?? '');
        final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
        final doc = await userDoc.get();
        if (!doc.exists) {
          await userDoc.set({
            'userId': user.uid,
            'name': user.displayName ?? '',
            'email': googleUser?.email ?? '',
            'profile': googleUser?.photoUrl ?? '',
            'phone': user.phoneNumber ?? '',
            'password':''
          });
        }
        return userDataModel;
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
              statusCode: '',
              statusMessage: 'Google login failed',
            ),
          );
        }
    }on FirebaseAuthException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel(
          statusCode: e.code,
          statusMessage: 'Google login failed',
        ),
      );
    }
  }

  @override
  Future<void> signUpAuthentication(UserData user,File? image) async {
    try{
    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: user.email, password: user.password,);
    if (userCredential.user != null) {
      await userCredential.user?.sendEmailVerification();
      final userData =UserDataModel(
          userId: userCredential.user!.uid, name: user.name,
          email: user.email, password: user.password,
          phone: user.phone, profile: user.profile) ;
      await storeUserData(userData, image);
    }
    }on FirebaseAuthException catch (e) {
      if(e.code=='email-already-in-use'){
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
            statusCode: e.code,
            statusMessage: 'This email is already in use. Try logging in instead',
          ),
        );
      }else if (e.code == 'invalid-email') {
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
            statusCode: e.code,
            statusMessage: 'This email is invalid',
          ),
        );
      }else{
        throw ServerException(
        errorMessageModel: ErrorMessageModel(
          statusCode: e.code,
          statusMessage:  "Sign up failed",
        ),
        );
      }

    }
  }

  @override
  Future<UserDataModel> getUserData()async {
    try {
      final userId=await FirebaseAuth.instance.currentUser!.uid;
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel(
            statusCode: '',
            statusMessage: "data not found,Tray again to login",
          ),
        );
      }
      final userData =UserDataModel.fromJson(userDoc.data()!);
     return userData;

    }on FirebaseException catch (error) {
      throw ServerException(errorMessageModel: ErrorMessageModel(statusCode: error.code, statusMessage:'load data failed,Tray again to login'));

    }
  }

  @override
  Future<void> storeUserData(UserData user,File? image) async {
    try {
      final File? result;
      if (image == null) {
        final byteData = await rootBundle.load('assets/person.png');
        final tempDir = await getTemporaryDirectory();
        result = File('${tempDir.path}/person.png');
        await result.writeAsBytes(byteData.buffer.asUint8List());
      } else {
        result = image;
      }
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storage = Supabase.instance.client.storage;
      final response = await storage.from('profile').upload('users/${user.userId}/$fileName.png', result,
        fileOptions: FileOptions(cacheControl: '3600', upsert: true),
      );
      if (response.isNotEmpty) {
        final publicUrl = storage.from('profile').getPublicUrl('users/${user.userId}/$fileName.png');
        final data = UserDataModel(
          userId: user.userId,
          name: user.name,
          email: user.email,
          phone: user.phone,
          profile: publicUrl,
          password: user.password,
        );
        await FirebaseFirestore.instance.collection('users').doc(user.userId).set(data.toMap());

      } else {
        throw ServerException(errorMessageModel: ErrorMessageModel(statusCode:'', statusMessage:'Sign up failed'));

      }
    }on FirebaseException catch (error) {
      throw ServerException(errorMessageModel: ErrorMessageModel(statusCode: error.code, statusMessage: 'Sign up failed'));

    }
  }

  @override
  Future<String> logOutAuthentication() async {
    try {
      await FirebaseAuth.instance.signOut();
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
    }
      await FacebookAuth.instance.logOut();
    return 'Log out successfully';
  }on FirebaseAuthException catch(e){
      throw ServerException(errorMessageModel: ErrorMessageModel(statusCode: e.code, statusMessage: 'Log out failed'));
    }
  }

}