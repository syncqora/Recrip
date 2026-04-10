/// Centralized user-facing strings used across the app.
///
/// Note: this file intentionally focuses on UI labels/placeholders and other
/// user-visible text (not mock table data or asset paths).
abstract final class AppStrings {
  AppStrings._();

  // Common
  static const String addMember = 'Add Member';
  static const String status = 'Status';
  static const String plan = 'Plan';
  static const String clearFilters = 'Clear Filters';
  static const String cancel = 'Cancel';
  static const String save = 'Save';

  static const String searchByNameOrPhoneShort = 'Search by name or phone';
  static const String searchByNameOrPhoneLong =
      'Search by name or phone number';

  static const List<String> commonPlanOptions = [
    'Monthly',
    'Quarterly',
    'Yearly',
  ];
  static const String monthly = 'Monthly';

  // Table headers
  static const String tableHeaderName = 'Name';
  static const String tableHeaderPhoneNumber = 'Phone Number';
  static const String tableHeaderEmailAddress = 'Email Address';
  static const String tableHeaderExpiryDate = 'Expiry Date';
  static const String tableHeaderDaysLeft = 'Days Left';
  static const String tableHeaderAction = 'Action';
  static const String tableHeaderPlanName = 'Plan Name';
  static const String tableHeaderTotalMembers = 'Total Members';
  static const String tableHeaderDuration = 'Duration';
  static const String tableHeaderPrice = 'Price';
  static const String tableHeaderActiveMembers = 'Active Members';
  static const String tableHeaderRevenue = 'Revenue';

  // Members
  static const String membersTitle = 'Members';
  static const String membersSubtitle =
      'Manage all your members and their subscriptions';
  static const List<String> membersStatusOptions = [
    'Active',
    'Expiring',
    'Expired',
  ];

  static const String paginationMembers = 'Showing 1-10 of 248 members';

  // Renewals
  static const String renewalsTitle = 'Renewals';
  static const String renewalsSubtitle =
      'Track and manage upcoming and missed renewals';
  static const List<String> renewalsStatusTabs = [
    'All',
    'Expiring',
    'Expired',
    'Renewed',
  ];

  static const String selectDate = 'Select date';
  static const String selectDates = 'Select Dates';

  // Status pill labels
  static const String active = 'Active';
  static const String expiring = 'Expiring';
  static const String expired = 'Expired';
  static const String renewed = 'Renewed';

  static String reminderSentTo(String name) => 'Reminder sent to $name';

  // Dashboard navigation + common labels
  static const String dashboardTitle = 'Dashboard';
  static const String manageEverythingHere = 'Manage everything here';
  static const String logout = 'Logout';

  static const String navDashboard = 'Dashboard';
  static const String navMembers = 'Members';
  static const String navSubscriptions = 'Subscriptions';
  static const String navRenewals = 'Renewals';
  static const String navReminders = 'Reminders';
  static const String navReports = 'Reports';
  static const String navSettings = 'Settings';
  static const String navPayments = 'Payments';

  // Dashboard summary cards
  static const String summaryActiveMembers = 'Active Members';
  static const String summaryExpiring7Days = 'Expiring (7 Days)';
  static const String summaryRenewedThisMonth = 'Renewed (This Month)';

  // Dashboard renewals section
  static const String actionRequiredRenewals = 'Action Required - Renewals';
  static const String viewAllRenewals = 'View All Renewals';
  static const String tableHeaderExpiry = 'Expiry';

  // Dashboard AI Insights
  static const String aiInsightsTitle = 'AI Insights';
  static const String aiInsightsYouMayLosePrefix = 'You may lose ';
  static const String aiInsightsThisWeekSuffix =
      ' this week due to 6 memberships expiring. Sending reminders today could recover ';
  static const String aiInsightsMessageEnding = '.';
  static const String aiInsightsLostAmount = '₹18,000';
  static const String aiInsightsRecoveredAmount = '₹12,500';
  static const String aiInsightsFullMessage =
      'You may lose ₹18,000 this week due to 6 memberships expiring. Sending reminders today could recover ₹12,500.';
  static const String sendRemindersNow = 'Send Reminders Now';

  // Dashboard Revenue insights
  static const String revenueInsightsTitle = 'Revenue Insights';
  static const String revenueRecoveredLabel = 'Revenue Recovered';
  static const String revenueLostLabel = 'Revenue Lost';

  // Dashboard footer / toasts
  static const String footerAllRightsReserved = '© 2026 All rights reserved';
  static const String remindersSentToastTitle = 'Reminders Sent';

