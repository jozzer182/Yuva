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

  /// First onboarding screen title
  ///
  /// In es, this message translates to:
  /// **'Relájate, tu hogar queda brillante'**
  String get onboardingTitle1;

  /// Second onboarding screen title
  ///
  /// In es, this message translates to:
  /// **'Reserva en minutos'**
  String get onboardingTitle2;

  /// Third onboarding screen title
  ///
  /// In es, this message translates to:
  /// **'Encuentra personas de confianza para aseo en casa'**
  String get onboardingTitle3;

  /// First onboarding screen description
  ///
  /// In es, this message translates to:
  /// **'Disfruta de un hogar limpio sin preocupaciones'**
  String get onboardingDesc1;

  /// Second onboarding screen description
  ///
  /// In es, this message translates to:
  /// **'Proceso simple y rápido para agendar tu servicio'**
  String get onboardingDesc2;

  /// Third onboarding screen description
  ///
  /// In es, this message translates to:
  /// **'Conectamos con profesionales verificados cerca de ti'**
  String get onboardingDesc3;

  /// Continue with email button
  ///
  /// In es, this message translates to:
  /// **'Continuar con correo'**
  String get continueWithEmail;

  /// Continue as guest button
  ///
  /// In es, this message translates to:
  /// **'Continuar como invitado'**
  String get continueAsGuest;

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

  /// Search navigation label
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get search;

  /// My bookings navigation label
  ///
  /// In es, this message translates to:
  /// **'Mis reservas'**
  String get myBookings;

  /// Profile navigation label
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// Search field placeholder
  ///
  /// In es, this message translates to:
  /// **'Buscar servicios de limpieza...'**
  String get searchPlaceholder;

  /// Search filters section title
  ///
  /// In es, this message translates to:
  /// **'Filtros de búsqueda'**
  String get searchFilters;

  /// Price range filter
  ///
  /// In es, this message translates to:
  /// **'Rango de precio'**
  String get priceRange;

  /// Rating display
  ///
  /// In es, this message translates to:
  /// **'{rating} ({count} reseñas)'**
  String rating(String rating, int count);

  /// Availability filter
  ///
  /// In es, this message translates to:
  /// **'Disponibilidad'**
  String get availability;

  /// Search results placeholder
  ///
  /// In es, this message translates to:
  /// **'Resultados de búsqueda aparecerán aquí'**
  String get searchResults;

  /// Categories section title
  ///
  /// In es, this message translates to:
  /// **'Categorías'**
  String get categories;

  /// Featured cleaners section title
  ///
  /// In es, this message translates to:
  /// **'Destacados'**
  String get featuredCleaners;

  /// Empty bookings message
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes reservas'**
  String get noBookingsYet;

  /// Empty bookings description
  ///
  /// In es, this message translates to:
  /// **'Cuando reserves un servicio, lo verás aquí con el estado y los detalles.'**
  String get noBookingsDescription;

  /// Explore options button
  ///
  /// In es, this message translates to:
  /// **'Explorar opciones'**
  String get exploreOptions;

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

  /// Logout button
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get logout;

  /// One-time cleaning category
  ///
  /// In es, this message translates to:
  /// **'Aseo puntual'**
  String get categoryOnetime;

  /// Weekly cleaning category
  ///
  /// In es, this message translates to:
  /// **'Aseo semanal'**
  String get categoryWeekly;

  /// Deep cleaning category
  ///
  /// In es, this message translates to:
  /// **'Limpieza profunda'**
  String get categoryDeep;

  /// Moving cleaning category
  ///
  /// In es, this message translates to:
  /// **'Mudanza'**
  String get categoryMoving;

  /// Price per hour
  ///
  /// In es, this message translates to:
  /// **'{price}/hora'**
  String perHour(String price);

  /// Years of experience
  ///
  /// In es, this message translates to:
  /// **'{years} años de experiencia'**
  String yearsExperience(int years);

  /// No description provided for @newBooking.
  ///
  /// In es, this message translates to:
  /// **'Nueva reserva'**
  String get newBooking;

  /// No description provided for @bookingSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Visualiza y sigue el estado de tus servicios agendados.'**
  String get bookingSubtitle;

  /// No description provided for @stepChooseService.
  ///
  /// In es, this message translates to:
  /// **'Elige el servicio'**
  String get stepChooseService;

  /// No description provided for @stepPropertyDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles de la propiedad'**
  String get stepPropertyDetails;

  /// No description provided for @stepFrequencyDate.
  ///
  /// In es, this message translates to:
  /// **'Frecuencia y fecha'**
  String get stepFrequencyDate;

  /// No description provided for @stepAddressNotes.
  ///
  /// In es, this message translates to:
  /// **'Dirección y notas'**
  String get stepAddressNotes;

  /// No description provided for @stepPriceEstimate.
  ///
  /// In es, this message translates to:
  /// **'Precio estimado'**
  String get stepPriceEstimate;

  /// No description provided for @stepSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get stepSummary;

  /// No description provided for @progressLabel.
  ///
  /// In es, this message translates to:
  /// **'Paso {step}'**
  String progressLabel(String step);

  /// No description provided for @chooseServiceHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el tipo de limpieza que necesitas.'**
  String get chooseServiceHint;

  /// No description provided for @propertyTypeTitle.
  ///
  /// In es, this message translates to:
  /// **'Tipo de propiedad'**
  String get propertyTypeTitle;

  /// No description provided for @sizeCategoryTitle.
  ///
  /// In es, this message translates to:
  /// **'Tamaño'**
  String get sizeCategoryTitle;

  /// No description provided for @bedrooms.
  ///
  /// In es, this message translates to:
  /// **'Habitaciones'**
  String get bedrooms;

  /// No description provided for @bathrooms.
  ///
  /// In es, this message translates to:
  /// **'Baños'**
  String get bathrooms;

  /// No description provided for @frequencyTitle.
  ///
  /// In es, this message translates to:
  /// **'Frecuencia'**
  String get frequencyTitle;

  /// No description provided for @dateAndTime.
  ///
  /// In es, this message translates to:
  /// **'Fecha y hora'**
  String get dateAndTime;

  /// No description provided for @durationHours.
  ///
  /// In es, this message translates to:
  /// **'Duración (horas)'**
  String get durationHours;

  /// No description provided for @addressLabel.
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get addressLabel;

  /// No description provided for @addressPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Ej: Calle 34 #12-45, Apto 402'**
  String get addressPlaceholder;

  /// No description provided for @notesLabel.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get notesLabel;

  /// No description provided for @notesPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Instrucciones adicionales (portería, mascotas, acceso...)'**
  String get notesPlaceholder;

  /// No description provided for @estimatedPriceLabel.
  ///
  /// In es, this message translates to:
  /// **'Precio estimado'**
  String get estimatedPriceLabel;

  /// No description provided for @pricePending.
  ///
  /// In es, this message translates to:
  /// **'Calculando...'**
  String get pricePending;

  /// No description provided for @priceDisclaimer.
  ///
  /// In es, this message translates to:
  /// **'El precio final puede cambiar cuando un profesional acepte tu solicitud.'**
  String get priceDisclaimer;

  /// No description provided for @whatAffectsPrice.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo calculamos el precio?'**
  String get whatAffectsPrice;

  /// No description provided for @priceFactors.
  ///
  /// In es, this message translates to:
  /// **'Consideramos el tipo de servicio, tamaño del espacio, frecuencia y duración estimada.'**
  String get priceFactors;

  /// No description provided for @summaryTitle.
  ///
  /// In es, this message translates to:
  /// **'Resumen de tu reserva'**
  String get summaryTitle;

  /// No description provided for @back.
  ///
  /// In es, this message translates to:
  /// **'Atrás'**
  String get back;

  /// No description provided for @confirmBooking.
  ///
  /// In es, this message translates to:
  /// **'Confirmar reserva'**
  String get confirmBooking;

  /// No description provided for @selectServiceFirst.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un tipo de servicio para continuar.'**
  String get selectServiceFirst;

  /// No description provided for @serviceStandard.
  ///
  /// In es, this message translates to:
  /// **'Limpieza completa'**
  String get serviceStandard;

  /// No description provided for @serviceStandardDesc.
  ///
  /// In es, this message translates to:
  /// **'Rutina general para dejar cada espacio fresco.'**
  String get serviceStandardDesc;

  /// No description provided for @serviceDeepClean.
  ///
  /// In es, this message translates to:
  /// **'Limpieza profunda'**
  String get serviceDeepClean;

  /// No description provided for @serviceDeepCleanDesc.
  ///
  /// In es, this message translates to:
  /// **'Atención detallada en cocina, baños y zonas de alto uso.'**
  String get serviceDeepCleanDesc;

  /// No description provided for @serviceMoveOut.
  ///
  /// In es, this message translates to:
  /// **'Limpieza de mudanza'**
  String get serviceMoveOut;

  /// No description provided for @serviceMoveOutDesc.
  ///
  /// In es, this message translates to:
  /// **'Deja todo listo al entregar o recibir un espacio.'**
  String get serviceMoveOutDesc;

  /// No description provided for @serviceOffice.
  ///
  /// In es, this message translates to:
  /// **'Oficina/Local'**
  String get serviceOffice;

  /// No description provided for @serviceOfficeDesc.
  ///
  /// In es, this message translates to:
  /// **'Limpieza ligera para oficinas o locales pequeños.'**
  String get serviceOfficeDesc;

  /// No description provided for @propertyApartment.
  ///
  /// In es, this message translates to:
  /// **'Apartamento'**
  String get propertyApartment;

  /// No description provided for @propertyHouse.
  ///
  /// In es, this message translates to:
  /// **'Casa'**
  String get propertyHouse;

  /// No description provided for @propertySmallOffice.
  ///
  /// In es, this message translates to:
  /// **'Oficina pequeña'**
  String get propertySmallOffice;

  /// No description provided for @sizeSmall.
  ///
  /// In es, this message translates to:
  /// **'Pequeño'**
  String get sizeSmall;

  /// No description provided for @sizeMedium.
  ///
  /// In es, this message translates to:
  /// **'Mediano'**
  String get sizeMedium;

  /// No description provided for @sizeLarge.
  ///
  /// In es, this message translates to:
  /// **'Grande'**
  String get sizeLarge;

  /// No description provided for @frequencyOnce.
  ///
  /// In es, this message translates to:
  /// **'Una sola vez'**
  String get frequencyOnce;

  /// No description provided for @frequencyWeekly.
  ///
  /// In es, this message translates to:
  /// **'Semanal'**
  String get frequencyWeekly;

  /// No description provided for @frequencyBiweekly.
  ///
  /// In es, this message translates to:
  /// **'Quincenal'**
  String get frequencyBiweekly;

  /// No description provided for @frequencyMonthly.
  ///
  /// In es, this message translates to:
  /// **'Mensual'**
  String get frequencyMonthly;

  /// No description provided for @dateLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get dateLabel;

  /// No description provided for @frequencyLabel.
  ///
  /// In es, this message translates to:
  /// **'Frecuencia'**
  String get frequencyLabel;

  /// No description provided for @durationLabel.
  ///
  /// In es, this message translates to:
  /// **'Duración'**
  String get durationLabel;

  /// No description provided for @roomsLabel.
  ///
  /// In es, this message translates to:
  /// **'Espacios'**
  String get roomsLabel;

  /// No description provided for @roomsCount.
  ///
  /// In es, this message translates to:
  /// **'{bedrooms} hab / {bathrooms} baños'**
  String roomsCount(int bedrooms, int bathrooms);

  /// No description provided for @bookingSuccessTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Solicitud enviada!'**
  String get bookingSuccessTitle;

  /// No description provided for @bookingSuccessSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Recibirás notificaciones cuando {service} sea aceptado.'**
  String bookingSuccessSubtitle(String service);

  /// No description provided for @viewMyBookings.
  ///
  /// In es, this message translates to:
  /// **'Ver mis reservas'**
  String get viewMyBookings;

  /// No description provided for @bookingDetailTitle.
  ///
  /// In es, this message translates to:
  /// **'Detalle de la reserva'**
  String get bookingDetailTitle;

  /// No description provided for @noNotesPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Sin notas adicionales'**
  String get noNotesPlaceholder;

  /// No description provided for @assignedCleanerPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Profesional asignado'**
  String get assignedCleanerPlaceholder;

  /// No description provided for @assignedCleanerHint.
  ///
  /// In es, this message translates to:
  /// **'Aquí verás quién tome tu servicio y su perfil cuando esté disponible.'**
  String get assignedCleanerHint;

  /// No description provided for @upcomingBookings.
  ///
  /// In es, this message translates to:
  /// **'Próximas'**
  String get upcomingBookings;

  /// No description provided for @pastBookings.
  ///
  /// In es, this message translates to:
  /// **'Pasadas'**
  String get pastBookings;

  /// No description provided for @serviceTypeLabel.
  ///
  /// In es, this message translates to:
  /// **'Tipo de servicio'**
  String get serviceTypeLabel;

  /// No description provided for @statusPending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get statusPending;

  /// No description provided for @statusInProgress.
  ///
  /// In es, this message translates to:
  /// **'En progreso'**
  String get statusInProgress;

  /// No description provided for @statusCompleted.
  ///
  /// In es, this message translates to:
  /// **'Completado'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In es, this message translates to:
  /// **'Cancelado'**
  String get statusCancelled;

  /// No description provided for @editProfile.
  ///
  /// In es, this message translates to:
  /// **'Editar perfil'**
  String get editProfile;

  /// No description provided for @editProfileTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar información'**
  String get editProfileTitle;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get settings;

  /// Notifications label
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notifications;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Recibe alertas de tus servicios'**
  String get notificationsSubtitle;

  /// No description provided for @marketingOptIn.
  ///
  /// In es, this message translates to:
  /// **'Ofertas y promociones'**
  String get marketingOptIn;

  /// No description provided for @marketingSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Recibe novedades y descuentos'**
  String get marketingSubtitle;

  /// No description provided for @myReviews.
  ///
  /// In es, this message translates to:
  /// **'Mis reseñas'**
  String get myReviews;

  /// No description provided for @myReviewsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Revisa tus calificaciones anteriores'**
  String get myReviewsSubtitle;

  /// No description provided for @viewAllReviews.
  ///
  /// In es, this message translates to:
  /// **'Ver todas las reseñas'**
  String get viewAllReviews;

  /// No description provided for @noReviewsYet.
  ///
  /// In es, this message translates to:
  /// **'Aún no has dejado reseñas'**
  String get noReviewsYet;

  /// No description provided for @noReviewsDescription.
  ///
  /// In es, this message translates to:
  /// **'Cuando completes un servicio podrás calificarlo aquí.'**
  String get noReviewsDescription;

  /// No description provided for @rateServiceTitle.
  ///
  /// In es, this message translates to:
  /// **'Calificar servicio'**
  String get rateServiceTitle;

  /// No description provided for @ratingPromptTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo fue tu experiencia?'**
  String get ratingPromptTitle;

  /// No description provided for @ratingPromptSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Tu opinión nos ayuda a mejorar la calidad del servicio.'**
  String get ratingPromptSubtitle;

  /// No description provided for @ratingOptionalComment.
  ///
  /// In es, this message translates to:
  /// **'Comentario (opcional)'**
  String get ratingOptionalComment;

  /// No description provided for @ratingCommentHint.
  ///
  /// In es, this message translates to:
  /// **'Cuéntanos sobre tu experiencia con el servicio...'**
  String get ratingCommentHint;

  /// No description provided for @submitRating.
  ///
  /// In es, this message translates to:
  /// **'Enviar calificación'**
  String get submitRating;

  /// No description provided for @updateRating.
  ///
  /// In es, this message translates to:
  /// **'Actualizar calificación'**
  String get updateRating;

  /// No description provided for @ratingSuccess.
  ///
  /// In es, this message translates to:
  /// **'¡Gracias por tu calificación!'**
  String get ratingSuccess;

  /// No description provided for @genericError.
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error. Intenta nuevamente.'**
  String get genericError;

  /// No description provided for @bookingRatedLabel.
  ///
  /// In es, this message translates to:
  /// **'Calificado: {stars} estrellas'**
  String bookingRatedLabel(String stars);

  /// No description provided for @bookingAwaitingRating.
  ///
  /// In es, this message translates to:
  /// **'Toca para calificar este servicio'**
  String get bookingAwaitingRating;

  /// No description provided for @rateNow.
  ///
  /// In es, this message translates to:
  /// **'Calificar'**
  String get rateNow;

  /// No description provided for @viewRating.
  ///
  /// In es, this message translates to:
  /// **'Ver'**
  String get viewRating;

  /// Save changes button text
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get saveChanges;

  /// Cancel button text
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @profileUpdated.
  ///
  /// In es, this message translates to:
  /// **'Perfil actualizado exitosamente'**
  String get profileUpdated;

  /// No description provided for @myJobs.
  ///
  /// In es, this message translates to:
  /// **'Mis trabajos'**
  String get myJobs;

  /// No description provided for @postJobTitle.
  ///
  /// In es, this message translates to:
  /// **'Publicar trabajo'**
  String get postJobTitle;

  /// No description provided for @postJobCta.
  ///
  /// In es, this message translates to:
  /// **'Publicar trabajo'**
  String get postJobCta;

  /// No description provided for @postJobHeroTitle.
  ///
  /// In es, this message translates to:
  /// **'Describe lo que necesitas'**
  String get postJobHeroTitle;

  /// No description provided for @postJobHeroSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Invita profesionales o recibe propuestas con mejores tarifas.'**
  String get postJobHeroSubtitle;

  /// No description provided for @marketplaceHint.
  ///
  /// In es, this message translates to:
  /// **'Los yuvapro aplican con sus propias propuestas.'**
  String get marketplaceHint;

  /// No description provided for @openJobsShort.
  ///
  /// In es, this message translates to:
  /// **'Trabajos abiertos'**
  String get openJobsShort;

  /// No description provided for @myJobsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Publica, revisa propuestas y contrata a tu profesional.'**
  String get myJobsSubtitle;

  /// No description provided for @openJobsTitle.
  ///
  /// In es, this message translates to:
  /// **'Trabajos abiertos'**
  String get openJobsTitle;

  /// No description provided for @activeJobsTitle.
  ///
  /// In es, this message translates to:
  /// **'Trabajos activos'**
  String get activeJobsTitle;

  /// No description provided for @completedJobsTitle.
  ///
  /// In es, this message translates to:
  /// **'Trabajos completados'**
  String get completedJobsTitle;

  /// No description provided for @noJobsYet.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes trabajos publicados'**
  String get noJobsYet;

  /// No description provided for @noJobsDescription.
  ///
  /// In es, this message translates to:
  /// **'Cuando publiques un trabajo verás sus propuestas y estado aquí.'**
  String get noJobsDescription;

  /// No description provided for @jobStepBasics.
  ///
  /// In es, this message translates to:
  /// **'Detalles del trabajo'**
  String get jobStepBasics;

  /// No description provided for @jobStepProperty.
  ///
  /// In es, this message translates to:
  /// **'Propiedad'**
  String get jobStepProperty;

  /// No description provided for @jobStepBudget.
  ///
  /// In es, this message translates to:
  /// **'Presupuesto y frecuencia'**
  String get jobStepBudget;

  /// No description provided for @jobStepLocation.
  ///
  /// In es, this message translates to:
  /// **'Ubicación y horario'**
  String get jobStepLocation;

  /// No description provided for @jobStepSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get jobStepSummary;

  /// No description provided for @jobTitleLabel.
  ///
  /// In es, this message translates to:
  /// **'Título del trabajo'**
  String get jobTitleLabel;

  /// No description provided for @jobTitleHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Limpieza profunda de apartamento'**
  String get jobTitleHint;

  /// No description provided for @jobDescriptionLabel.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get jobDescriptionLabel;

  /// No description provided for @jobDescriptionHint.
  ///
  /// In es, this message translates to:
  /// **'Comparte contexto, prioridades o productos de limpieza.'**
  String get jobDescriptionHint;

  /// No description provided for @jobServiceRequired.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un tipo de servicio para continuar.'**
  String get jobServiceRequired;

  /// No description provided for @jobPropertyTitle.
  ///
  /// In es, this message translates to:
  /// **'Tipo de propiedad'**
  String get jobPropertyTitle;

  /// No description provided for @jobSizeTitle.
  ///
  /// In es, this message translates to:
  /// **'Tamaño'**
  String get jobSizeTitle;

  /// No description provided for @jobBudgetTitle.
  ///
  /// In es, this message translates to:
  /// **'Presupuesto'**
  String get jobBudgetTitle;

  /// No description provided for @jobHourlyRangeLabel.
  ///
  /// In es, this message translates to:
  /// **'Rango por hora'**
  String get jobHourlyRangeLabel;

  /// No description provided for @budgetFrom.
  ///
  /// In es, this message translates to:
  /// **'Desde'**
  String get budgetFrom;

  /// No description provided for @budgetTo.
  ///
  /// In es, this message translates to:
  /// **'Hasta'**
  String get budgetTo;

  /// No description provided for @budgetFixedLabel.
  ///
  /// In es, this message translates to:
  /// **'Presupuesto fijo'**
  String get budgetFixedLabel;

  /// No description provided for @jobFrequencyTitle.
  ///
  /// In es, this message translates to:
  /// **'Frecuencia'**
  String get jobFrequencyTitle;

  /// No description provided for @jobAreaLabel.
  ///
  /// In es, this message translates to:
  /// **'Zona o barrio'**
  String get jobAreaLabel;

  /// No description provided for @jobAreaHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Chapinero, Suba, Usaquén'**
  String get jobAreaHint;

  /// No description provided for @jobPreferredDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha preferida'**
  String get jobPreferredDate;

  /// No description provided for @jobPreferredDateHint.
  ///
  /// In es, this message translates to:
  /// **'Opcional: cuándo te gustaría iniciar'**
  String get jobPreferredDateHint;

  /// No description provided for @jobSummaryTitle.
  ///
  /// In es, this message translates to:
  /// **'Revisa y publica'**
  String get jobSummaryTitle;

  /// No description provided for @jobTitlePlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Título pendiente'**
  String get jobTitlePlaceholder;

  /// No description provided for @jobAreaPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Zona por definir'**
  String get jobAreaPlaceholder;

  /// No description provided for @publishJob.
  ///
  /// In es, this message translates to:
  /// **'Publicar trabajo'**
  String get publishJob;

  /// No description provided for @jobPublishedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Trabajo publicado. Recibirás propuestas pronto.'**
  String get jobPublishedSuccess;

  /// No description provided for @jobDetailTitle.
  ///
  /// In es, this message translates to:
  /// **'Detalle del trabajo'**
  String get jobDetailTitle;

  /// No description provided for @jobNotFound.
  ///
  /// In es, this message translates to:
  /// **'Trabajo no encontrado'**
  String get jobNotFound;

  /// No description provided for @invitedPros.
  ///
  /// In es, this message translates to:
  /// **'Profesionales invitados'**
  String get invitedPros;

  /// No description provided for @noInvitedYet.
  ///
  /// In es, this message translates to:
  /// **'Aún no has invitado a nadie.'**
  String get noInvitedYet;

  /// No description provided for @receivedProposals.
  ///
  /// In es, this message translates to:
  /// **'Propuestas recibidas'**
  String get receivedProposals;

  /// No description provided for @proposalDetailTitle.
  ///
  /// In es, this message translates to:
  /// **'Detalle de propuesta'**
  String get proposalDetailTitle;

  /// No description provided for @noProposalsYet.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay propuestas.'**
  String get noProposalsYet;

  /// No description provided for @viewDetails.
  ///
  /// In es, this message translates to:
  /// **'Ver detalles'**
  String get viewDetails;

  /// No description provided for @shortlistAction.
  ///
  /// In es, this message translates to:
  /// **'Preseleccionar'**
  String get shortlistAction;

  /// No description provided for @rejectAction.
  ///
  /// In es, this message translates to:
  /// **'Rechazar'**
  String get rejectAction;

  /// No description provided for @hireAction.
  ///
  /// In es, this message translates to:
  /// **'Contratar'**
  String get hireAction;

  /// No description provided for @hireSuccessMessage.
  ///
  /// In es, this message translates to:
  /// **'Profesional contratado.'**
  String get hireSuccessMessage;

  /// No description provided for @rateJobCta.
  ///
  /// In es, this message translates to:
  /// **'Calificar trabajo'**
  String get rateJobCta;

  /// No description provided for @ratingAlreadySent.
  ///
  /// In es, this message translates to:
  /// **'Ya calificaste este trabajo.'**
  String get ratingAlreadySent;

  /// No description provided for @proDeleted.
  ///
  /// In es, this message translates to:
  /// **'Profesional no disponible'**
  String get proDeleted;

  /// No description provided for @jobToBeScheduled.
  ///
  /// In es, this message translates to:
  /// **'Por agendar'**
  String get jobToBeScheduled;

  /// No description provided for @proposalsCount.
  ///
  /// In es, this message translates to:
  /// **'{count} propuestas'**
  String proposalsCount(int count);

  /// No description provided for @jobStatusDraft.
  ///
  /// In es, this message translates to:
  /// **'Borrador'**
  String get jobStatusDraft;

  /// No description provided for @jobStatusOpen.
  ///
  /// In es, this message translates to:
  /// **'Abierto'**
  String get jobStatusOpen;

  /// No description provided for @jobStatusUnderReview.
  ///
  /// In es, this message translates to:
  /// **'En revisión'**
  String get jobStatusUnderReview;

  /// No description provided for @jobStatusHired.
  ///
  /// In es, this message translates to:
  /// **'Profesional seleccionado'**
  String get jobStatusHired;

  /// No description provided for @jobStatusInProgress.
  ///
  /// In es, this message translates to:
  /// **'En progreso'**
  String get jobStatusInProgress;

  /// No description provided for @jobStatusCompleted.
  ///
  /// In es, this message translates to:
  /// **'Completado'**
  String get jobStatusCompleted;

  /// No description provided for @jobStatusCancelled.
  ///
  /// In es, this message translates to:
  /// **'Cancelado'**
  String get jobStatusCancelled;

  /// No description provided for @proposalSubmitted.
  ///
  /// In es, this message translates to:
  /// **'Enviada'**
  String get proposalSubmitted;

  /// No description provided for @proposalShortlisted.
  ///
  /// In es, this message translates to:
  /// **'Preseleccionada'**
  String get proposalShortlisted;

  /// No description provided for @proposalRejected.
  ///
  /// In es, this message translates to:
  /// **'Rechazada'**
  String get proposalRejected;

  /// No description provided for @proposalHired.
  ///
  /// In es, this message translates to:
  /// **'Contratada'**
  String get proposalHired;

  /// No description provided for @proposalWithdrawn.
  ///
  /// In es, this message translates to:
  /// **'Retirada'**
  String get proposalWithdrawn;

  /// No description provided for @budgetHourly.
  ///
  /// In es, this message translates to:
  /// **'Por hora'**
  String get budgetHourly;

  /// No description provided for @budgetFixed.
  ///
  /// In es, this message translates to:
  /// **'Precio fijo'**
  String get budgetFixed;

  /// No description provided for @budgetRangeLabel.
  ///
  /// In es, this message translates to:
  /// **'Entre \${from} y \${to} por hora'**
  String budgetRangeLabel(String from, String to);

  /// No description provided for @fixedPriceLabel.
  ///
  /// In es, this message translates to:
  /// **'Precio fijo: \${price}'**
  String fixedPriceLabel(String price);

  /// No description provided for @jobCustomTitle.
  ///
  /// In es, this message translates to:
  /// **'Trabajo personalizado'**
  String get jobCustomTitle;

  /// No description provided for @jobCustomDescription.
  ///
  /// In es, this message translates to:
  /// **'Detalles definidos por el cliente'**
  String get jobCustomDescription;

  /// No description provided for @jobCustomFilled.
  ///
  /// In es, this message translates to:
  /// **'Trabajo personalizado'**
  String get jobCustomFilled;

  /// No description provided for @jobCustomDescriptionFilled.
  ///
  /// In es, this message translates to:
  /// **'Descripción personalizada'**
  String get jobCustomDescriptionFilled;

  /// No description provided for @coverDetailSparkling.
  ///
  /// In es, this message translates to:
  /// **'Soy detallada y llevo mis propios insumos para que tu apartamento quede impecable.'**
  String get coverDetailSparkling;

  /// No description provided for @coverExperienceDeep.
  ///
  /// In es, this message translates to:
  /// **'Experta en limpiezas profundas, foco en cocina y baños.'**
  String get coverExperienceDeep;

  /// No description provided for @coverWeeklyCare.
  ///
  /// In es, this message translates to:
  /// **'Puedo mantener la casa lista cada semana y coordinar horarios.'**
  String get coverWeeklyCare;

  /// No description provided for @coverFlexible.
  ///
  /// In es, this message translates to:
  /// **'Tengo horarios flexibles y me adapto a tus necesidades.'**
  String get coverFlexible;

  /// No description provided for @coverOfficeReset.
  ///
  /// In es, this message translates to:
  /// **'Experiencia en oficinas pequeñas, organizo puestos y desinfección.'**
  String get coverOfficeReset;

  /// No description provided for @searchProsTitle.
  ///
  /// In es, this message translates to:
  /// **'Buscar profesionales'**
  String get searchProsTitle;

  /// No description provided for @searchInviteHint.
  ///
  /// In es, this message translates to:
  /// **'Invita a profesionales directamente a uno de tus trabajos abiertos.'**
  String get searchInviteHint;

  /// No description provided for @noProsFound.
  ///
  /// In es, this message translates to:
  /// **'No encontramos profesionales con ese nombre o zona.'**
  String get noProsFound;

  /// No description provided for @inviteToJob.
  ///
  /// In es, this message translates to:
  /// **'Invitar a un trabajo'**
  String get inviteToJob;

  /// No description provided for @viewOpenJobs.
  ///
  /// In es, this message translates to:
  /// **'Ver trabajos abiertos'**
  String get viewOpenJobs;

  /// No description provided for @selectJobToInvite.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un trabajo para invitar'**
  String get selectJobToInvite;

  /// No description provided for @inviteSent.
  ///
  /// In es, this message translates to:
  /// **'Invitación enviada a {name}'**
  String inviteSent(String name);

  /// No description provided for @noOpenJobsToInvite.
  ///
  /// In es, this message translates to:
  /// **'No tienes trabajos abiertos para invitar.'**
  String get noOpenJobsToInvite;

  /// No description provided for @budgetCopyFallback.
  ///
  /// In es, this message translates to:
  /// **'Propuesta'**
  String get budgetCopyFallback;

  /// No description provided for @jobTitleDeepCleanApt.
  ///
  /// In es, this message translates to:
  /// **'Limpieza profunda de apartamento 2 habitaciones'**
  String get jobTitleDeepCleanApt;

  /// No description provided for @jobDescDeepCleanApt.
  ///
  /// In es, this message translates to:
  /// **'Busco dejar cocina y baños impecables antes de visita familiar.'**
  String get jobDescDeepCleanApt;

  /// No description provided for @jobTitleWeeklyHouse.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento semanal casa en Suba'**
  String get jobTitleWeeklyHouse;

  /// No description provided for @jobDescWeeklyHouse.
  ///
  /// In es, this message translates to:
  /// **'Limpieza general cada semana, prioridad habitaciones y patio.'**
  String get jobDescWeeklyHouse;

  /// No description provided for @jobTitleOfficeReset.
  ///
  /// In es, this message translates to:
  /// **'Reset mensual de oficina pequeña'**
  String get jobTitleOfficeReset;

  /// No description provided for @jobDescOfficeReset.
  ///
  /// In es, this message translates to:
  /// **'Organizar puestos, limpiar vidrios y dejar sala de juntas lista.'**
  String get jobDescOfficeReset;

  /// No description provided for @rateJobTitle.
  ///
  /// In es, this message translates to:
  /// **'Calificar trabajo'**
  String get rateJobTitle;

  /// No description provided for @rateJobShortcut.
  ///
  /// In es, this message translates to:
  /// **'Calificar'**
  String get rateJobShortcut;

  /// No description provided for @searchProsInviteCta.
  ///
  /// In es, this message translates to:
  /// **'Invitar'**
  String get searchProsInviteCta;

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
  /// **'Cuando recibas mensajes de profesionales, aparecerán aquí.'**
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
  /// **'Las notificaciones sobre tus trabajos y propuestas aparecerán aquí.'**
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

  /// Demo mode label
  ///
  /// In es, this message translates to:
  /// **'Modo demo (datos de prueba)'**
  String get demoMode;

  /// Demo mode description
  ///
  /// In es, this message translates to:
  /// **'Activa para ver datos de ejemplo, desactiva para modo vacío'**
  String get demoModeDescription;

  /// Complete profile screen title
  ///
  /// In es, this message translates to:
  /// **'Completa tu perfil'**
  String get completeProfileTitle;

  /// Complete profile screen subtitle for clients
  ///
  /// In es, this message translates to:
  /// **'Necesitamos tu teléfono para coordinar los servicios.'**
  String get completeProfileSubtitleClient;

  /// Name required validation message
  ///
  /// In es, this message translates to:
  /// **'El nombre es requerido'**
  String get completeProfileNameRequired;

  /// Phone field label
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get completeProfilePhone;

  /// Phone hint text
  ///
  /// In es, this message translates to:
  /// **'Ej: +57 300 123 4567'**
  String get completeProfilePhoneHint;

  /// Phone required validation message
  ///
  /// In es, this message translates to:
  /// **'El teléfono es requerido para coordinar servicios'**
  String get completeProfilePhoneRequired;

  /// Save and continue button
  ///
  /// In es, this message translates to:
  /// **'Guardar y continuar'**
  String get completeProfileSave;

  /// Exit confirmation dialog title
  ///
  /// In es, this message translates to:
  /// **'¿Salir sin completar?'**
  String get completeProfileExitTitle;

  /// Exit confirmation dialog message
  ///
  /// In es, this message translates to:
  /// **'Si sales ahora, tendrás que completar tu perfil la próxima vez que inicies sesión.'**
  String get completeProfileExitMessage;

  /// Phone validation error for Colombian numbers
  ///
  /// In es, this message translates to:
  /// **'Ingresa un número de 10 dígitos (solo números)'**
  String get phoneValidationInvalid;

  /// Phone required validation message
  ///
  /// In es, this message translates to:
  /// **'El número de teléfono es requerido'**
  String get phoneValidationRequired;

  /// Colombian phone prefix
  ///
  /// In es, this message translates to:
  /// **'+57'**
  String get phonePrefix;

  /// MFA enrollment screen title
  ///
  /// In es, this message translates to:
  /// **'Verificación de seguridad'**
  String get mfaEnrollmentTitle;

  /// MFA enrollment screen subtitle
  ///
  /// In es, this message translates to:
  /// **'Para tu seguridad, verificaremos tu número de teléfono con un código SMS.'**
  String get mfaEnrollmentSubtitle;

  /// Send SMS code button
  ///
  /// In es, this message translates to:
  /// **'Enviar código'**
  String get mfaSendCode;

  /// Resend SMS code button
  ///
  /// In es, this message translates to:
  /// **'Reenviar código'**
  String get mfaResendCode;

  /// Code sent confirmation message
  ///
  /// In es, this message translates to:
  /// **'Código enviado a {phone}'**
  String mfaCodeSent(String phone);

  /// Enter verification code prompt
  ///
  /// In es, this message translates to:
  /// **'Ingresa el código de 6 dígitos'**
  String get mfaEnterCode;

  /// Verification code field hint
  ///
  /// In es, this message translates to:
  /// **'Código de verificación'**
  String get mfaCodeHint;

  /// Verify button
  ///
  /// In es, this message translates to:
  /// **'Verificar'**
  String get mfaVerify;

  /// Verifying loading text
  ///
  /// In es, this message translates to:
  /// **'Verificando...'**
  String get mfaVerifying;

  /// MFA enrollment success message
  ///
  /// In es, this message translates to:
  /// **'Teléfono verificado exitosamente'**
  String get mfaSuccess;

  /// Invalid verification code error
  ///
  /// In es, this message translates to:
  /// **'Código inválido. Intenta nuevamente.'**
  String get mfaErrorInvalidCode;

  /// Expired verification code error
  ///
  /// In es, this message translates to:
  /// **'El código ha expirado. Solicita uno nuevo.'**
  String get mfaErrorExpiredCode;

  /// Too many requests error
  ///
  /// In es, this message translates to:
  /// **'Demasiados intentos. Espera unos minutos.'**
  String get mfaErrorTooManyRequests;

  /// Generic MFA error
  ///
  /// In es, this message translates to:
  /// **'Error al verificar. Intenta nuevamente.'**
  String get mfaErrorGeneric;

  /// MFA sign-in challenge title
  ///
  /// In es, this message translates to:
  /// **'Verificación requerida'**
  String get mfaSignInTitle;

  /// MFA sign-in challenge subtitle
  ///
  /// In es, this message translates to:
  /// **'Enviamos un código SMS a tu teléfono registrado.'**
  String get mfaSignInSubtitle;

  /// Colombian phone number field label
  ///
  /// In es, this message translates to:
  /// **'Número de teléfono colombiano'**
  String get mfaPhoneLabel;

  /// Colombian phone number hint (10 digits)
  ///
  /// In es, this message translates to:
  /// **'3001234567'**
  String get mfaPhoneHint;

  /// MFA required message
  ///
  /// In es, this message translates to:
  /// **'Debes verificar tu teléfono para continuar'**
  String get mfaRequiredMessage;

  /// Message when user has MFA but app doesn't support it
  ///
  /// In es, this message translates to:
  /// **'Esta cuenta tiene verificación en dos pasos activada. Por favor, contacta soporte para desactivarla.'**
  String get mfaNotSupported;

  /// Title for avatar selection dialog
  ///
  /// In es, this message translates to:
  /// **'Selecciona tu avatar'**
  String get avatarSelectTitle;

  /// Button text to change avatar
  ///
  /// In es, this message translates to:
  /// **'Cambiar avatar'**
  String get avatarChange;

  /// Confirmation when avatar is selected
  ///
  /// In es, this message translates to:
  /// **'Avatar seleccionado'**
  String get avatarSelected;

  /// Edit job menu item
  ///
  /// In es, this message translates to:
  /// **'Editar trabajo'**
  String get editJob;

  /// Delete job menu item
  ///
  /// In es, this message translates to:
  /// **'Eliminar trabajo'**
  String get deleteJob;

  /// Edit job screen title
  ///
  /// In es, this message translates to:
  /// **'Editar trabajo'**
  String get editJobTitle;

  /// Delete job dialog title
  ///
  /// In es, this message translates to:
  /// **'Eliminar trabajo'**
  String get deleteJobTitle;

  /// Delete job confirmation message
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de eliminar este trabajo? Esta acción no se puede deshacer.'**
  String get deleteJobConfirmation;

  /// Delete button text
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// Job deleted success message
  ///
  /// In es, this message translates to:
  /// **'Trabajo eliminado correctamente'**
  String get jobDeletedSuccess;

  /// Job updated success message
  ///
  /// In es, this message translates to:
  /// **'Trabajo actualizado correctamente'**
  String get jobUpdatedSuccess;

  /// Job cannot be modified error message
  ///
  /// In es, this message translates to:
  /// **'Este trabajo ya no se puede modificar'**
  String get jobCannotBeModified;

  /// Proposal shortlisted success message
  ///
  /// In es, this message translates to:
  /// **'Propuesta preseleccionada'**
  String get proposalShortlistedSuccess;

  /// Proposal rejected success message
  ///
  /// In es, this message translates to:
  /// **'Propuesta rechazada'**
  String get proposalRejectedSuccess;

  /// Proposal update error message
  ///
  /// In es, this message translates to:
  /// **'Error al actualizar la propuesta'**
  String get proposalUpdateError;

  /// Reject proposal dialog title
  ///
  /// In es, this message translates to:
  /// **'¿Rechazar propuesta?'**
  String get rejectProposalTitle;

  /// Reject proposal confirmation message
  ///
  /// In es, this message translates to:
  /// **'Esta acción rechazará la propuesta del profesional. ¿Deseas continuar?'**
  String get rejectProposalConfirmation;

  /// Reject button text
  ///
  /// In es, this message translates to:
  /// **'Rechazar'**
  String get reject;

  /// Hire proposal dialog title
  ///
  /// In es, this message translates to:
  /// **'¿Contratar profesional?'**
  String get hireProposalTitle;

  /// Hire proposal confirmation message
  ///
  /// In es, this message translates to:
  /// **'¿Deseas contratar a {proName} para este trabajo? Las demás propuestas serán rechazadas automáticamente.'**
  String hireProposalConfirmation(String proName);

  /// Hire error message
  ///
  /// In es, this message translates to:
  /// **'Error al contratar. Por favor intenta de nuevo.'**
  String get hireError;

  /// Block user action
  ///
  /// In es, this message translates to:
  /// **'Bloquear usuario'**
  String get blockUser;

  /// Block user dialog title
  ///
  /// In es, this message translates to:
  /// **'¿Bloquear a {name}?'**
  String blockUserTitle(String name);

  /// Block user dialog description
  ///
  /// In es, this message translates to:
  /// **'Al bloquear a este usuario:\n• No verás más esta conversación\n• No podrás ver su perfil ni trabajos\n• El usuario no podrá contactarte\n\nEsta acción no se puede deshacer.'**
  String get blockUserDescription;

  /// Block reason input hint
  ///
  /// In es, this message translates to:
  /// **'¿Por qué deseas bloquear a este usuario? (opcional)'**
  String get blockReasonHint;

  /// Block confirm button
  ///
  /// In es, this message translates to:
  /// **'Bloquear'**
  String get blockConfirm;

  /// Block success message
  ///
  /// In es, this message translates to:
  /// **'Usuario bloqueado exitosamente'**
  String get blockSuccess;

  /// Block error message
  ///
  /// In es, this message translates to:
  /// **'Error al bloquear usuario. Intenta de nuevo.'**
  String get blockError;
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
