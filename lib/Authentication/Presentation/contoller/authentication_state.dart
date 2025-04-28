import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids_learning/core/utils/enums.dart';

class AuthenticationState extends Equatable{
  final String userId;
  final String userName;
  final String email;
  final String profileUrl;
  final SignUpAuthenticationState signUpAuthenticationState;
  final String errorSignUpMessage;
  final String errorSignInMessage;
  final SignInAuthenticationState signInAuthenticationState;
  final LoadUserDataState loadUserDataState;
  final String errorLoadDataMessage;
  final String forgetPasswordMessage;
  final LogoutAuthenticationState logoutAuthenticationState;
  final String logoutMessage;
  final File? profileFile;
  final bool obscurePassword;

  AuthenticationState({
    this.obscurePassword=true,
    this.userId='',
    this.userName='',
    this.email='',
    this.profileUrl='',
    this.signUpAuthenticationState=SignUpAuthenticationState.initial,
    this.errorSignUpMessage='',
    this.signInAuthenticationState=SignInAuthenticationState.initial,
    this.errorSignInMessage='',
    this.loadUserDataState=LoadUserDataState.initial,
    this.errorLoadDataMessage='',
    this.logoutAuthenticationState=LogoutAuthenticationState.initial,
    this.logoutMessage='',
    this.forgetPasswordMessage='',
    this.profileFile =null,
  });

  AuthenticationState copyWith({
    String? userId,
    String? userName,
    String? email,
    String? profileUrl,
    SignUpAuthenticationState? signUpAuthenticationState,
    String? errorSignUpMessage,
    SignInAuthenticationState? signInAuthenticationState,
    String? errorSignInMessage,
    LoadUserDataState ? loadUserDataState,
    String? errorLoadDataMessage,
    LogoutAuthenticationState? logoutAuthenticationState,
    String? logoutMessage,
    String? forgetPasswordMessage,
    File? profileFile,
    bool?  obscurePassword,
    List<IconData>? showPasswordIcon,
  }
      )=>AuthenticationState(
    userId: userId??this.userId,
    userName: userName??this.userName,
    email: email??this.email,
    profileUrl: profileUrl??this.profileUrl,
    signUpAuthenticationState: signUpAuthenticationState??this.signUpAuthenticationState,
    errorSignUpMessage: errorSignUpMessage??this.errorSignUpMessage,
    signInAuthenticationState: signInAuthenticationState??this.signInAuthenticationState,
    errorSignInMessage: errorSignInMessage??this.errorSignInMessage,
    loadUserDataState: loadUserDataState??this.loadUserDataState,
    errorLoadDataMessage: errorLoadDataMessage??this.errorLoadDataMessage,
    logoutAuthenticationState: logoutAuthenticationState??this.logoutAuthenticationState,
    logoutMessage: logoutMessage??this.logoutMessage,
    forgetPasswordMessage: forgetPasswordMessage??this.forgetPasswordMessage,
    profileFile:profileFile??this.profileFile,
    obscurePassword: obscurePassword ?? this.obscurePassword,
  );
  @override

  List<Object?> get props =>[
    userId,
        userName,
        email,
        profileUrl,
        signUpAuthenticationState,
        errorSignUpMessage,
        signInAuthenticationState,
        errorSignInMessage,
        loadUserDataState,
        errorLoadDataMessage,
        logoutAuthenticationState,
        logoutMessage,
        forgetPasswordMessage,
        profileFile,
        obscurePassword,
      ];

}