  // Authentication
  static const String loginTitle = 'Login';
  static const String userNameLabel = 'User Name';
  static const String enterUsernameHint = 'Enter username';
  static const String loginEmailLabel = 'Email';
  static const String loginEmailHint = 'name@example.com';
  static const String loginEmailInvalid = 'Enter a valid email address';
  static const String loginEmailRequired = 'Enter your email address';
  static const String loginPasswordRequired = 'Enter your password';
  static const String loginPasswordTooShort =
      'Password must be at least 8 characters';
  static const String loginPasswordWeak =
      'Use upper & lower case, a number, and a special character';
  static const String passwordLabel = 'Password';
  static const String enterPasswordHint = 'Enter Password';
  static const String forgotPasswordTitle = 'Forgot Password?';
  static const String emailOrPhoneLabel = 'Email Address/Phone Number';
  static const String enterEmailOrPhoneHint =
      'Enter Email Address /Phone Number';
  static const String otpSentToEmailOrPhone =
      'OTP will be sent to the\nEmail Address/Phone Number';
  static const String getOtpText = 'Get OTP';
  static const String backText = 'Back';
  static const String newPasswordLabel = 'New Password';
  static const String enterNewPasswordHint = 'Enter New Password';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String resetPasswordTitle = 'Reset Password';
  static const String enterOtpLabel = 'Enter OTP';
  static const String resendOtpText = 'Resend OTP';
  static const String verifyText = 'Verify';

  // Support footer
  static const String anySupportRequiredText = 'Any support required? ';
  static const String reachOutToUsText = 'Reach out to us';

  // Settings
  static const String settingsTitle = 'Settings';
  static const String settingsSubtitle =
      'Manage your business, preferences, and account';
  static const String settingsProfileTabLabel = 'Profile';
  static const String settingsLoginSecurityTabLabel = 'Login & Security';
  static const String businessLogoLabel = 'Business Logo';
  static const String businessNameLabel = 'Business Name';
  static const String businessNameDefault = 'SaaS';
  static const String changePasswordLabel = 'Change Password';
  static const String currentPasswordLabel = 'Current Password';
  static const String enterCurrentPasswordHint = 'Enter Current Password';
  static const String confirmNewPasswordLabel = 'Confirm New Password';
  static const String confirmNewPasswordHint = 'Confirm New Password';

  // Reminders
  static const String remindersTitle = 'Reminders';
  static const String remindersSubtitle =
      'Automate renewal reminders across WhatsApp and Email';
  static const String createReminderRuleLabel = 'Create Reminder Rule';
  static const String reminderRulesTitle = 'Reminder Rules';
  static const String reminderRulesSubtitle =
      'Define when and how reminders are sent automatically';
  static const String messageTemplatesTitle = 'Message Templates';
  static const String messageTemplatesSubtitle =
      'Customize the message sent to members.';
  static const String createTemplateLabel = 'Create Template';
  static const String triggerLabel = 'Trigger';
  static const String timingLabel = 'Timing';
  static const String audienceLabel = 'Audience';
  static const String channelLabel = 'Channel';
  static const String reminderTriggerBeforeExpiry = 'Before Expiry';
  static const String reminderTiming7DaysBefore = '7 Days before';
  static const String reminderAudienceAllMembers = 'All Members';
  static const String inactive = 'Inactive';

  // Reminder dialogs/prompts
  static const String editRuleTitle = 'Edit Rule';
  static const String editTemplateTitle = 'Edit Template';
  static const String deleteRuleTitle = 'Delete Rule?';
  static const String deleteTemplateTitle = 'Delete Template?';
  static const String reminderRuleDeletePrompt =
      'You want to delete this reminder rule.';
  static const String reminderTemplateDeletePrompt =
      'You want to delete this message template.';
  static const String ruleDeletedTitle = 'Rule Deleted';
  static const String templateDeletedTitle = 'Template Deleted';

  // Reports
  static const String reportsTitle = 'Reports';
  static const String reportsSubtitle =
      'Analyze renewals, revenue, and performance';
  static const String revenueAnalysisTitle = 'Revenue Analysis';
  static const String exportLabel = 'Export';
  static const String thisMonthLabel = 'This Month';
  static const String lastMonthLabel = 'Last Month';
  static const String lastQuarterLabel = 'Last Quarter';
  static const String totalRenewalsTitle = 'Total Renewals';
  static const String missedRenewalsTitle = 'Missed Renewals';
  static const String renewalRateTitle = 'Renewal Rate';
  static const String revenueRecoveredTitle = 'Revenue Recovered';
  static const String successfulRenewalsDescription = 'Successful renewals';
  static const String notRenewedAfterExpiryDescription =
      'Not renewed after expiry';
  static const String renewalsPlusExpiringDescription = 'Renewals + Expiring';
  static const String fromRenewedSubscriptionsDescription =
      'From renewed subscriptions';
  static const String missedMobileLabel = 'Missed';
  static const String rateMobileLabel = 'Rate';

  // Subscriptions
  static const String subscriptionsTitle = 'Subscriptions';
  static const String subscriptionsSubtitle =
      'Manage subscription plans and pricing';
  static const String membersEmptyState =
      'No members yet. Pull to refresh or add a member.';
  static const String subscriptionsEmptyState =
      'No subscription plans yet. Pull to refresh or tap Retry after an error.';
  static const String createPlanLabel = 'Create Plan';
  static const String planNameHeader = 'Plan Name';
  static const String durationHeader = 'Duration';
  static const String priceHeader = 'Price';
  static const String activeMembersHeader = 'Active Members';
  static const String actionHeader = 'Action';
  static const String planCreatedSuccessfullyTitle =
      'Plan Created Successfully!';
  static const String planDeletedTitle = 'Plan Deleted';
}
