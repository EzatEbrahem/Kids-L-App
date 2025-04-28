import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kids_learning/Authentication/Domain/entities/user_entities.dart';
import 'package:kids_learning/Authentication/Domain/repository/base_authentication_repository.dart';
import 'package:kids_learning/Authentication/Domain/useCase/email_password_sign_in_use_case.dart';
import 'package:kids_learning/Authentication/Domain/useCase/facebook_sign_in_use_case.dart';
import 'package:kids_learning/Authentication/Domain/useCase/forget_password_use_case.dart';
import 'package:kids_learning/Authentication/Domain/useCase/get_user_data_use_case.dart';
import 'package:kids_learning/Authentication/Domain/useCase/google_sign_in_use_case.dart';
import 'package:kids_learning/Authentication/Domain/useCase/log_out_use_case.dart';
import 'package:kids_learning/Authentication/Domain/useCase/sign_up_use_case.dart';
import 'package:kids_learning/Authentication/Presentation/contoller/authentication_event.dart';
import 'package:kids_learning/Authentication/Presentation/contoller/authentication_state.dart';
import 'package:kids_learning/core/usecase/base_usecase.dart';
import 'package:kids_learning/core/utils/enums.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent,AuthenticationState>{
    final  EmailAndPasswordSignInUseCase emailAndPasswordSignInUseCase;
    final FacebookSignInUseCase facebookSignInUseCase;
    final ForgetPasswordUseCase forgetPasswordUseCase;
    final GetUserDataUseCase getUserDataUseCase;
    final GoogleSignInUseCase googleSignInUseCase;
    final LogOutAuthenticationUseCase logOutAuthenticationUseCase;
    final SignUpUseCase signUpUseCase;

  AuthenticationBloc(this.emailAndPasswordSignInUseCase, this.facebookSignInUseCase,
      this.forgetPasswordUseCase, this.getUserDataUseCase, this.googleSignInUseCase,
      this.logOutAuthenticationUseCase, this.signUpUseCase, )
      :super(AuthenticationState()){

    on<SignUpAuthenticationEvent>((event,emit)async{
      emit(state.copyWith(signUpAuthenticationState: SignUpAuthenticationState.loading));
     final result= await signUpUseCase(new UserData(userId: '',
          name: event.userName,
          email: event.email,
          password: event.password,
          phone: event.phone,
          profile: ''),event.image);
     result.fold(
             (l)=> emit(state.copyWith(
               signUpAuthenticationState: SignUpAuthenticationState.error,
               errorSignUpMessage:l.message
             )),
             (r)=>emit(state.copyWith(
               signUpAuthenticationState: SignUpAuthenticationState.loaded,
             )));
    });
    on<EmailAndPasswordSignInAuthenticationEvent>((event,emit)async{
      emit(state.copyWith(signInAuthenticationState: SignInAuthenticationState.loading));
     final result= await emailAndPasswordSignInUseCase(new SignInParameters(event.email, event.password),NoParameters());
     result.fold(
             (l)=> emit(state.copyWith(
                 signInAuthenticationState: SignInAuthenticationState.error,
               errorSignInMessage:l.message
             )),
             (r)=>emit(state.copyWith(
               signInAuthenticationState: SignInAuthenticationState.loaded,
               userId: r.userId,
               userName: r.name,
               email: r.email,
               profileUrl: r.profile,
             )));
    });
    on<GoogleSignInAuthenticationEvent>((event,emit)async{
      emit(state.copyWith(signInAuthenticationState: SignInAuthenticationState.loading));
     final result= await googleSignInUseCase(NoParameters(),NoParameters());
     result.fold(
             (l)=> emit(state.copyWith(
                 signInAuthenticationState: SignInAuthenticationState.error,
               errorSignInMessage:l.message
             )),
             (r)=>emit(state.copyWith(
               signInAuthenticationState: SignInAuthenticationState.loaded,
               userId: r.userId,
               userName: r.name,
               email: r.email,
               profileUrl: r.profile,
             )));
    });
    on<FacebookSignInAuthenticationEvent>((event,emit)async{
      emit(state.copyWith(signInAuthenticationState: SignInAuthenticationState.loading));
     final result= await facebookSignInUseCase(NoParameters(),NoParameters());
     result.fold(
             (l)=> emit(state.copyWith(
                 signInAuthenticationState: SignInAuthenticationState.error,
               errorSignInMessage:l.message
             )),
             (r)=>emit(state.copyWith(
               signInAuthenticationState: SignInAuthenticationState.loaded,
               userId: r.userId,
               userName: r.name,
               email: r.email,
               profileUrl: r.profile,
             )));
    });
    on<ForgetPasswordAuthenticationEvent>((event,emit)async{
      emit(state.copyWith(
          forgetPasswordMessage:''
      ));
     final result= await forgetPasswordUseCase(event.email,NoParameters());
     result.fold(
             (l)=> emit(state.copyWith(
               forgetPasswordMessage:l.message
             )),
             (r)=>emit(state.copyWith(
               forgetPasswordMessage: r
             )));
    });
    on<LoadUserDataEvent>((event,emit)async{
      emit(state.copyWith(loadUserDataState: LoadUserDataState.loading));
     final result= await getUserDataUseCase(NoParameters(),NoParameters());
     result.fold(
             (l)=> emit(state.copyWith(
                 loadUserDataState: LoadUserDataState.error,
               errorLoadDataMessage: l.message,
             )),
             (r)=>emit(state.copyWith(
                 loadUserDataState: LoadUserDataState.loaded,
               userId: r.userId,
               userName: r.name,
               email: r.email,
               profileUrl:r.profile,
             )));
    });
    on<LogOutAuthenticationEvent>((event,emit)async{
      emit(state.copyWith(logoutAuthenticationState: LogoutAuthenticationState.loading));
     final result= await logOutAuthenticationUseCase(NoParameters(),NoParameters());
     result.fold(
             (l)=> emit(state.copyWith(
               logoutAuthenticationState: LogoutAuthenticationState.error,
               logoutMessage: l.message,
             )),
             (r)=>emit(state.copyWith(
               logoutAuthenticationState: LogoutAuthenticationState.loaded,
               logoutMessage: r,
               loadUserDataState: LoadUserDataState.initial,
               signInAuthenticationState:SignInAuthenticationState.initial ,
               signUpAuthenticationState: SignUpAuthenticationState.initial,
               userId: '',
               userName: '',
               email: '',
               profileUrl:'',
             )));
    });
    on<TakePictureFromCameraEvent>((event,emit)async{
      final ImagePicker _picker = ImagePicker();
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile != null) {
        emit(state.copyWith(
          profileFile: File(pickedFile.path),
        ));
      }else{
        emit(state.copyWith(
          profileFile:null ,
        ));
      }
      });
    on<SelectPictureFromGalleryEvent>((event,emit)async{
      final ImagePicker _picker = ImagePicker();
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        emit(state.copyWith(
          profileFile: File(pickedFile.path),
        ));
      }else{
        emit(state.copyWith(
          profileFile:null ,
        ));
      }
      });
    on<ResetSignUpEvent>((event,emit)async{
      emit(state.copyWith(
        profileFile:null ,
        obscurePassword: true,
        signUpAuthenticationState: SignUpAuthenticationState.initial,
      ));
      });
    on<TogglePasswordVisibilityEvent>((event, emit) {
      emit(state.copyWith(obscurePassword: !state.obscurePassword));
    });

  }

}