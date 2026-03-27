import 'package:uuid/uuid.dart';
import '../models/models.dart';

final _uuid = const Uuid();

class SeedData {
  static List<Country> get countries => _countries;
  static List<Region> get regions => _regions;
  static List<Language> get languages => _languages;
  static List<Island> get islands => _islands;
  static List<RegionLanguage> get regionLanguages => _regionLanguages;

  static final List<Country> _countries = [
    Country(id: _uuid.v4(), name: 'Algérie', flagUrl: 'https://flagcdn.com/w320/dz.png', capital: 'Alger'),
    Country(id: _uuid.v4(), name: 'Angola', flagUrl: 'https://flagcdn.com/w320/ao.png', capital: 'Luanda'),
    Country(id: _uuid.v4(), name: 'Bénin', flagUrl: 'https://flagcdn.com/w320/bj.png', capital: 'Porto-Novo'),
    Country(id: _uuid.v4(), name: 'Botswana', flagUrl: 'https://flagcdn.com/w320/bw.png', capital: 'Gaborone'),
    Country(id: _uuid.v4(), name: 'Burkina Faso', flagUrl: 'https://flagcdn.com/w320/bf.png', capital: 'Ouagadougou'),
    Country(id: _uuid.v4(), name: 'Burundi', flagUrl: 'https://flagcdn.com/w320/bi.png', capital: 'Gitega'),
    Country(id: _uuid.v4(), name: 'Cabo Verde', flagUrl: 'https://flagcdn.com/w320/cv.png', capital: 'Praia'),
    Country(id: _uuid.v4(), name: 'Cameroun', flagUrl: 'https://flagcdn.com/w320/cm.png', capital: 'Yaoundé'),
    Country(id: _uuid.v4(), name: 'République Centrafricaine', flagUrl: 'https://flagcdn.com/w320/cf.png', capital: 'Bangui'),
    Country(id: _uuid.v4(), name: 'Tchad', flagUrl: 'https://flagcdn.com/w320/td.png', capital: "N'Djaména"),
    Country(id: _uuid.v4(), name: 'Comores', flagUrl: 'https://flagcdn.com/w320/km.png', capital: 'Moroni'),
    Country(id: _uuid.v4(), name: 'République du Congo', flagUrl: 'https://flagcdn.com/w320/cg.png', capital: 'Brazzaville'),
    Country(id: _uuid.v4(), name: 'République Démocratique du Congo', flagUrl: 'https://flagcdn.com/w320/cd.png', capital: 'Kinshasa'),
    Country(id: _uuid.v4(), name: 'Côte d\'Ivoire', flagUrl: 'https://flagcdn.com/w320/ci.png', capital: 'Yamoussoukro'),
    Country(id: _uuid.v4(), name: 'Djibouti', flagUrl: 'https://flagcdn.com/w320/dj.png', capital: 'Djibouti'),
    Country(id: _uuid.v4(), name: 'Égypte', flagUrl: 'https://flagcdn.com/w320/eg.png', capital: 'Le Caire'),
    Country(id: _uuid.v4(), name: 'Guinée Équatoriale', flagUrl: 'https://flagcdn.com/w320/gq.png', capital: 'Malabo'),
    Country(id: _uuid.v4(), name: 'Érythrée', flagUrl: 'https://flagcdn.com/w320/er.png', capital: 'Asmara'),
    Country(id: _uuid.v4(), name: 'Eswatini', flagUrl: 'https://flagcdn.com/w320/sz.png', capital: 'Mbabane'),
    Country(id: _uuid.v4(), name: 'Éthiopie', flagUrl: 'https://flagcdn.com/w320/et.png', capital: 'Addis-Abeba'),
    Country(id: _uuid.v4(), name: 'Gabon', flagUrl: 'https://flagcdn.com/w320/ga.png', capital: 'Libreville'),
    Country(id: _uuid.v4(), name: 'Gambie', flagUrl: 'https://flagcdn.com/w320/gm.png', capital: 'Banjul'),
    Country(id: _uuid.v4(), name: 'Ghana', flagUrl: 'https://flagcdn.com/w320/gh.png', capital: 'Accra'),
    Country(id: _uuid.v4(), name: 'Guinée', flagUrl: 'https://flagcdn.com/w320/gn.png', capital: 'Conakry'),
    Country(id: _uuid.v4(), name: 'Guinée-Bissau', flagUrl: 'https://flagcdn.com/w320/gw.png', capital: 'Bissau'),
    Country(id: _uuid.v4(), name: 'Kenya', flagUrl: 'https://flagcdn.com/w320/ke.png', capital: 'Nairobi'),
    Country(id: _uuid.v4(), name: 'Lesotho', flagUrl: 'https://flagcdn.com/w320/ls.png', capital: 'Maseru'),
    Country(id: _uuid.v4(), name: 'Libéria', flagUrl: 'https://flagcdn.com/w320/lr.png', capital: 'Monrovia'),
    Country(id: _uuid.v4(), name: 'Libye', flagUrl: 'https://flagcdn.com/w320/ly.png', capital: 'Tripoli'),
    Country(id: _uuid.v4(), name: 'Madagascar', flagUrl: 'https://flagcdn.com/w320/mg.png', capital: 'Antananarivo'),
    Country(id: _uuid.v4(), name: 'Malawi', flagUrl: 'https://flagcdn.com/w320/mw.png', capital: 'Lilongwe'),
    Country(id: _uuid.v4(), name: 'Mali', flagUrl: 'https://flagcdn.com/w320/ml.png', capital: 'Bamako'),
    Country(id: _uuid.v4(), name: 'Mauritanie', flagUrl: 'https://flagcdn.com/w320/mr.png', capital: 'Nouakchott'),
    Country(id: _uuid.v4(), name: 'Maurice', flagUrl: 'https://flagcdn.com/w320/mu.png', capital: 'Port-Louis'),
    Country(id: _uuid.v4(), name: 'Maroc', flagUrl: 'https://flagcdn.com/w320/ma.png', capital: 'Rabat'),
    Country(id: _uuid.v4(), name: 'Mozambique', flagUrl: 'https://flagcdn.com/w320/mz.png', capital: 'Maputo'),
    Country(id: _uuid.v4(), name: 'Namibie', flagUrl: 'https://flagcdn.com/w320/na.png', capital: 'Windhoek'),
    Country(id: _uuid.v4(), name: 'Niger', flagUrl: 'https://flagcdn.com/w320/ne.png', capital: 'Niamey'),
    Country(id: _uuid.v4(), name: 'Nigéria', flagUrl: 'https://flagcdn.com/w320/ng.png', capital: 'Abuja'),
    Country(id: _uuid.v4(), name: 'Rwanda', flagUrl: 'https://flagcdn.com/w320/rw.png', capital: 'Kigali'),
    Country(id: _uuid.v4(), name: 'São Tomé-et-Príncipe', flagUrl: 'https://flagcdn.com/w320/st.png', capital: 'São Tomé'),
    Country(id: _uuid.v4(), name: 'Sénégal', flagUrl: 'https://flagcdn.com/w320/sn.png', capital: 'Dakar'),
    Country(id: _uuid.v4(), name: 'Seychelles', flagUrl: 'https://flagcdn.com/w320/sc.png', capital: 'Victoria'),
    Country(id: _uuid.v4(), name: 'Sierra Leone', flagUrl: 'https://flagcdn.com/w320/sl.png', capital: 'Freetown'),
    Country(id: _uuid.v4(), name: 'Somalie', flagUrl: 'https://flagcdn.com/w320/so.png', capital: 'Mogadiscio'),
    Country(id: _uuid.v4(), name: 'Afrique du Sud', flagUrl: 'https://flagcdn.com/w320/za.png', capital: 'Pretoria'),
    Country(id: _uuid.v4(), name: 'Soudan du Sud', flagUrl: 'https://flagcdn.com/w320/ss.png', capital: 'Djouba'),
    Country(id: _uuid.v4(), name: 'Soudan', flagUrl: 'https://flagcdn.com/w320/sd.png', capital: 'Khartoum'),
    Country(id: _uuid.v4(), name: 'Tanzanie', flagUrl: 'https://flagcdn.com/w320/tz.png', capital: 'Dodoma'),
    Country(id: _uuid.v4(), name: 'Togo', flagUrl: 'https://flagcdn.com/w320/tg.png', capital: 'Lomé'),
    Country(id: _uuid.v4(), name: 'Tunisie', flagUrl: 'https://flagcdn.com/w320/tn.png', capital: 'Tunis'),
    Country(id: _uuid.v4(), name: 'Ouganda', flagUrl: 'https://flagcdn.com/w320/ug.png', capital: 'Kampala'),
    Country(id: _uuid.v4(), name: 'Zambie', flagUrl: 'https://flagcdn.com/w320/zm.png', capital: 'Lusaka'),
    Country(id: _uuid.v4(), name: 'Zimbabwe', flagUrl: 'https://flagcdn.com/w320/zw.png', capital: 'Harare'),
  ];

