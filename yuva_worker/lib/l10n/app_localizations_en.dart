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
  String get onboardingWorkerTitle1 => 'Find cleaning jobs near you';

  @override
  String get onboardingWorkerTitle2 => 'Choose jobs that match your rate';

  @override
  String get onboardingWorkerTitle3 =>
      'Build your reputation with great results';

  @override
  String get onboardingWorkerDesc1 =>
      'Connect with clients near your work area';

  @override
  String get onboardingWorkerDesc2 =>
      'Propose your rates and conditions, you decide';

  @override
  String get onboardingWorkerDesc3 =>
      'Each completed job improves your professional profile';

  @override
  String get continueWithEmail => 'Continue with email';

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
  String get lastName => 'Last name';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get home => 'Home';

  @override
  String get jobs => 'Jobs';

  @override
  String get profile => 'Profile';

  @override
  String get language => 'Language';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'English';

  @override
  String get skip => 'Skip';

  @override
  String get logout => 'Log out';

  @override
  String get recommendedJobs => 'Recommended jobs for you';

  @override
  String get invitations => 'Invitations';

  @override
  String get invitation => 'Invitation';

  @override
  String get newJobs => 'New';

  @override
  String get myProposals => 'My proposals';

  @override
  String get contracts => 'Contracts';

  @override
  String get noJobsAvailable => 'No jobs available';

  @override
  String get noJobsDescription =>
      'When there are jobs matching your profile, you\'ll see them here.';

  @override
  String get jobDetailTitle => 'Job detail';

  @override
  String get propertyDetails => 'Property details';

  @override
  String get budgetDetails => 'Budget details';

  @override
  String get prepareProposal => 'Prepare proposal';

  @override
  String get proposalFeatureComingSoon =>
      'Proposal functionality will be implemented in a future phase';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get baseHourlyRate => 'Base hourly rate';

  @override
  String get baseArea => 'Base area';

  @override
  String get offeredServices => 'Offered services';

  @override
  String rating(String rating, int count) {
    return '$rating ★ ($count reviews)';
  }

  @override
  String get saveChanges => 'Save changes';

  @override
  String get cancel => 'Cancel';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get back => 'Back';

  @override
  String perHour(String price) {
    return '$price/hour';
  }

  @override
  String fixedBudget(String price) {
    return 'Fixed budget: $price';
  }

  @override
  String hourlyRange(String from, String to) {
    return '$from - $to / hour';
  }

  @override
  String get serviceStandard => 'Standard clean';

  @override
  String get serviceDeepClean => 'Deep clean';

  @override
  String get serviceMoveOut => 'Move-out clean';

  @override
  String get serviceOffice => 'Office/Shop';

  @override
  String get frequencyOnce => 'One time';

  @override
  String get frequencyWeekly => 'Weekly';

  @override
  String get frequencyBiweekly => 'Biweekly';

  @override
  String get frequencyMonthly => 'Monthly';

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
  String get bedrooms => 'Bedrooms';

  @override
  String get bathrooms => 'Bathrooms';

  @override
  String roomsCount(int bedrooms, int bathrooms) {
    return '$bedrooms bed / $bathrooms bath';
  }

  @override
  String get preferredDate => 'Preferred date';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get createMyProfile => 'Create my profile';

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
  String get jobTitlePostMoveCondo => 'Post-move clean for furnished condo';

  @override
  String get jobDescPostMoveCondo =>
      'Need deep clean after moving, including windows.';

  @override
  String get jobTitleBiweeklyStudio => 'Biweekly clean for studio';

  @override
  String get jobDescBiweeklyStudio =>
      'Basic upkeep every two weeks for 1BR studio.';

  @override
  String get area => 'Area';

  @override
  String get frequency => 'Frequency';

  @override
  String get description => 'Description';

  @override
  String get messages => 'Messages';

  @override
  String get noMessagesYet => 'You don\'t have any messages yet';

  @override
  String get noMessagesDescription =>
      'When you receive messages from clients, they will appear here.';

  @override
  String get activeJob => 'Active job';

  @override
  String get noMessagesInConversation => 'No messages in this conversation';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get notifications => 'Notifications';

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get noNotificationsYet => 'You don\'t have any notifications';

  @override
  String get noNotificationsDescription =>
      'Notifications about your proposals and jobs will appear here.';

  @override
  String get unreadMessages => 'Unread messages';

  @override
  String get newNotifications => 'New notifications';

  @override
  String get cityOrZone => 'City or zone';

  @override
  String get cityOrZoneHint => 'E.g: Bogotá, Chapinero';

  @override
  String get demoMode => 'Demo mode (sample data)';

  @override
  String get demoModeDescription =>
      'Enable to see sample data, disable for empty mode';

  @override
  String get completeProfileTitle => 'Complete your profile';

  @override
  String get completeProfileSubtitle =>
      'We need some additional information so you can receive jobs.';

  @override
  String get completeProfileNameRequired => 'Name is required';

  @override
  String get completeProfileZoneRequired => 'Work zone is required';

  @override
  String get completeProfileRateHint => 'E.g: 45000';

  @override
  String get completeProfileRateRequired => 'Hourly rate is required';

  @override
  String get completeProfileRateInvalid => 'Enter a valid rate greater than 0';

  @override
  String get completeProfileSave => 'Save and continue';

  @override
  String get completeProfileExitTitle => 'Exit without completing?';

  @override
  String get completeProfileExitMessage =>
      'If you exit now, you\'ll need to complete your profile next time you sign in.';

  @override
  String get avatarSelectTitle => 'Select your avatar';

  @override
  String get avatarChange => 'Change avatar';

  @override
  String get avatarSelected => 'Avatar selected';
}
