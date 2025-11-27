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
  String get onboardingWorkerTitle1 => 'Encuentra trabajos de aseo cerca de ti';

  @override
  String get onboardingWorkerTitle2 =>
      'Elige los trabajos que se ajustan a tu tarifa';

  @override
  String get onboardingWorkerTitle3 =>
      'Construye tu reputación con buenos resultados';

  @override
  String get onboardingWorkerDesc1 =>
      'Conecta con clientes cerca de tu zona de trabajo';

  @override
  String get onboardingWorkerDesc2 =>
      'Propón tus tarifas y condiciones, tú decides';

  @override
  String get onboardingWorkerDesc3 =>
      'Cada trabajo completado mejora tu perfil profesional';

  @override
  String get continueWithEmail => 'Continuar con correo';

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
  String get lastName => 'Apellido';

  @override
  String get alreadyHaveAccount => '¿Ya tienes cuenta?';

  @override
  String get dontHaveAccount => '¿No tienes cuenta?';

  @override
  String get home => 'Inicio';

  @override
  String get jobs => 'Trabajos';

  @override
  String get profile => 'Perfil';

  @override
  String get language => 'Idioma';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'English';

  @override
  String get skip => 'Saltar';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get recommendedJobs => 'Trabajos recomendados para ti';

  @override
  String get invitations => 'Invitaciones';

  @override
  String get invitation => 'Invitación';

  @override
  String get newJobs => 'Nuevos';

  @override
  String get myProposals => 'Mis propuestas';

  @override
  String get contracts => 'Contratos';

  @override
  String get noJobsAvailable => 'No hay trabajos disponibles';

  @override
  String get noJobsDescription =>
      'Cuando haya trabajos que coincidan con tu perfil, los verás aquí.';

  @override
  String get jobDetailTitle => 'Detalle del trabajo';

  @override
  String get propertyDetails => 'Detalles de la propiedad';

  @override
  String get budgetDetails => 'Detalles del presupuesto';

  @override
  String get prepareProposal => 'Preparar propuesta';

  @override
  String get proposalFeatureComingSoon =>
      'La funcionalidad de propuestas se implementará en una fase posterior';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get baseHourlyRate => 'Tarifa base por hora';

  @override
  String get baseArea => 'Zona base';

  @override
  String get offeredServices => 'Servicios ofrecidos';

  @override
  String rating(String rating, int count) {
    return '$rating ★ ($count reseñas)';
  }

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get cancel => 'Cancelar';

  @override
  String get profileUpdated => 'Perfil actualizado exitosamente';

  @override
  String get back => 'Atrás';

  @override
  String perHour(String price) {
    return '$price/hora';
  }

  @override
  String fixedBudget(String price) {
    return 'Presupuesto fijo: $price';
  }

  @override
  String hourlyRange(String from, String to) {
    return '$from - $to / hora';
  }

  @override
  String get serviceStandard => 'Limpieza completa';

  @override
  String get serviceDeepClean => 'Limpieza profunda';

  @override
  String get serviceMoveOut => 'Limpieza de mudanza';

  @override
  String get serviceOffice => 'Oficina/Local';

  @override
  String get frequencyOnce => 'Una sola vez';

  @override
  String get frequencyWeekly => 'Semanal';

  @override
  String get frequencyBiweekly => 'Quincenal';

  @override
  String get frequencyMonthly => 'Mensual';

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
  String get bedrooms => 'Habitaciones';

  @override
  String get bathrooms => 'Baños';

  @override
  String roomsCount(int bedrooms, int bathrooms) {
    return '$bedrooms hab / $bathrooms baños';
  }

  @override
  String get preferredDate => 'Fecha preferida';

  @override
  String get notSpecified => 'No especificado';

  @override
  String get createMyProfile => 'Crear mi perfil';

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
  String get jobTitlePostMoveCondo =>
      'Limpieza post mudanza apartamento amoblado';

  @override
  String get jobDescPostMoveCondo =>
      'Necesito una limpieza profunda después de mudanza, incluye ventanas.';

  @override
  String get jobTitleBiweeklyStudio => 'Limpieza quincenal de estudio';

  @override
  String get jobDescBiweeklyStudio =>
      'Mantenimiento básico cada dos semanas para estudio de 1 habitación.';

  @override
  String get area => 'Zona';

  @override
  String get frequency => 'Frecuencia';

  @override
  String get description => 'Descripción';

  @override
  String get messages => 'Mensajes';

  @override
  String get noMessagesYet => 'Aún no tienes mensajes';

  @override
  String get noMessagesDescription =>
      'Cuando recibas mensajes de clientes, aparecerán aquí.';

  @override
  String get activeJob => 'Trabajo activo';

  @override
  String get noMessagesInConversation => 'No hay mensajes en esta conversación';

  @override
  String get typeMessage => 'Escribe un mensaje...';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get markAllAsRead => 'Marcar todo como leído';

  @override
  String get noNotificationsYet => 'No tienes notificaciones';

  @override
  String get noNotificationsDescription =>
      'Las notificaciones sobre tus propuestas y trabajos aparecerán aquí.';

  @override
  String get unreadMessages => 'Mensajes sin leer';

  @override
  String get newNotifications => 'Notificaciones nuevas';

  @override
  String get cityOrZone => 'Ciudad o zona';

  @override
  String get cityOrZoneHint => 'Ej: Bogotá, Chapinero';

  @override
  String get demoMode => 'Modo demo (datos de prueba)';

  @override
  String get demoModeDescription =>
      'Activa para ver datos de ejemplo, desactiva para modo vacío';

  @override
  String get completeProfileTitle => 'Completa tu perfil';

  @override
  String get completeProfileSubtitle =>
      'Necesitamos algunos datos adicionales para que puedas recibir trabajos.';

  @override
  String get completeProfileNameRequired => 'El nombre es requerido';

  @override
  String get completeProfileZoneRequired => 'La zona de trabajo es requerida';

  @override
  String get completeProfileRateHint => 'Ej: 45000';

  @override
  String get completeProfileRateRequired => 'La tarifa por hora es requerida';

  @override
  String get completeProfileRateInvalid =>
      'Ingresa una tarifa válida mayor a 0';

  @override
  String get completeProfileSave => 'Guardar y continuar';

  @override
  String get completeProfileExitTitle => '¿Salir sin completar?';

  @override
  String get completeProfileExitMessage =>
      'Si sales ahora, tendrás que completar tu perfil la próxima vez que inicies sesión.';

  @override
  String get avatarSelectTitle => 'Selecciona tu avatar';

  @override
  String get avatarChange => 'Cambiar avatar';

  @override
  String get avatarSelected => 'Avatar seleccionado';

  @override
  String get proposalBudgetType => 'Tipo de presupuesto';

  @override
  String get budgetHourly => 'Por hora';

  @override
  String get budgetFixed => 'Precio fijo';

  @override
  String get proposalHourlyRate => 'Tarifa por hora (COP)';

  @override
  String get proposalFixedPrice => 'Precio fijo (COP)';

  @override
  String get proposalHourlyRateHint => 'Ej: 25000';

  @override
  String get proposalFixedPriceHint => 'Ej: 80000';

  @override
  String get proposalEstimatedHours => 'Horas estimadas';

  @override
  String get proposalEstimatedHoursHint => 'Ej: 4';

  @override
  String get proposalMessage => 'Mensaje para el cliente';

  @override
  String get proposalMessageHint =>
      'Describe tu experiencia y por qué eres ideal para este trabajo...';

  @override
  String get proposalTotalEstimate => 'Total estimado';

  @override
  String get submitProposal => 'Enviar propuesta';

  @override
  String clientBudgetFixed(String amount) {
    return 'Presupuesto del cliente: $amount';
  }

  @override
  String clientBudgetHourly(String min, String max) {
    return 'Presupuesto del cliente: $min - $max/hora';
  }

  @override
  String get proposalAmountRequired => 'Ingresa un monto válido';

  @override
  String get proposalSubmittedSuccess => '¡Propuesta enviada exitosamente!';

  @override
  String get proposalSubmitError =>
      'Error al enviar la propuesta. Intenta de nuevo.';

  @override
  String get sentProposals => 'Enviadas';

  @override
  String get noProposalsSent => 'Aún no has enviado propuestas';

  @override
  String get noProposalsSentDescription =>
      'Cuando envíes propuestas para trabajos, aparecerán aquí.';

  @override
  String get proposalStatusDraft => 'Borrador';

  @override
  String get proposalStatusSent => 'Enviada';

  @override
  String get proposalStatusShortlisted => 'Preseleccionada';

  @override
  String get proposalStatusHired => 'Contratada';

  @override
  String get proposalStatusRejected => 'Rechazada';

  @override
  String get proposalStatusWithdrawn => 'Retirada';

  @override
  String proposalForJob(String jobId) {
    return 'Propuesta #$jobId';
  }

  @override
  String get withdrawProposal => 'Retirar';

  @override
  String get withdrawProposalTitle => '¿Retirar propuesta?';

  @override
  String get withdrawProposalConfirmation =>
      'Si retiras esta propuesta, el cliente ya no podrá verla. Esta acción no se puede deshacer.';

  @override
  String get withdraw => 'Retirar';

  @override
  String get proposalWithdrawnSuccess => 'Propuesta retirada exitosamente';

  @override
  String get proposalWithdrawError =>
      'Error al retirar la propuesta. Intenta de nuevo.';

  @override
  String get proposalSent => 'Propuesta enviada';

  @override
  String get proposalDetails => 'Detalle de propuesta';

  @override
  String get yourProposal => 'Tu propuesta';

  @override
  String get editProposal => 'Editar propuesta';

  @override
  String get updateProposal => 'Actualizar propuesta';

  @override
  String get proposalUpdatedSuccess => 'Propuesta actualizada exitosamente';

  @override
  String get blockUser => 'Bloquear usuario';

  @override
  String blockUserTitle(String name) {
    return '¿Bloquear a $name?';
  }

  @override
  String get blockUserDescription =>
      'Al bloquear a este usuario:\n• No verás más esta conversación\n• No podrás ver sus trabajos\n• El usuario no podrá contactarte\n\nEsta acción no se puede deshacer.';

  @override
  String get blockReasonHint =>
      '¿Por qué deseas bloquear a este usuario? (opcional)';

  @override
  String get blockConfirm => 'Bloquear';

  @override
  String get blockSuccess => 'Usuario bloqueado exitosamente';

  @override
  String get blockError => 'Error al bloquear usuario. Intenta de nuevo.';
}
