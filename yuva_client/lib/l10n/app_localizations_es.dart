// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'yuva';

  @override
  String hello(String name) {
    return 'Hola, $name';
  }

  @override
  String get getStarted => 'Comenzar';

  @override
  String get next => 'Siguiente';

  @override
  String get onboardingTitle1 => 'Relájate, tu hogar queda brillante';

  @override
  String get onboardingTitle2 => 'Reserva en minutos';

  @override
  String get onboardingTitle3 =>
      'Encuentra personas de confianza para aseo en casa';

  @override
  String get onboardingDesc1 =>
      'Disfruta de un hogar limpio sin preocupaciones';

  @override
  String get onboardingDesc2 =>
      'Proceso simple y rápido para agendar tu servicio';

  @override
  String get onboardingDesc3 =>
      'Conectamos con profesionales verificados cerca de ti';

  @override
  String get continueWithEmail => 'Continuar con correo';

  @override
  String get continueAsGuest => 'Continuar como invitado';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get signup => 'Crear cuenta';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get name => 'Nombre';

  @override
  String get alreadyHaveAccount => '¿Ya tienes cuenta?';

  @override
  String get dontHaveAccount => '¿No tienes cuenta?';

  @override
  String get home => 'Inicio';

  @override
  String get search => 'Buscar';

  @override
  String get myBookings => 'Mis reservas';

  @override
  String get profile => 'Perfil';

  @override
  String get searchPlaceholder => 'Buscar servicios de limpieza...';

  @override
  String get searchFilters => 'Filtros de búsqueda';

  @override
  String get priceRange => 'Rango de precio';

  @override
  String rating(String rating, int count) {
    return '$rating ($count reseñas)';
  }

  @override
  String get availability => 'Disponibilidad';

  @override
  String get searchResults => 'Resultados de búsqueda aparecerán aquí';

  @override
  String get categories => 'Categorías';

  @override
  String get featuredCleaners => 'Destacados';

  @override
  String get noBookingsYet => 'Aún no tienes reservas';

  @override
  String get noBookingsDescription =>
      'Cuando reserves un servicio, lo verás aquí con el estado y los detalles.';

  @override
  String get exploreOptions => 'Explorar opciones';

  @override
  String get language => 'Idioma';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'English';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get categoryOnetime => 'Aseo puntual';

  @override
  String get categoryWeekly => 'Aseo semanal';

  @override
  String get categoryDeep => 'Limpieza profunda';

  @override
  String get categoryMoving => 'Mudanza';

  @override
  String perHour(String price) {
    return '$price/hora';
  }

  @override
  String yearsExperience(int years) {
    return '$years años de experiencia';
  }

  @override
  String get newBooking => 'Nueva reserva';

  @override
  String get bookingSubtitle =>
      'Visualiza y sigue el estado de tus servicios agendados.';

  @override
  String get stepChooseService => 'Elige el servicio';

  @override
  String get stepPropertyDetails => 'Detalles de la propiedad';

  @override
  String get stepFrequencyDate => 'Frecuencia y fecha';

  @override
  String get stepAddressNotes => 'Dirección y notas';

  @override
  String get stepPriceEstimate => 'Precio estimado';

  @override
  String get stepSummary => 'Resumen';

  @override
  String progressLabel(String step) {
    return 'Paso $step';
  }

  @override
  String get chooseServiceHint =>
      'Selecciona el tipo de limpieza que necesitas.';

  @override
  String get propertyTypeTitle => 'Tipo de propiedad';

  @override
  String get sizeCategoryTitle => 'Tamaño';

  @override
  String get bedrooms => 'Habitaciones';

  @override
  String get bathrooms => 'Baños';

  @override
  String get frequencyTitle => 'Frecuencia';

  @override
  String get dateAndTime => 'Fecha y hora';

  @override
  String get durationHours => 'Duración (horas)';

  @override
  String get addressLabel => 'Dirección';

  @override
  String get addressPlaceholder => 'Ej: Calle 34 #12-45, Apto 402';

  @override
  String get notesLabel => 'Notas';

  @override
  String get notesPlaceholder =>
      'Instrucciones adicionales (portería, mascotas, acceso...)';

  @override
  String get estimatedPriceLabel => 'Precio estimado';

  @override
  String get pricePending => 'Calculando...';

  @override
  String get priceDisclaimer =>
      'El precio final puede cambiar cuando un profesional acepte tu solicitud.';

  @override
  String get whatAffectsPrice => '¿Cómo calculamos el precio?';

  @override
  String get priceFactors =>
      'Consideramos el tipo de servicio, tamaño del espacio, frecuencia y duración estimada.';

  @override
  String get summaryTitle => 'Resumen de tu reserva';

  @override
  String get back => 'Atrás';

  @override
  String get confirmBooking => 'Confirmar reserva';

  @override
  String get selectServiceFirst =>
      'Selecciona un tipo de servicio para continuar.';

  @override
  String get serviceStandard => 'Limpieza completa';

  @override
  String get serviceStandardDesc =>
      'Rutina general para dejar cada espacio fresco.';

  @override
  String get serviceDeepClean => 'Limpieza profunda';

  @override
  String get serviceDeepCleanDesc =>
      'Atención detallada en cocina, baños y zonas de alto uso.';

  @override
  String get serviceMoveOut => 'Limpieza de mudanza';

  @override
  String get serviceMoveOutDesc =>
      'Deja todo listo al entregar o recibir un espacio.';

  @override
  String get serviceOffice => 'Oficina/Local';

  @override
  String get serviceOfficeDesc =>
      'Limpieza ligera para oficinas o locales pequeños.';

  @override
  String get propertyApartment => 'Apartamento';

  @override
  String get propertyHouse => 'Casa';

  @override
  String get propertySmallOffice => 'Oficina pequeña';

  @override
  String get sizeSmall => 'Pequeño';

  @override
  String get sizeMedium => 'Mediano';

  @override
  String get sizeLarge => 'Grande';

  @override
  String get frequencyOnce => 'Una sola vez';

  @override
  String get frequencyWeekly => 'Semanal';

  @override
  String get frequencyBiweekly => 'Quincenal';

  @override
  String get frequencyMonthly => 'Mensual';

  @override
  String get dateLabel => 'Fecha';

  @override
  String get frequencyLabel => 'Frecuencia';

  @override
  String get durationLabel => 'Duración';

  @override
  String get roomsLabel => 'Espacios';

  @override
  String roomsCount(int bedrooms, int bathrooms) {
    return '$bedrooms hab / $bathrooms baños';
  }

  @override
  String get bookingSuccessTitle => '¡Solicitud enviada!';

  @override
  String bookingSuccessSubtitle(String service) {
    return 'Recibirás notificaciones cuando $service sea aceptado.';
  }

  @override
  String get viewMyBookings => 'Ver mis reservas';

  @override
  String get bookingDetailTitle => 'Detalle de la reserva';

  @override
  String get noNotesPlaceholder => 'Sin notas adicionales';

  @override
  String get assignedCleanerPlaceholder => 'Profesional asignado';

  @override
  String get assignedCleanerHint =>
      'Aquí verás quién tome tu servicio y su perfil cuando esté disponible.';

  @override
  String get upcomingBookings => 'Próximas';

  @override
  String get pastBookings => 'Pasadas';

  @override
  String get serviceTypeLabel => 'Tipo de servicio';

  @override
  String get statusPending => 'Pendiente';

  @override
  String get statusInProgress => 'En progreso';

  @override
  String get statusCompleted => 'Completado';

  @override
  String get statusCancelled => 'Cancelado';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get editProfileTitle => 'Editar información';

  @override
  String get settings => 'Configuración';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get notificationsSubtitle => 'Recibe alertas de tus servicios';

  @override
  String get marketingOptIn => 'Ofertas y promociones';

  @override
  String get marketingSubtitle => 'Recibe novedades y descuentos';

  @override
  String get myReviews => 'Mis reseñas';

  @override
  String get myReviewsSubtitle => 'Revisa tus calificaciones anteriores';

  @override
  String get viewAllReviews => 'Ver todas las reseñas';

  @override
  String get noReviewsYet => 'Aún no has dejado reseñas';

  @override
  String get noReviewsDescription =>
      'Cuando completes un servicio podrás calificarlo aquí.';

  @override
  String get rateServiceTitle => 'Calificar servicio';

  @override
  String get ratingPromptTitle => '¿Cómo fue tu experiencia?';

  @override
  String get ratingPromptSubtitle =>
      'Tu opinión nos ayuda a mejorar la calidad del servicio.';

  @override
  String get ratingOptionalComment => 'Comentario (opcional)';

  @override
  String get ratingCommentHint =>
      'Cuéntanos sobre tu experiencia con el servicio...';

  @override
  String get submitRating => 'Enviar calificación';

  @override
  String get updateRating => 'Actualizar calificación';

  @override
  String get ratingSuccess => '¡Gracias por tu calificación!';

  @override
  String get genericError => 'Ocurrió un error. Intenta nuevamente.';

  @override
  String bookingRatedLabel(String stars) {
    return 'Calificado: $stars estrellas';
  }

  @override
  String get bookingAwaitingRating => 'Toca para calificar este servicio';

  @override
  String get rateNow => 'Calificar';

  @override
  String get viewRating => 'Ver';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get cancel => 'Cancelar';

  @override
  String get profileUpdated => 'Perfil actualizado exitosamente';

  @override
  String get myJobs => 'Mis trabajos';

  @override
  String get postJobTitle => 'Publicar trabajo';

  @override
  String get postJobCta => 'Publicar trabajo';

  @override
  String get postJobHeroTitle => 'Describe lo que necesitas';

  @override
  String get postJobHeroSubtitle =>
      'Invita profesionales o recibe propuestas con mejores tarifas.';

  @override
  String get marketplaceHint =>
      'Los yuvapro aplican con sus propias propuestas.';

  @override
  String get openJobsShort => 'Trabajos abiertos';

  @override
  String get myJobsSubtitle =>
      'Publica, revisa propuestas y contrata a tu profesional.';

  @override
  String get openJobsTitle => 'Trabajos abiertos';

  @override
  String get activeJobsTitle => 'Trabajos activos';

  @override
  String get completedJobsTitle => 'Trabajos completados';

  @override
  String get noJobsYet => 'Aún no tienes trabajos publicados';

  @override
  String get noJobsDescription =>
      'Cuando publiques un trabajo verás sus propuestas y estado aquí.';

  @override
  String get jobStepBasics => 'Detalles del trabajo';

  @override
  String get jobStepProperty => 'Propiedad';

  @override
  String get jobStepBudget => 'Presupuesto y frecuencia';

  @override
  String get jobStepLocation => 'Ubicación y horario';

  @override
  String get jobStepSummary => 'Resumen';

  @override
  String get jobTitleLabel => 'Título del trabajo';

  @override
  String get jobTitleHint => 'Ej: Limpieza profunda de apartamento';

  @override
  String get jobDescriptionLabel => 'Descripción';

  @override
  String get jobDescriptionHint =>
      'Comparte contexto, prioridades o productos de limpieza.';

  @override
  String get jobServiceRequired =>
      'Selecciona un tipo de servicio para continuar.';

  @override
  String get jobPropertyTitle => 'Tipo de propiedad';

  @override
  String get jobSizeTitle => 'Tamaño';

  @override
  String get jobBudgetTitle => 'Presupuesto';

  @override
  String get jobHourlyRangeLabel => 'Rango por hora';

  @override
  String get budgetFrom => 'Desde';

  @override
  String get budgetTo => 'Hasta';

  @override
  String get budgetFixedLabel => 'Presupuesto fijo';

  @override
  String get jobFrequencyTitle => 'Frecuencia';

  @override
  String get jobAreaLabel => 'Zona o barrio';

  @override
  String get jobAreaHint => 'Ej: Chapinero, Suba, Usaquén';

  @override
  String get jobPreferredDate => 'Fecha preferida';

  @override
  String get jobPreferredDateHint => 'Opcional: cuándo te gustaría iniciar';

  @override
  String get jobSummaryTitle => 'Revisa y publica';

  @override
  String get jobTitlePlaceholder => 'Título pendiente';

  @override
  String get jobAreaPlaceholder => 'Zona por definir';

  @override
  String get publishJob => 'Publicar trabajo';

  @override
  String get jobPublishedSuccess =>
      'Trabajo publicado. Recibirás propuestas pronto.';

  @override
  String get jobDetailTitle => 'Detalle del trabajo';

  @override
  String get jobNotFound => 'Trabajo no encontrado';

  @override
  String get invitedPros => 'Profesionales invitados';

  @override
  String get noInvitedYet => 'Aún no has invitado a nadie.';

  @override
  String get receivedProposals => 'Propuestas recibidas';

  @override
  String get proposalDetailTitle => 'Detalle de propuesta';

  @override
  String get noProposalsYet => 'Todavía no hay propuestas.';

  @override
  String get viewDetails => 'Ver detalles';

  @override
  String get shortlistAction => 'Preseleccionar';

  @override
  String get rejectAction => 'Rechazar';

  @override
  String get hireAction => 'Contratar';

  @override
  String get hireSuccessMessage => 'Profesional contratado.';

  @override
  String get rateJobCta => 'Calificar trabajo';

  @override
  String get ratingAlreadySent => 'Ya calificaste este trabajo.';

  @override
  String get proDeleted => 'Profesional no disponible';

  @override
  String get jobToBeScheduled => 'Por agendar';

  @override
  String proposalsCount(int count) {
    return '$count propuestas';
  }

  @override
  String get jobStatusDraft => 'Borrador';

  @override
  String get jobStatusOpen => 'Abierto';

  @override
  String get jobStatusUnderReview => 'En revisión';

  @override
  String get jobStatusHired => 'Profesional seleccionado';

  @override
  String get jobStatusInProgress => 'En progreso';

  @override
  String get jobStatusCompleted => 'Completado';

  @override
  String get jobStatusCancelled => 'Cancelado';

  @override
  String get proposalSubmitted => 'Enviada';

  @override
  String get proposalShortlisted => 'Preseleccionada';

  @override
  String get proposalRejected => 'Rechazada';

  @override
  String get proposalHired => 'Contratada';

  @override
  String get budgetHourly => 'Por hora';

  @override
  String get budgetFixed => 'Precio fijo';

  @override
  String budgetRangeLabel(String from, String to) {
    return 'Entre \$$from y \$$to por hora';
  }

  @override
  String fixedPriceLabel(String price) {
    return 'Precio fijo: \$$price';
  }

  @override
  String get jobCustomTitle => 'Trabajo personalizado';

  @override
  String get jobCustomDescription => 'Detalles definidos por el cliente';

  @override
  String get jobCustomFilled => 'Trabajo personalizado';

  @override
  String get jobCustomDescriptionFilled => 'Descripción personalizada';

  @override
  String get coverDetailSparkling =>
      'Soy detallada y llevo mis propios insumos para que tu apartamento quede impecable.';

  @override
  String get coverExperienceDeep =>
      'Experta en limpiezas profundas, foco en cocina y baños.';

  @override
  String get coverWeeklyCare =>
      'Puedo mantener la casa lista cada semana y coordinar horarios.';

  @override
  String get coverFlexible =>
      'Tengo horarios flexibles y me adapto a tus necesidades.';

  @override
  String get coverOfficeReset =>
      'Experiencia en oficinas pequeñas, organizo puestos y desinfección.';

  @override
  String get searchProsTitle => 'Buscar profesionales';

  @override
  String get searchInviteHint =>
      'Invita a profesionales directamente a uno de tus trabajos abiertos.';

  @override
  String get noProsFound =>
      'No encontramos profesionales con ese nombre o zona.';

  @override
  String get inviteToJob => 'Invitar a un trabajo';

  @override
  String get viewOpenJobs => 'Ver trabajos abiertos';

  @override
  String get selectJobToInvite => 'Selecciona un trabajo para invitar';

  @override
  String inviteSent(String name) {
    return 'Invitación enviada a $name';
  }

  @override
  String get noOpenJobsToInvite => 'No tienes trabajos abiertos para invitar.';

  @override
  String get budgetCopyFallback => 'Propuesta';

  @override
  String get jobTitleDeepCleanApt =>
      'Limpieza profunda de apartamento 2 habitaciones';

  @override
  String get jobDescDeepCleanApt =>
      'Busco dejar cocina y baños impecables antes de visita familiar.';

  @override
  String get jobTitleWeeklyHouse => 'Mantenimiento semanal casa en Suba';

  @override
  String get jobDescWeeklyHouse =>
      'Limpieza general cada semana, prioridad habitaciones y patio.';

  @override
  String get jobTitleOfficeReset => 'Reset mensual de oficina pequeña';

  @override
  String get jobDescOfficeReset =>
      'Organizar puestos, limpiar vidrios y dejar sala de juntas lista.';

  @override
  String get rateJobTitle => 'Calificar trabajo';

  @override
  String get rateJobShortcut => 'Calificar';

  @override
  String get searchProsInviteCta => 'Invitar';

  @override
  String get messages => 'Mensajes';

  @override
  String get noMessagesYet => 'Aún no tienes mensajes';

  @override
  String get noMessagesDescription =>
      'Cuando recibas mensajes de profesionales, aparecerán aquí.';

  @override
  String get activeJob => 'Trabajo activo';

  @override
  String get noMessagesInConversation => 'No hay mensajes en esta conversación';

  @override
  String get typeMessage => 'Escribe un mensaje...';

  @override
  String get markAllAsRead => 'Marcar todo como leído';

  @override
  String get noNotificationsYet => 'No tienes notificaciones';

  @override
  String get noNotificationsDescription =>
      'Las notificaciones sobre tus trabajos y propuestas aparecerán aquí.';

  @override
  String get unreadMessages => 'Mensajes sin leer';

  @override
  String get newNotifications => 'Notificaciones nuevas';

  @override
  String get demoMode => 'Modo demo (datos de prueba)';

  @override
  String get demoModeDescription =>
      'Activa para ver datos de ejemplo, desactiva para modo vacío';

  @override
  String get completeProfileTitle => 'Completa tu perfil';

  @override
  String get completeProfileSubtitleClient =>
      'Necesitamos tu teléfono para coordinar los servicios.';

  @override
  String get completeProfileNameRequired => 'El nombre es requerido';

  @override
  String get completeProfilePhone => 'Teléfono';

  @override
  String get completeProfilePhoneHint => 'Ej: +57 300 123 4567';

  @override
  String get completeProfilePhoneRequired =>
      'El teléfono es requerido para coordinar servicios';

  @override
  String get completeProfileSave => 'Guardar y continuar';

  @override
  String get completeProfileExitTitle => '¿Salir sin completar?';

  @override
  String get completeProfileExitMessage =>
      'Si sales ahora, tendrás que completar tu perfil la próxima vez que inicies sesión.';

  @override
  String get phoneValidationInvalid =>
      'Ingresa un número de 10 dígitos (solo números)';

  @override
  String get phoneValidationRequired => 'El número de teléfono es requerido';

  @override
  String get phonePrefix => '+57';

  @override
  String get mfaEnrollmentTitle => 'Verificación de seguridad';

  @override
  String get mfaEnrollmentSubtitle =>
      'Para tu seguridad, verificaremos tu número de teléfono con un código SMS.';

  @override
  String get mfaSendCode => 'Enviar código';

  @override
  String get mfaResendCode => 'Reenviar código';

  @override
  String mfaCodeSent(String phone) {
    return 'Código enviado a $phone';
  }

  @override
  String get mfaEnterCode => 'Ingresa el código de 6 dígitos';

  @override
  String get mfaCodeHint => 'Código de verificación';

  @override
  String get mfaVerify => 'Verificar';

  @override
  String get mfaVerifying => 'Verificando...';

  @override
  String get mfaSuccess => 'Teléfono verificado exitosamente';

  @override
  String get mfaErrorInvalidCode => 'Código inválido. Intenta nuevamente.';

  @override
  String get mfaErrorExpiredCode =>
      'El código ha expirado. Solicita uno nuevo.';

  @override
  String get mfaErrorTooManyRequests =>
      'Demasiados intentos. Espera unos minutos.';

  @override
  String get mfaErrorGeneric => 'Error al verificar. Intenta nuevamente.';

  @override
  String get mfaSignInTitle => 'Verificación requerida';

  @override
  String get mfaSignInSubtitle =>
      'Enviamos un código SMS a tu teléfono registrado.';

  @override
  String get mfaPhoneLabel => 'Número de teléfono colombiano';

  @override
  String get mfaPhoneHint => '3001234567';

  @override
  String get mfaRequiredMessage => 'Debes verificar tu teléfono para continuar';

  @override
  String get mfaNotSupported =>
      'Esta cuenta tiene verificación en dos pasos activada. Por favor, contacta soporte para desactivarla.';

  @override
  String get avatarSelectTitle => 'Selecciona tu avatar';

  @override
  String get avatarChange => 'Cambiar avatar';

  @override
  String get avatarSelected => 'Avatar seleccionado';
}
