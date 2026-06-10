import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:randmapp/data/models/character_model.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/entities/app_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    
    _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        add(AuthUserChanged(user));
      } else {
        add(AuthSignedOut());
      }
    });

    on<AuthSignIn>(_onSignIn);
    on<AuthSignUp>(_onSignUp);
    on<AuthSignOut>(_onSignOut);
    on<AuthUserChanged>(_onUserChanged);
    on<AuthSignedOut>(_onSignedOut);
  }

  Future<void> _onSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signIn(event.email, event.password);

    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signUp(event.email, event.password);

    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    await Hive.box<CharacterModel>('characters').clear();
    await _authRepository.signOut();
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    emit(AuthAuthenticated(event.user));
  }

  void _onSignedOut(AuthSignedOut event, Emitter<AuthState> emit) {
    emit(AuthUnauthenticated());
  }
}