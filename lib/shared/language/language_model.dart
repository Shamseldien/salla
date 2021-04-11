class AppLanguageModel {
  String title;
  String subtitle1;
  String subtitle2;
  String title2;
  String subtitle12;
  String subtitle22;
  String title3;
  String subtitle13;
  String subtitle23;
  String title4;
  String subtitle14;
  String subtitle24;
  String skip;
  String welcome;
  String signInTitle;
  String userName;
  String userNameError;
  String passError;
  String password;
  String email;
  String emailError;
  String member;
  String phone;
  String phoneError;
  String signIn;
  String newAccount;
  String signUp;
  String salla;
  String discover;
  String newArrival;
  String home;
  String cart;
  String categories;
  String settings;
  String sale;

  AppLanguageModel(
      {this.title,
        this.subtitle1,
        this.subtitle2,
        this.title2,
        this.subtitle12,
        this.subtitle22,
        this.title3,
        this.subtitle13,
        this.subtitle23,
        this.title4,
        this.subtitle14,
        this.subtitle24,
        this.skip,
        this.welcome,
        this.signInTitle,
        this.userName,
        this.userNameError,
        this.passError,
        this.password,
        this.email,
        this.emailError,
        this.member,
        this.phone,
        this.phoneError,
        this.signIn,
        this.newAccount,
        this.categories,
        this.home,
        this.cart,
        this.discover,
        this.newArrival,
        this.salla,
        this.settings,
        this.sale,
        this.signUp});

  AppLanguageModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle1 = json['subtitle1'];
    subtitle2 = json['subtitle2'];
    title2 = json['title2'];
    subtitle12 = json['subtitle12'];
    subtitle22 = json['subtitle22'];
    title3 = json['title3'];
    subtitle13 = json['subtitle13'];
    subtitle23 = json['subtitle23'];
    title4 = json['title4'];
    subtitle14 = json['subtitle14'];
    subtitle24 = json['subtitle24'];
    skip = json['skip'];
    welcome = json['welcome'];
    signInTitle = json['signInTitle'];
    userName = json['userName'];
    userNameError = json['userNameError'];
    passError = json['passError'];
    password = json['password'];
    email = json['email'];
    emailError = json['emailError'];
    member = json['member'];
    phone = json['phone'];
    phoneError = json['phoneError'];
    signIn = json['signIn'];
    newAccount = json['newAccount'];
    signUp = json['signUp'];

    salla = json['salla'];
    discover = json['discover'];
    newArrival = json['newArrival'];
    home = json['home'];
    cart = json['cart'];
    categories = json['categories'];
    settings = json['settings'];
    sale = json['sale'];

  }

}
