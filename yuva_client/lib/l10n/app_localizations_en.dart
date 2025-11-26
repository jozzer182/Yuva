// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'yuva';

  @override
  String hello(String name) {
    return 'Hello, $name';
  }

  @override
  String get getStarted => 'Get started';

  @override
  String get next => 'Next';

  @override
  String get onboardingTitle1 => 'Relax, your home will shine';

  @override
  String get onboardingTitle2 => 'Book in minutes';

  @override
  String get onboardingTitle3 => 'Find trusted people for home cleaning';

  @override
  String get onboardingDesc1 => 'Enjoy a clean home without worries';

  @override
  String get onboardingDesc2 =>
      'Simple and fast process to schedule your service';

  @override
  String get onboardingDesc3 =>
      'We connect with verified professionals near you';

  @override
  String get continueWithEmail => 'Continue with email';

  @override
  String get continueAsGuest => 'Continue as guest';

  @override
  String get login => 'Log in';

  @override
  String get signup => 'Sign up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get name => 'Name';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get home => 'Home';

  @override
  String get search => 'Search';

  @override
  String get myBookings => 'My bookings';

  @override
  String get profile => 'Profile';

  @override
  String get searchPlaceholder => 'Search cleaning services...';

  @override
  String get searchFilters => 'Search filters';

  @override
  String get priceRange => 'Price range';

  @override
  String rating(String rating, int count) {
    return '$rating ($count reviews)';
  }

  @override
  String get availability => 'Availability';

  @override
  String get searchResults => 'Search results will appear here';

  @override
  String get categories => 'Categories';

  @override
  String get featuredCleaners => 'Featured';

  @override
  String get noBookingsYet => 'No bookings yet';

  @override
  String get noBookingsDescription =>
      'When you book a service, you will see it here with the status and details.';

  @override
  String get exploreOptions => 'Explore options';

  @override
  String get language => 'Language';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'English';

  @override
  String get logout => 'Log out';

  @override
  String get categoryOnetime => 'One-time cleaning';

  @override
  String get categoryWeekly => 'Weekly cleaning';

  @override
  String get categoryDeep => 'Deep cleaning';

  @override
  String get categoryMoving => 'Moving cleaning';

  @override
  String perHour(String price) {
    return '$price/hour';
  }

  @override
  String yearsExperience(int years) {
    return '$years years of experience';
  }

  @override
  String get newBooking => 'New booking';

  @override
  String get bookingSubtitle =>
      'View and track the status of your scheduled services.';

  @override
  String get stepChooseService => 'Choose service';

  @override
  String get stepPropertyDetails => 'Property details';

  @override
  String get stepFrequencyDate => 'Frequency and date';

  @override
  String get stepAddressNotes => 'Address and notes';

  @override
  String get stepPriceEstimate => 'Price estimate';

  @override
  String get stepSummary => 'Summary';

  @override
  String progressLabel(String step) {
    return 'Step $step';
  }

  @override
  String get chooseServiceHint => 'Pick the cleaning service you need.';

  @override
  String get propertyTypeTitle => 'Property type';

  @override
  String get sizeCategoryTitle => 'Size';

  @override
  String get bedrooms => 'Bedrooms';

  @override
  String get bathrooms => 'Bathrooms';

  @override
  String get frequencyTitle => 'Frequency';

  @override
  String get dateAndTime => 'Date & time';

  @override
  String get durationHours => 'Duration (hours)';

  @override
  String get addressLabel => 'Address';

  @override
  String get addressPlaceholder => 'e.g., 123 Main St, Apt 4B';

  @override
  String get notesLabel => 'Notes';

  @override
  String get notesPlaceholder => 'Gate codes, elevator, pets, instructions...';

  @override
  String get estimatedPriceLabel => 'Estimated price';

  @override
  String get pricePending => 'Calculating...';

  @override
  String get priceDisclaimer =>
      'Final price may change when a professional accepts your request.';

  @override
  String get whatAffectsPrice => 'What affects the price?';

  @override
  String get priceFactors =>
      'We consider service type, space size, frequency, and estimated duration.';

  @override
  String get summaryTitle => 'Booking summary';

  @override
  String get back => 'Back';

  @override
  String get confirmBooking => 'Confirm booking';

  @override
  String get selectServiceFirst => 'Select a service type to continue.';

  @override
  String get serviceStandard => 'Standard clean';

  @override
  String get serviceStandardDesc => 'General routine to refresh every space.';

  @override
  String get serviceDeepClean => 'Deep clean';

  @override
  String get serviceDeepCleanDesc =>
      'Detailed focus on kitchen, bathrooms, and heavy-use areas.';

  @override
  String get serviceMoveOut => 'Move-out clean';

  @override
  String get serviceMoveOutDesc =>
      'Leave everything ready when moving out or in.';

  @override
  String get serviceOffice => 'Office/Shop';

  @override
  String get serviceOfficeDesc => 'Light clean for small offices or shops.';

  @override
  String get propertyApartment => 'Apartment';

  @override
  String get propertyHouse => 'House';

  @override
  String get propertySmallOffice => 'Small office';

  @override
  String get sizeSmall => 'Small';

  @override
  String get sizeMedium => 'Medium';

  @override
  String get sizeLarge => 'Large';

  @override
  String get frequencyOnce => 'One time';

  @override
  String get frequencyWeekly => 'Weekly';

  @override
  String get frequencyBiweekly => 'Biweekly';

  @override
  String get frequencyMonthly => 'Monthly';

  @override
  String get dateLabel => 'Date';

  @override
  String get frequencyLabel => 'Frequency';

  @override
  String get durationLabel => 'Duration';

  @override
  String get roomsLabel => 'Spaces';

  @override
  String roomsCount(int bedrooms, int bathrooms) {
    return '$bedrooms bed / $bathrooms bath';
  }

  @override
  String get bookingSuccessTitle => 'Request sent!';

  @override
  String bookingSuccessSubtitle(String service) {
    return 'We\'ll notify you when $service is accepted.';
  }

  @override
  String get viewMyBookings => 'View my bookings';

  @override
  String get bookingDetailTitle => 'Booking detail';

  @override
  String get noNotesPlaceholder => 'No extra notes';

  @override
  String get assignedCleanerPlaceholder => 'Assigned professional';

  @override
  String get assignedCleanerHint =>
      'You\'ll see the assigned cleaner and profile here once available.';

  @override
  String get upcomingBookings => 'Upcoming';

  @override
  String get pastBookings => 'Past';

  @override
  String get serviceTypeLabel => 'Service type';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusInProgress => 'In progress';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get editProfileTitle => 'Edit information';

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsSubtitle => 'Receive alerts about your services';

  @override
  String get marketingOptIn => 'Offers and promotions';

  @override
  String get marketingSubtitle => 'Get news and discounts';

  @override
  String get myReviews => 'My reviews';

  @override
  String get myReviewsSubtitle => 'Review your past ratings';

  @override
  String get viewAllReviews => 'View all reviews';

  @override
  String get noReviewsYet => 'No reviews yet';

  @override
  String get noReviewsDescription =>
      'When you complete a service, you can rate it here.';

  @override
  String get rateServiceTitle => 'Rate service';

  @override
  String get ratingPromptTitle => 'How was your experience?';

  @override
  String get ratingPromptSubtitle =>
      'Your feedback helps us improve service quality.';

  @override
  String get ratingOptionalComment => 'Comment (optional)';

  @override
  String get ratingCommentHint => 'Tell us about your service experience...';

  @override
  String get submitRating => 'Submit rating';

  @override
  String get updateRating => 'Update rating';

  @override
  String get ratingSuccess => 'Thank you for your rating!';

  @override
  String get genericError => 'An error occurred. Please try again.';

  @override
  String bookingRatedLabel(String stars) {
    return 'Rated: $stars stars';
  }

  @override
  String get bookingAwaitingRating => 'Tap to rate this service';

  @override
  String get rateNow => 'Rate';

  @override
  String get viewRating => 'View';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get cancel => 'Cancel';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get myJobs => 'My jobs';

  @override
  String get postJobTitle => 'Post a job';

  @override
  String get postJobCta => 'Post job';

  @override
  String get postJobHeroTitle => 'Post what you need';

  @override
  String get postJobHeroSubtitle =>
      'Invite pros or receive proposals with better rates.';

  @override
  String get marketplaceHint => 'Pros will apply with their own proposals.';

  @override
  String get openJobsShort => 'Open jobs';

  @override
  String get myJobsSubtitle =>
      'Post jobs, review proposals, and hire your pro.';

  @override
  String get openJobsTitle => 'Open jobs';

  @override
  String get activeJobsTitle => 'Active jobs';

  @override
  String get completedJobsTitle => 'Completed jobs';

  @override
  String get noJobsYet => 'You don\'t have posted jobs yet';

  @override
  String get noJobsDescription =>
      'When you post a job you\'ll see its proposals and status here.';

  @override
  String get jobStepBasics => 'Job basics';

  @override
  String get jobStepProperty => 'Property';

  @override
  String get jobStepBudget => 'Budget & frequency';

  @override
  String get jobStepLocation => 'Location & timing';

  @override
  String get jobStepSummary => 'Summary';

  @override
  String get jobTitleLabel => 'Job title';

  @override
  String get jobTitleHint => 'e.g. Deep clean for 2BR apartment';

  @override
  String get jobDescriptionLabel => 'Description';

  @override
  String get jobDescriptionHint =>
      'Share context, priorities or cleaning products.';

  @override
  String get jobServiceRequired => 'Choose a service type to continue.';

  @override
  String get jobPropertyTitle => 'Property type';

  @override
  String get jobSizeTitle => 'Size';

  @override
  String get jobBudgetTitle => 'Budget';

  @override
  String get jobHourlyRangeLabel => 'Hourly range';

  @override
  String get budgetFrom => 'From';

  @override
  String get budgetTo => 'To';

  @override
  String get budgetFixedLabel => 'Fixed budget';

  @override
  String get jobFrequencyTitle => 'Frequency';

  @override
  String get jobAreaLabel => 'Neighborhood';

  @override
  String get jobAreaHint => 'e.g. Soho, Brooklyn, Downtown';

  @override
  String get jobPreferredDate => 'Preferred date';

  @override
  String get jobPreferredDateHint => 'Optional: when you\'d like to start';

  @override
  String get jobSummaryTitle => 'Review and publish';

  @override
  String get jobTitlePlaceholder => 'Title pending';

  @override
  String get jobAreaPlaceholder => 'Area to define';

  @override
  String get publishJob => 'Publish job';

  @override
  String get jobPublishedSuccess =>
      'Job published. You\'ll get proposals soon.';

  @override
  String get jobDetailTitle => 'Job detail';

  @override
  String get jobNotFound => 'Job not found';

  @override
  String get invitedPros => 'Invited professionals';

  @override
  String get noInvitedYet => 'You haven\'t invited anyone yet.';

  @override
  String get receivedProposals => 'Proposals received';

  @override
  String get proposalDetailTitle => 'Proposal detail';

  @override
  String get noProposalsYet => 'No proposals yet.';

  @override
  String get viewDetails => 'View details';

  @override
  String get shortlistAction => 'Shortlist';

  @override
  String get rejectAction => 'Reject';

  @override
  String get hireAction => 'Hire';

  @override
  String get hireSuccessMessage => 'Pro hired.';

  @override
  String get rateJobCta => 'Rate job';

  @override
  String get ratingAlreadySent => 'You already rated this job.';

  @override
  String get proDeleted => 'Professional unavailable';

  @override
  String get jobToBeScheduled => 'To be scheduled';

  @override
  String proposalsCount(int count) {
    return '$count proposals';
  }

  @override
  String get jobStatusDraft => 'Draft';

  @override
  String get jobStatusOpen => 'Open';

  @override
  String get jobStatusUnderReview => 'Under review';

  @override
  String get jobStatusHired => 'Pro selected';

  @override
  String get jobStatusInProgress => 'In progress';

  @override
  String get jobStatusCompleted => 'Completed';

  @override
  String get jobStatusCancelled => 'Cancelled';

  @override
  String get proposalSubmitted => 'Submitted';

  @override
  String get proposalShortlisted => 'Shortlisted';

  @override
  String get proposalRejected => 'Rejected';

  @override
  String get proposalHired => 'Hired';

  @override
  String get budgetHourly => 'Hourly';

  @override
  String get budgetFixed => 'Fixed price';

  @override
  String budgetRangeLabel(String from, String to) {
    return 'Between \$$from and \$$to per hour';
  }

  @override
  String fixedPriceLabel(String price) {
    return 'Fixed price: \$$price';
  }

  @override
  String get jobCustomTitle => 'Custom job';

  @override
  String get jobCustomDescription => 'Client entered details';

  @override
  String get jobCustomFilled => 'Custom job';

  @override
  String get jobCustomDescriptionFilled => 'Custom description';

  @override
  String get coverDetailSparkling =>
      'I bring my own supplies and focus on leaving every corner spotless.';

  @override
  String get coverExperienceDeep =>
      'Deep clean specialist, focus on kitchen and bathrooms.';

  @override
  String get coverWeeklyCare =>
      'I can keep your home ready every week and coordinate schedules.';

  @override
  String get coverFlexible => 'Flexible hours and adapt to your needs.';

  @override
  String get coverOfficeReset =>
      'Experience with small offices, organize desks and sanitize.';

  @override
  String get searchProsTitle => 'Find professionals';

  @override
  String get searchInviteHint =>
      'Invite pros directly to one of your open jobs.';

  @override
  String get noProsFound => 'No pros match that name or area.';

  @override
  String get inviteToJob => 'Invite to a job';

  @override
  String get viewOpenJobs => 'View open jobs';

  @override
  String get selectJobToInvite => 'Select a job to invite';

  @override
  String inviteSent(String name) {
    return 'Invitation sent to $name';
  }

  @override
  String get noOpenJobsToInvite => 'You have no open jobs to invite.';

  @override
  String get budgetCopyFallback => 'Proposal';

  @override
  String get jobTitleDeepCleanApt => 'Deep clean for 2BR apartment';

  @override
  String get jobDescDeepCleanApt =>
      'Want the kitchen and bathrooms spotless before family visits.';

  @override
  String get jobTitleWeeklyHouse => 'Weekly upkeep for house in Suba';

  @override
  String get jobDescWeeklyHouse =>
      'General clean every week, priority bedrooms and patio.';

  @override
  String get jobTitleOfficeReset => 'Monthly reset for small office';

  @override
  String get jobDescOfficeReset =>
      'Organize desks, clean glass and prep meeting room.';

  @override
  String get rateJobTitle => 'Rate job';

  @override
  String get rateJobShortcut => 'Rate';

  @override
  String get searchProsInviteCta => 'Invite';

  @override
  String get messages => 'Messages';

  @override
  String get noMessagesYet => 'You don\'t have any messages yet';

  @override
  String get noMessagesDescription =>
      'When you receive messages from professionals, they will appear here.';

  @override
  String get activeJob => 'Active job';

  @override
  String get noMessagesInConversation => 'No messages in this conversation';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get noNotificationsYet => 'You don\'t have any notifications';

  @override
  String get noNotificationsDescription =>
      'Notifications about your jobs and proposals will appear here.';

  @override
  String get unreadMessages => 'Unread messages';

  @override
  String get newNotifications => 'New notifications';

  @override
  String get demoMode => 'Demo mode (sample data)';

  @override
  String get demoModeDescription =>
      'Enable to see sample data, disable for empty mode';

  @override
  String get completeProfileTitle => 'Complete your profile';

  @override
  String get completeProfileSubtitleClient =>
      'We need your phone number to coordinate services.';

  @override
  String get completeProfileNameRequired => 'Name is required';

  @override
  String get completeProfilePhone => 'Phone';

  @override
  String get completeProfilePhoneHint => 'E.g: +1 555 123 4567';

  @override
  String get completeProfilePhoneRequired =>
      'Phone is required to coordinate services';

  @override
  String get completeProfileSave => 'Save and continue';

  @override
  String get completeProfileExitTitle => 'Exit without completing?';

  @override
  String get completeProfileExitMessage =>
      'If you exit now, you\'ll need to complete your profile next time you sign in.';

  @override
  String get phoneValidationInvalid => 'Enter a 10-digit number (numbers only)';

  @override
  String get phoneValidationRequired => 'Phone number is required';

  @override
  String get phonePrefix => '+57';

  @override
  String get mfaEnrollmentTitle => 'Security verification';

  @override
  String get mfaEnrollmentSubtitle =>
      'For your security, we\'ll verify your phone number with an SMS code.';

  @override
  String get mfaSendCode => 'Send code';

  @override
  String get mfaResendCode => 'Resend code';

  @override
  String mfaCodeSent(String phone) {
    return 'Code sent to $phone';
  }

  @override
  String get mfaEnterCode => 'Enter the 6-digit code';

  @override
  String get mfaCodeHint => 'Verification code';

  @override
  String get mfaVerify => 'Verify';

  @override
  String get mfaVerifying => 'Verifying...';

  @override
  String get mfaSuccess => 'Phone verified successfully';

  @override
  String get mfaErrorInvalidCode => 'Invalid code. Please try again.';

  @override
  String get mfaErrorExpiredCode => 'Code has expired. Request a new one.';

  @override
  String get mfaErrorTooManyRequests =>
      'Too many attempts. Please wait a few minutes.';

  @override
  String get mfaErrorGeneric => 'Verification error. Please try again.';

  @override
  String get mfaSignInTitle => 'Verification required';

  @override
  String get mfaSignInSubtitle =>
      'We sent an SMS code to your registered phone.';

  @override
  String get mfaPhoneLabel => 'Colombian phone number';

  @override
  String get mfaPhoneHint => '3001234567';

  @override
  String get mfaRequiredMessage => 'You must verify your phone to continue';

  @override
  String get mfaNotSupported =>
      'This account has two-factor authentication enabled. Please contact support to disable it.';

  @override
  String get avatarSelectTitle => 'Select your avatar';

  @override
  String get avatarChange => 'Change avatar';

  @override
  String get avatarSelected => 'Avatar selected';

  @override
  String get editJob => 'Edit job';

  @override
  String get deleteJob => 'Delete job';

  @override
  String get editJobTitle => 'Edit job';

  @override
  String get deleteJobTitle => 'Delete job';

  @override
  String get deleteJobConfirmation =>
      'Are you sure you want to delete this job? This action cannot be undone.';

  @override
  String get delete => 'Delete';

  @override
  String get jobDeletedSuccess => 'Job deleted successfully';

  @override
  String get jobUpdatedSuccess => 'Job updated successfully';

  @override
  String get jobCannotBeModified => 'This job can no longer be modified';
}
