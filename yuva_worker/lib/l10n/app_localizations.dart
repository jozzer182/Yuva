import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// The application name
  ///
  /// In es, this message translates to:
  /// **'yuva'**
  String get appName;

  /// Greeting message
  ///
  /// In es, this message translates to:
  /// **'Hola, {name}'**
  String hello(String name);

  /// Get started button
  ///
  /// In es, this message translates to:
  /// **'Comenzar'**
  String get getStarted;

  /// Next button
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get next;

  /// First onboarding screen title for workers
  ///
  /// In es, this message translates to:
  /// **'Encuentra trabajos de aseo cerca de ti'**
  String get onboardingWorkerTitle1;

  /// Second onboarding screen title for workers
  ///
  /// In es, this message translates to:
  /// **'Elige los trabajos que se ajustan a tu tarifa'**
  String get onboardingWorkerTitle2;

  /// Third onboarding screen title for workers
  ///
  /// In es, this message translates to:
  /// **'Construye tu reputación con buenos resultados'**
  String get onboardingWorkerTitle3;

  /// First onboarding screen description for workers
  ///
  /// In es, this message translates to:
  /// **'Conecta con clientes cerca de tu zona de trabajo'**
  String get onboardingWorkerDesc1;

  /// Second onboarding screen description for workers
  ///
  /// In es, this message translates to:
  /// **'Propón tus tarifas y condiciones, tú decides'**
  String get onboardingWorkerDesc2;

  /// Third onboarding screen description for workers
  ///
  /// In es, this message translates to:
  /// **'Cada trabajo completado mejora tu perfil profesional'**
  String get onboardingWorkerDesc3;

  /// Continue with email button
  ///
  /// In es, this message translates to:
  /// **'Continuar con correo'**
  String get continueWithEmail;

  /// Login button
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get login;

  /// Sign up button
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get signup;

  /// Email field label
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get email;

  /// Password field label
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// Name field label
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get name;

  /// Last name label
  ///
  /// In es, this message translates to:
  /// **'Apellido'**
  String get lastName;

  /// Already have account text
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta?'**
  String get alreadyHaveAccount;

  /// Don't have account text
  ///
  /// In es, this message translates to:
  /// **'¿No tienes cuenta?'**
  String get dontHaveAccount;

  /// Home navigation label
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get home;

  /// Jobs navigation label
  ///
  /// In es, this message translates to:
  /// **'Trabajos'**
  String get jobs;

  /// Profile navigation label
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// Language label
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// Spanish language name
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get spanish;

  /// English language name
  ///
  /// In es, this message translates to:
  /// **'English'**
  String get english;

  /// Skip onboarding
  ///
  /// In es, this message translates to:
  /// **'Saltar'**
  String get skip;

  /// Logout button
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get logout;

  /// Recommended jobs section title
  ///
  /// In es, this message translates to:
  /// **'Trabajos recomendados para ti'**
  String get recommendedJobs;

  /// Invitations section title
  ///
  /// In es, this message translates to:
  /// **'Invitaciones'**
  String get invitations;

  /// Invitation chip label
  ///
  /// In es, this message translates to:
  /// **'Invitación'**
  String get invitation;

  /// New jobs tab
  ///
  /// In es, this message translates to:
  /// **'Nuevos'**
  String get newJobs;

  /// My proposals tab
  ///
  /// In es, this message translates to:
  /// **'Mis propuestas'**
  String get myProposals;

  /// Contracts tab
  ///
  /// In es, this message translates to:
  /// **'Contratos'**
  String get contracts;

  /// Empty jobs message
  ///
  /// In es, this message translates to:
  /// **'No hay trabajos disponibles'**
  String get noJobsAvailable;

  /// Empty jobs description
  ///
  /// In es, this message translates to:
  /// **'Cuando haya trabajos que coincidan con tu perfil, los verás aquí.'**
  String get noJobsDescription;

  /// Job detail screen title
  ///
  /// In es, this message translates to:
  /// **'Detalle del trabajo'**
  String get jobDetailTitle;

  /// Property details section
  ///
  /// In es, this message translates to:
  /// **'Detalles de la propiedad'**
  String get propertyDetails;

  /// Budget details section
  ///
  /// In es, this message translates to:
  /// **'Detalles del presupuesto'**
  String get budgetDetails;

  /// Prepare proposal button
  ///
  /// In es, this message translates to:
  /// **'Preparar propuesta'**
  String get prepareProposal;

  /// Proposal feature coming soon message
  ///
  /// In es, this message translates to:
  /// **'La funcionalidad de propuestas se implementará en una fase posterior'**
  String get proposalFeatureComingSoon;

  /// Edit profile button
  ///
  /// In es, this message translates to:
  /// **'Editar perfil'**
  String get editProfile;

  /// Base hourly rate label
  ///
  /// In es, this message translates to:
  /// **'Tarifa base por hora'**
  String get baseHourlyRate;

  /// Base area label
  ///
  /// In es, this message translates to:
  /// **'Zona base'**
  String get baseArea;

  /// Offered services label
  ///
  /// In es, this message translates to:
  /// **'Servicios ofrecidos'**
  String get offeredServices;

  /// Rating display
  ///
  /// In es, this message translates to:
  /// **'{rating} ★ ({count} reseñas)'**
  String rating(String rating, int count);

  /// Save changes button
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get saveChanges;

  /// Cancel button
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// Profile updated success message
  ///
  /// In es, this message translates to:
  /// **'Perfil actualizado exitosamente'**
  String get profileUpdated;

  /// Back button
  ///
  /// In es, this message translates to:
  /// **'Atrás'**
  String get back;

  /// Price per hour
  ///
  /// In es, this message translates to:
  /// **'{price}/hora'**
  String perHour(String price);

  /// Fixed budget label
  ///
  /// In es, this message translates to:
  /// **'Presupuesto fijo: {price}'**
  String fixedBudget(String price);

  /// Hourly range
  ///
  /// In es, this message translates to:
  /// **'{from} - {to} / hora'**
  String hourlyRange(String from, String to);

  /// Standard cleaning service
  ///
  /// In es, this message translates to:
  /// **'Limpieza completa'**
  String get serviceStandard;

  /// Deep cleaning service
  ///
  /// In es, this message translates to:
  /// **'Limpieza profunda'**
  String get serviceDeepClean;

  /// Move-out cleaning service
  ///
  /// In es, this message translates to:
  /// **'Limpieza de mudanza'**
  String get serviceMoveOut;

  /// Office cleaning service
  ///
  /// In es, this message translates to:
  /// **'Oficina/Local'**
  String get serviceOffice;

  /// One-time frequency
  ///
  /// In es, this message translates to:
  /// **'Una sola vez'**
  String get frequencyOnce;

  /// Weekly frequency
  ///
  /// In es, this message translates to:
  /// **'Semanal'**
  String get frequencyWeekly;

  /// Biweekly frequency
  ///
  /// In es, this message translates to:
  /// **'Quincenal'**
  String get frequencyBiweekly;

  /// Monthly frequency
  ///
  /// In es, this message translates to:
  /// **'Mensual'**
  String get frequencyMonthly;

  /// Apartment property type
  ///
  /// In es, this message translates to:
  /// **'Apartamento'**
  String get propertyApartment;

  /// House property type
  ///
  /// In es, this message translates to:
  /// **'Casa'**
  String get propertyHouse;

  /// Small office property type
  ///
  /// In es, this message translates to:
  /// **'Oficina pequeña'**
  String get propertySmallOffice;

  /// Small size
  ///
  /// In es, this message translates to:
  /// **'Pequeño'**
  String get sizeSmall;

  /// Medium size
  ///
  /// In es, this message translates to:
  /// **'Mediano'**
  String get sizeMedium;

  /// Large size
  ///
  /// In es, this message translates to:
  /// **'Grande'**
  String get sizeLarge;

  /// Bedrooms label
  ///
  /// In es, this message translates to:
  /// **'Habitaciones'**
  String get bedrooms;

  /// Bathrooms label
  ///
  /// In es, this message translates to:
  /// **'Baños'**
  String get bathrooms;

  /// Rooms count display
  ///
  /// In es, this message translates to:
  /// **'{bedrooms} hab / {bathrooms} baños'**
  String roomsCount(int bedrooms, int bathrooms);

  /// Preferred date label
  ///
  /// In es, this message translates to:
  /// **'Fecha preferida'**
  String get preferredDate;

  /// Not specified placeholder
  ///
  /// In es, this message translates to:
  /// **'No especificado'**
  String get notSpecified;

  /// Create my profile button
  ///
  /// In es, this message translates to:
  /// **'Crear mi perfil'**
  String get createMyProfile;

  /// Deep clean apartment job title
  ///
  /// In es, this message translates to:
  /// **'Limpieza profunda de apartamento 2 habitaciones'**
  String get jobTitleDeepCleanApt;

  /// Deep clean apartment job description
  ///
  /// In es, this message translates to:
  /// **'Busco dejar cocina y baños impecables antes de visita familiar.'**
  String get jobDescDeepCleanApt;

  /// Weekly house job title
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento semanal casa en Suba'**
  String get jobTitleWeeklyHouse;

  /// Weekly house job description
  ///
  /// In es, this message translates to:
  /// **'Limpieza general cada semana, prioridad habitaciones y patio.'**
  String get jobDescWeeklyHouse;

  /// Office reset job title
  ///
  /// In es, this message translates to:
  /// **'Reset mensual de oficina pequeña'**
  String get jobTitleOfficeReset;

  /// Office reset job description
  ///
  /// In es, this message translates to:
  /// **'Organizar puestos, limpiar vidrios y dejar sala de juntas lista.'**
  String get jobDescOfficeReset;

  /// Post-move condo job title
  ///
  /// In es, this message translates to:
  /// **'Limpieza post mudanza apartamento amoblado'**
  String get jobTitlePostMoveCondo;

  /// Post-move condo job description
  ///
  /// In es, this message translates to:
  /// **'Necesito una limpieza profunda después de mudanza, incluye ventanas.'**
  String get jobDescPostMoveCondo;

  /// Biweekly studio job title
  ///
  /// In es, this message translates to:
  /// **'Limpieza quincenal de estudio'**
  String get jobTitleBiweeklyStudio;

  /// Biweekly studio job description
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento básico cada dos semanas para estudio de 1 habitación.'**
  String get jobDescBiweeklyStudio;

  /// Area label
  ///
  /// In es, this message translates to:
  /// **'Zona'**
  String get area;

  /// Frequency label
  ///
  /// In es, this message translates to:
  /// **'Frecuencia'**
  String get frequency;

  /// Description label
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get description;

  /// Messages label
  ///
  /// In es, this message translates to:
  /// **'Mensajes'**
  String get messages;

  /// No messages yet message
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes mensajes'**
  String get noMessagesYet;

  /// No messages description
  ///
  /// In es, this message translates to:
  /// **'Cuando recibas mensajes de clientes, aparecerán aquí.'**
  String get noMessagesDescription;

  /// Active job label
  ///
  /// In es, this message translates to:
  /// **'Trabajo activo'**
  String get activeJob;

  /// No messages in conversation
  ///
  /// In es, this message translates to:
  /// **'No hay mensajes en esta conversación'**
  String get noMessagesInConversation;

  /// Type message placeholder
  ///
  /// In es, this message translates to:
  /// **'Escribe un mensaje...'**
  String get typeMessage;

  /// Notifications label
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notifications;

  /// Mark all as read button
  ///
  /// In es, this message translates to:
  /// **'Marcar todo como leído'**
  String get markAllAsRead;

  /// No notifications yet message
  ///
  /// In es, this message translates to:
  /// **'No tienes notificaciones'**
  String get noNotificationsYet;

  /// No notifications description
  ///
  /// In es, this message translates to:
  /// **'Las notificaciones sobre tus propuestas y trabajos aparecerán aquí.'**
  String get noNotificationsDescription;

  /// Unread messages label
  ///
  /// In es, this message translates to:
  /// **'Mensajes sin leer'**
  String get unreadMessages;

  /// New notifications label
  ///
  /// In es, this message translates to:
  /// **'Notificaciones nuevas'**
  String get newNotifications;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
