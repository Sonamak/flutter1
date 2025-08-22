class CountryCode {
  final String name;
  final String dial;
  const CountryCode(this.name, this.dial);
}

class CountryCodes {
  static const List<CountryCode> all = [
    CountryCode('United States', '1'),
    CountryCode('Canada', '1'),
    CountryCode('Egypt', '20'),
    CountryCode('United Kingdom', '44'),
    CountryCode('Germany', '49'),
    CountryCode('France', '33'),
    CountryCode('Turkey', '90'),
    CountryCode('Saudi Arabia', '966'),
    CountryCode('United Arab Emirates', '971'),
    CountryCode('India', '91'),
    CountryCode('Pakistan', '92'),
    CountryCode('Bangladesh', '880'),
    CountryCode('Nigeria', '234'),
    CountryCode('South Africa', '27'),
    CountryCode('Spain', '34'),
    CountryCode('Italy', '39'),
    CountryCode('Brazil', '55'),
    CountryCode('Mexico', '52'),
    CountryCode('Argentina', '54'),
    CountryCode('Russia', '7'),
    CountryCode('China', '86'),
    CountryCode('Japan', '81'),
    CountryCode('Kuwait', '965'),
    CountryCode('Qatar', '974'),
    CountryCode('Oman', '968'),
    CountryCode('Bahrain', '973'),
    CountryCode('Jordan', '962'),
    CountryCode('Lebanon', '961'),
    CountryCode('Iraq', '964'),
    CountryCode('Morocco', '212'),
    CountryCode('Algeria', '213'),
    CountryCode('Tunisia', '216'),
    CountryCode('Libya', '218'),
  ];
}