  static String _getCountryId(String name) {
    return _countries.firstWhere((c) => c.name == name).id;
  }

  static final List<Language> _languages = [
    Language(id: _uuid.v4(), name: 'Français', type: 'officielle'),
    Language(id: _uuid.v4(), name: 'Arabe', type: 'officielle'),
    Language(id: _uuid.v4(), name: 'Anglais', type: 'officielle'),
    Language(id: _uuid.v4(), name: 'Portugais', type: 'officielle'),
    Language(id: _uuid.v4(), name: 'Espagnol', type: 'officielle'),
    Language(id: _uuid.v4(), name: 'Swahili', type: 'officielle'),
    Language(id: _uuid.v4(), name: 'Amharique', type: 'officielle'),
    Language(id: _uuid.v4(), name: 'Hausa', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Yoruba', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Igbo', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Zoulou', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Xhosa', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Afrikaans', type: 'officielle'),
    Language(id: _uuid.v4(), name: 'Somali', type: 'officielle'),
    Language(id: _uuid.v4(), name: 'Tigrinya', type: 'officielle'),
    Language(id: _uuid.v4(), name: 'Malagasy', type: 'officielle'),
    Language(id: _uuid.v4(), name: 'Kinyarwanda', type: 'officielle'),
    Language(id: _uuid.v4(), name: 'Kirundi', type: 'officielle'),
    Language(id: _uuid.v4(), name: 'Lingala', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Kikongo', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Tshiluba', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Bambara', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Wolof', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Peul', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Bérabère', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Créole', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Berbère', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Oromo', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Luganda', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Sesotho', type: 'officielle'),
    Language(id: _uuid.v4(), name: 'Setswana', type: 'officielle'),
    Language(id: _uuid.v4(), name: 'Shona', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Ndebele', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Chewa', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Twi', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Ewe', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Dagbani', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Mandarin', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Tonga', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Bemba', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Mooré', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Dioula', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Sango', type: 'officielle'),
    Language(id: _uuid.v4(), name: 'Comorien', type: 'officielle'),
    Language(id: _uuid.v4(), name: 'Mauricien Créole', type: 'traditionnelle'),
    Language(id: _uuid.v4(), name: 'Tamazight', type: 'officielle'),
  ];

  static final List<Region> _regions = () {
    final List<Region> result = [];
    void addRegions(String countryName, List<String> regionNames) {
      final countryId = _getCountryId(countryName);
      for (final name in regionNames) {
        result.add(Region(id: _uuid.v4(), name: name, countryId: countryId));
      }
    }

    addRegions('Algérie', ['Alger', 'Oran', 'Constantine', 'Annaba', 'Blida', 'Sétif', 'Tlemcen', 'Béjaïa', 'Biskra', 'Tamanrasset']);
    addRegions('Angola', ['Luanda', 'Benguela', 'Huambo', 'Lobito', 'Cabinda', 'Huíla', 'Malanje', 'Uíge']);
    addRegions('Bénin', ['Littoral', 'Atlantique', 'Ouémé', 'Borgou', 'Zou', 'Collines', 'Atacora', 'Mono']);
    addRegions('Botswana', ['Gaborone', 'Francistown', 'Maun', 'Kasane', 'Molepolole', 'Serowe', 'Selebi-Phikwe']);
    addRegions('Burkina Faso', ['Centre', 'Hauts-Bassins', 'Boucle du Mouhoun', 'Sahel', 'Nord', 'Plateau-Central', 'Centre-Ouest', 'Est']);
    addRegions('Burundi', ['Bujumbura Mairie', 'Gitega', 'Muyinga', 'Ngozi', 'Ruyigi', 'Cankuzo', 'Kirundo']);
    addRegions('Cabo Verde', ['Santiago', 'São Vicente', 'Santo Antão', 'Fogo', 'Sal', 'Boa Vista', 'Maio']);
    addRegions('Cameroun', ['Centre', 'Littoral', 'Ouest', 'Nord', 'Sud', 'Est', 'Adamaoua', 'Nord-Ouest', 'Sud-Ouest', 'Extrême-Nord']);
    addRegions('République Centrafricaine', ['Bangui', 'Ouham-Pendé', 'Nana-Mambéré', 'Haute-Kotto', 'Mbomou', 'Basse-Kotto', 'Sangha-Mbaéré']);
    addRegions('Tchad', ['N\'Djaména', 'Logone', 'Chari-Baguirmi', 'Mayo-Kebbi', 'Ouaddaï', 'Batha', 'Kanem', 'Lac']);
    addRegions('Comores', ['Grande Comore', 'Anjouan', 'Mohéli']);
    addRegions('République du Congo', ['Brazzaville', 'Pointe-Noire', 'Pool', 'Bouenza', 'Kouilou', 'Likouala', 'Sangha']);
    addRegions('République Démocratique du Congo', ['Kinshasa', 'Haut-Katanga', 'Kongo Central', 'Nord-Kivu', 'Sud-Kivu', 'Kasaï', 'Équateur', 'Maniema', 'Tshopo', 'Lualaba']);
    addRegions('Côte d\'Ivoire', ['Abidjan', 'Yamoussoukro', 'Bouaké', 'Daloa', 'Korhogo', 'San Pedro', 'Man', 'Gagnoa']);
    addRegions('Djibouti', ['Djibouti', 'Ali Sabieh', 'Tadjourah', 'Obock', 'Dikhil', 'Arta']);
    addRegions('Égypte', ['Le Caire', 'Alexandrie', 'Gizeh', 'Louxor', 'Assouan', 'Charm el-Cheikh', 'Port-Saïd', 'Suez']);
    addRegions('Guinée Équatoriale', ['Bioko Norte', 'Bioko Sur', 'Litoral', 'Centro Sur', 'Kié-Ntem', 'Wele-Nzas', 'Annobón']);
    addRegions('Érythrée', ['Asmara', 'Maekel', 'Debub', 'Gash-Barka', 'Anseba', 'Semien-Keih-Bahri', 'Debubawi-Keih-Bahri']);
    addRegions('Eswatini', ['Hhohho', 'Manzini', 'Lubombo', 'Shiselweni']);
    addRegions('Éthiopie', ['Addis-Abeba', 'Oromia', 'Amhara', 'Tigray', 'SNNPR', 'Somali', 'Afar', 'Harari', 'Dire Dawa', 'Gambela']);
    addRegions('Gabon', ['Estuaire', 'Haut-Ogooué', 'Moyen-Ogooué', 'Ngounié', 'Nyanga', 'Ogooué-Ivindo', 'Ogooué-Lolo', 'Ogooué-Maritime', 'Woleu-Ntem']);
    addRegions('Gambie', ['Banjul', 'Kanifing', 'Brikama', 'Mansa Konko', 'Kerewan', 'Kuntaur', 'Janjanbureh', 'Basse']);
    addRegions('Ghana', ['Greater Accra', 'Ashanti', 'Western', 'Eastern', 'Northern', 'Volta', 'Upper East', 'Upper West', 'Central', 'Bono']);
    addRegions('Guinée', ['Conakry', 'Kindia', 'Boké', 'Labé', 'Mamou', 'Faranah', 'Kankan', 'N\'Zérékoré']);
    addRegions('Guinée-Bissau', ['Bissau', 'Oio', 'Bafatá', 'Gabú', 'Bolama', 'Cacheu', 'Tombali', 'Quinara']);
    addRegions('Kenya', ['Nairobi', 'Mombasa', 'Kisumu', 'Nakuru', 'Eldoret', 'Machakos', 'Nyeri', 'Garissa', 'Kakamega']);
    addRegions('Lesotho', ['Maseru', 'Berea', 'Leribe', 'Mafeteng', 'Mohale\'s Hoek', 'Quthing', 'Qacha\'s Nek', 'Thaba-Tseka', 'Butha-Buthe', 'Mokhotlong']);
    addRegions('Libéria', ['Montserrado', 'Nimba', 'Bong', 'Grand Bassa', 'Lofa', 'Margibi', 'Maryland', 'Grand Cape Mount']);
    addRegions('Libye', ['Tripoli', 'Benghazi', 'Misrata', 'Zliten', 'Sebha', 'Al Bayda', 'Derna', 'Zuwara']);
    addRegions('Madagascar', ['Analamanga', 'Vakinankaratra', 'Itasy', 'Bongolava', 'Haute Matsiatra', 'Amoron\'i Mania', 'Vatovavy', 'Fitovinany', 'Diana', 'Sava']);
    addRegions('Malawi', ['Lilongwe', 'Blantyre', 'Mzuzu', 'Zomba', 'Kasungu', 'Mangochi', 'Salima', 'Karonga']);
    addRegions('Mali', ['Bamako', 'Kayes', 'Koulikoro', 'Sikasso', 'Ségou', 'Mopti', 'Tombouctou', 'Gao', 'Kidal']);
    addRegions('Mauritanie', ['Nouakchott', 'Nouadhibou', 'Kaédi', 'Rosso', 'Zouérat', 'Atar', 'Néma', 'Kiffa']);
    addRegions('Maurice', ['Port-Louis', 'Vacoas-Phoenix', 'Beau Bassin-Rose Hill', 'Curepipe', 'Quatre Bornes']);
    addRegions('Maroc', ['Casablanca-Settat', 'Rabat-Salé-Kénitra', 'Marrakech-Safi', 'Fès-Meknès', 'Tanger-Tétouan-Al Hoceïma', 'Souss-Massa', 'Drâa-Tafilalet', 'Oriental']);
    addRegions('Mozambique', ['Maputo', 'Gaza', 'Inhambane', 'Sofala', 'Manica', 'Zambézia', 'Nampula', 'Cabo Delgado', 'Niassa', 'Tete']);
    addRegions('Namibie', ['Khomas', 'Erongo', 'Oshana', 'Otjozondjupa', 'Hardap', 'Karas', 'Omusati', 'Ohangwena', 'Oshikoto', 'Kavango East']);
    addRegions('Niger', ['Niamey', 'Agadez', 'Zinder', 'Maradi', 'Tahoua', 'Dosso', 'Diffa', 'Tillabéri']);
    addRegions('Nigéria', ['Lagos', 'Kano', 'Rivers', 'Oyo', 'Kaduna', 'Ogun', 'Enugu', 'Delta', 'Edo', 'Anambra', 'Abia', 'Imo', 'Borno', 'Sokoto', 'Abuja']);
    addRegions('Rwanda', ['Kigali', 'Est', 'Ouest', 'Nord', 'Sud']);
    addRegions('São Tomé-et-Príncipe', ['Água Grande', 'Cantagalo', 'Caué', 'Lembá', 'Lobata', 'Mé-Zóchi', 'Príncipe']);
    addRegions('Sénégal', ['Dakar', 'Thiès', 'Saint-Louis', 'Ziguinchor', 'Kaolack', 'Fatick', 'Tambacounda', 'Kolda', 'Louga', 'Matam', 'Kaffrine', 'Sédhiou', 'Kédougou']);
    addRegions('Seychelles', ['Victoria', 'Anse Royale', 'Bel Ombre', 'Beau Vallon', 'Takamaka']);
    addRegions('Sierra Leone', ['Western Area', 'Northern', 'Eastern', 'Southern']);
    addRegions('Somalie', ['Mogadiscio', 'Somaliland', 'Puntland', 'Jubaland', 'Hirshabelle', 'Galmudug', 'South West']);
    addRegions('Afrique du Sud', ['Gauteng', 'KwaZulu-Natal', 'Cap-Occidental', 'Cap-Oriental', 'Limpopo', 'Mpumalanga', 'État Libre', 'Nord-Ouest', 'Cap-Nord']);
    addRegions('Soudan du Sud', ['Équatoria-Central', 'Équatoria-Oriental', 'Équatoria-Occidental', 'Lacs', 'Unité', 'Nil Supérieur', 'Bahr el Ghazal du Nord', 'Bahr el Ghazal de l\'Ouest', 'Jonglei', 'Unity']);
    addRegions('Soudan', ['Khartoum', 'Gézira', 'Nil Blanc', 'Nil Bleu', 'Darfour du Nord', 'Darfour du Sud', 'Darfour Occidental', 'Kassala', 'Sennar', 'Kordofan du Nord']);
    addRegions('Tanzanie', ['Dar es Salaam', 'Dodoma', 'Mwanza', 'Arusha', 'Kilimandjaro', 'Zanzibar', 'Morogoro', 'Tanga', 'Mbeya', 'Iringa']);
    addRegions('Togo', ['Maritime', 'Plateaux', 'Centrale', 'Kara', 'Savanes']);
    addRegions('Tunisie', ['Tunis', 'Sfax', 'Sousse', 'Kairouan', 'Bizerte', 'Gabès', 'Ariana', 'Monastir', 'Nabeul', 'Gafsa']);
    addRegions('Ouganda', ['Kampala', 'Wakiso', 'Mukono', 'Jinja', 'Gulu', 'Lira', 'Mbarara', 'Masaka', 'Fort Portal', 'Mbale']);
    addRegions('Zambie', ['Lusaka', 'Copperbelt', 'Southern', 'Eastern', 'Central', 'Northern', 'Luapula', 'Western', 'North-Western', 'Muchinga']);
    addRegions('Zimbabwe', ['Harare', 'Bulawayo', 'Manicaland', 'Mashonaland Central', 'Mashonaland East', 'Mashonaland West', 'Masvingo', 'Matabeleland North', 'Matabeleland South', 'Midlands']);
    return result;
  }();

  static final List<Island> _islands = [
    Island(id: _uuid.v4(), name: 'Île de la Réunion', countryId: _getCountryId('Madagascar')),
    Island(id: _uuid.v4(), name: 'Nosy Be', countryId: _getCountryId('Madagascar')),
    Island(id: _uuid.v4(), name: 'Île Sainte-Marie', countryId: _getCountryId('Madagascar')),
    Island(id: _uuid.v4(), name: 'Mahé', countryId: _getCountryId('Seychelles')),
    Island(id: _uuid.v4(), name: 'Praslin', countryId: _getCountryId('Seychelles')),
    Island(id: _uuid.v4(), name: 'La Digue', countryId: _getCountryId('Seychelles')),
    Island(id: _uuid.v4(), name: 'Grande Comore', countryId: _getCountryId('Comores')),
    Island(id: _uuid.v4(), name: 'Anjouan', countryId: _getCountryId('Comores')),
    Island(id: _uuid.v4(), name: 'Mohéli', countryId: _getCountryId('Comores')),
    Island(id: _uuid.v4(), name: 'Mayotte', countryId: _getCountryId('Comores')),
    Island(id: _uuid.v4(), name: 'Île Maurice', countryId: _getCountryId('Maurice')),
    Island(id: _uuid.v4(), name: 'Rodrigues', countryId: _getCountryId('Maurice')),
    Island(id: _uuid.v4(), name: 'São Tomé', countryId: _getCountryId('São Tomé-et-Príncipe')),
    Island(id: _uuid.v4(), name: 'Príncipe', countryId: _getCountryId('São Tomé-et-Príncipe')),
    Island(id: _uuid.v4(), name: 'Santiago', countryId: _getCountryId('Cabo Verde')),
    Island(id: _uuid.v4(), name: 'São Vicente', countryId: _getCountryId('Cabo Verde')),
    Island(id: _uuid.v4(), name: 'Sal', countryId: _getCountryId('Cabo Verde')),
    Island(id: _uuid.v4(), name: 'Fogo', countryId: _getCountryId('Cabo Verde')),
    Island(id: _uuid.v4(), name: 'Bioko', countryId: _getCountryId('Guinée Équatoriale')),
    Island(id: _uuid.v4(), name: 'Annobón', countryId: _getCountryId('Guinée Équatoriale')),
    Island(id: _uuid.v4(), name: 'Zanzibar', countryId: _getCountryId('Tanzanie')),
    Island(id: _uuid.v4(), name: 'Pemba', countryId: _getCountryId('Tanzanie')),
    Island(id: _uuid.v4(), name: 'Lamu', countryId: _getCountryId('Kenya')),
    Island(id: _uuid.v4(), name: 'Mafia', countryId: _getCountryId('Tanzanie')),
  ];

  static final List<RegionLanguage> _regionLanguages = () {
    final List<RegionLanguage> result = [];
    void addRegionLangs(String regionName, String countryName, List<String> langNames) {
      final region = _regions.firstWhere(
        (r) => r.name == regionName && r.countryId == _getCountryId(countryName),
        orElse: () => _regions.first,
      );
      for (final langName in langNames) {
        try {
          final lang = _languages.firstWhere((l) => l.name == langName);
          result.add(RegionLanguage(id: _uuid.v4(), regionId: region.id, languageId: lang.id));
        } catch (_) {}
      }
    }

    // Algérie
    addRegionLangs('Alger', 'Algérie', ['Arabe', 'Français', 'Berbère']);
    addRegionLangs('Oran', 'Algérie', ['Arabe', 'Français']);
    addRegionLangs('Tlemcen', 'Algérie', ['Arabe', 'Berbère', 'Français']);
    addRegionLangs('Tamanrasset', 'Algérie', ['Arabe', 'Tamazight', 'Peul']);

    // Angola
    addRegionLangs('Luanda', 'Angola', ['Portugais']);
    addRegionLangs('Benguela', 'Angola', ['Portugais']);
    addRegionLangs('Cabinda', 'Angola', ['Portugais', 'Kikongo']);

    // Bénin
    addRegionLangs('Littoral', 'Bénin', ['Français', 'Yoruba']);
    addRegionLangs('Borgou', 'Bénin', ['Français', 'Peul', 'Bariba']);

    // Cameroun
    addRegionLangs('Centre', 'Cameroun', ['Français', 'Ewondo']);
    addRegionLangs('Nord-Ouest', 'Cameroun', ['Anglais']);
    addRegionLangs('Sud-Ouest', 'Cameroun', ['Anglais']);
    addRegionLangs('Nord', 'Cameroun', ['Français', 'Peul', 'Hausa']);

    // Côte d'Ivoire
    addRegionLangs('Abidjan', 'Côte d\'Ivoire', ['Français', 'Dioula']);
    addRegionLangs('Bouaké', 'Côte d\'Ivoire', ['Français', 'Dioula', 'Baoulé']);

    // RDC
    addRegionLangs('Kinshasa', 'République Démocratique du Congo', ['Français', 'Lingala']);
    addRegionLangs('Haut-Katanga', 'République Démocratique du Congo', ['Français', 'Swahili']);
    addRegionLangs('Kongo Central', 'République Démocratique du Congo', ['Français', 'Kikongo']);
    addRegionLangs('Kasaï', 'République Démocratique du Congo', ['Français', 'Tshiluba']);

    // Éthiopie
    addRegionLangs('Addis-Abeba', 'Éthiopie', ['Amharique']);
    addRegionLangs('Oromia', 'Éthiopie', ['Oromo', 'Amharique']);
    addRegionLangs('Tigray', 'Éthiopie', ['Tigrinya']);
    addRegionLangs('Somali', 'Éthiopie', ['Somali', 'Amharique']);

    // Ghana
    addRegionLangs('Greater Accra', 'Ghana', ['Anglais', 'Ga']);
    addRegionLangs('Ashanti', 'Ghana', ['Anglais', 'Twi']);
    addRegionLangs('Northern', 'Ghana', ['Anglais', 'Dagbani', 'Hausa']);

    // Kenya
    addRegionLangs('Nairobi', 'Kenya', ['Anglais', 'Swahili']);
    addRegionLangs('Mombasa', 'Kenya', ['Anglais', 'Swahili']);
    addRegionLangs('Kisumu', 'Kenya', ['Anglais', 'Swahili', 'Luo']);

    // Maroc
    addRegionLangs('Casablanca-Settat', 'Maroc', ['Arabe', 'Français', 'Bérabère']);
    addRegionLangs('Rabat-Salé-Kénitra', 'Maroc', ['Arabe', 'Français']);
    addRegionLangs('Fès-Meknès', 'Maroc', ['Arabe', 'Français', 'Berbère']);

    // Madagascar
    addRegionLangs('Analamanga', 'Madagascar', ['Malagasy', 'Français']);
    addRegionLangs('Diana', 'Madagascar', ['Malagasy', 'Français']);

    // Mali
    addRegionLangs('Bamako', 'Mali', ['Français', 'Bambara']);
    addRegionLangs('Kayes', 'Mali', ['Français', 'Bambara', 'Soninké', 'Peul']);
    addRegionLangs('Tombouctou', 'Mali', ['Français', 'Songhaï', 'Tamacheq']);

    // Nigéria
    addRegionLangs('Lagos', 'Nigéria', ['Anglais', 'Yoruba']);
    addRegionLangs('Kano', 'Nigéria', ['Anglais', 'Hausa']);
    addRegionLangs('Enugu', 'Nigéria', ['Anglais', 'Igbo']);
    addRegionLangs('Abuja', 'Nigéria', ['Anglais', 'Hausa', 'Gwari']);

    // Rwanda
    addRegionLangs('Kigali', 'Rwanda', ['Kinyarwanda', 'Anglais', 'Français']);

    // Sénégal
    addRegionLangs('Dakar', 'Sénégal', ['Français', 'Wolof']);
    addRegionLangs('Ziguinchor', 'Sénégal', ['Français', 'Diola', 'Wolof']);
    addRegionLangs('Tambacounda', 'Sénégal', ['Français', 'Peul', 'Mandinka']);

    // Afrique du Sud
    addRegionLangs('Gauteng', 'Afrique du Sud', ['Anglais', 'Zoulou', 'Afrikaans', 'Sotho']);
    addRegionLangs('Cap-Occidental', 'Afrique du Sud', ['Afrikaans', 'Anglais', 'Xhosa']);
    addRegionLangs('KwaZulu-Natal', 'Afrique du Sud', ['Zoulou', 'Anglais']);

    // Tanzanie
    addRegionLangs('Dar es Salaam', 'Tanzanie', ['Swahili', 'Anglais']);
    addRegionLangs('Zanzibar', 'Tanzanie', ['Swahili', 'Arabe', 'Anglais']);

    // Tunisie
    addRegionLangs('Tunis', 'Tunisie', ['Arabe', 'Français']);
    addRegionLangs('Sfax', 'Tunisie', ['Arabe', 'Français']);

    // Zimbabwe
    addRegionLangs('Harare', 'Zimbabwe', ['Anglais', 'Shona', 'Ndebele']);
    addRegionLangs('Bulawayo', 'Zimbabwe', ['Anglais', 'Ndebele', 'Shona']);

    return result;
  }();

  static Map<String, dynamic> toSupabaseFormat() {
    return {
      'countries': _countries.map((c) => c.toMap()).toList(),
      'regions': _regions.map((r) => r.toMap()).toList(),
      'languages': _languages.map((l) => l.toMap()).toList(),
      'islands': _islands.map((i) => i.toMap()).toList(),
      'region_languages': _regionLanguages.map((rl) => rl.toMap()).toList(),
    };
  }
}
