# AfriMap Explorer

**Application éducative mobile interactive pour découvrir l'Afrique**

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Dart](https://img.shields.io/badge/Dart-3.x-blue)
![Supabase](https://img.shields.io/badge/Supabase-Optional-green)
![License](https://img.shields.io/badge/License-MIT-green)

---

## Table des matières

- [Aperçu général](#aperçu-général)
- [Fonctionnalités](#fonctionnalités)
- [Architecture technique](#architecture-technique)
- [Structure du projet](#structure-du-projet)
- [Modèle de données](#modèle-de-données)
- [Installation et démarrage](#installation-et-démarrage)
- [Configuration Supabase](#configuration-supabase)
- [Stratégie offline-first](#stratégie-offline-first)
- [Système de quiz](#système-de-quiz)
- [Système de badges](#système-de-badges)
- [Routage](#routage)
- [Thème et UI](#thème-et-ui)
- [Dépendances](#dépendances)
- [Tests](#tests)
- [Déploiement](#déploiement)
- [Évolutions futures](#évolutions-futures)

---

## Aperçu général

**AfriMap Explorer** est une application mobile éducative développée en Flutter, destinée principalement aux enfants (5-12 ans) mais utilisable par tout public. Elle permet de découvrir les 54 pays d'Afrique à travers :

- La géographie (pays, régions, îles)
- Les langues (officielles et traditionnelles)
- Des quiz interactifs avec scoring et progression

### Principes clés

| Principe | Description |
|----------|-------------|
| **Offline-first** | Fonctionne sans connexion internet |
| **Éducatif** | Contenu adapté aux enfants |
| **Interactif** | Quiz avec feedback immédiat |
| **Évolutif** | Architecture modulaire pour ajouter d'autres continents |

### Public cible

- Enfants de 5 à 12 ans (principal)
- Étudiants en géographie
- Toute personne curieuse de l'Afrique

---

## Fonctionnalités

### 1. Onboarding

Écran d'introduction en 3 pages avec animations :
- Présentation de l'application
- Explication des fonctionnalités
- Bouton "Commencer l'Aventure"

Le statut de completion est sauvegardé localement.

### 2. Exploration des pays

- **54 pays africains** avec drapeaux et capitales
- Vue **grille** ou **liste** (bascule via AppBar)
- **Recherche** en temps réel par nom
- Indicateur de pays explorés (coche verte)

### 3. Détail d'un pays

Pour chaque pays :
- Drapeau (chargé depuis flagcdn.com, mis en cache)
- Capitale
- Liste des régions (cliquables)
- Langues officielles et traditionnelles
- Îles (si existantes)

Le pays est automatiquement marqué comme "exploré".

### 4. Détail d'une région

- Nom de la région + pays parent
- Langues parlées dans cette région
- Séparation officielles / traditionnelles

### 5. Quiz (8 types)

| Type | Description |
|------|-------------|
| Pays → Capitale | Quelle est la capitale de X ? |
| Capitale → Pays | Quel pays a pour capitale X ? |
| Pays → Langues | Quelle langue est parlée en X ? |
| Langues → Pays | Quel pays parle X ? |
| Région → Langues | Quelle langue dans la région X ? |
| Drapeau → Pays | Reconnais le drapeau |
| Pays → Îles | À quel pays appartient l'île X ? |
| Mélange | Tous les types combinés |

### 6. Système de difficulté

| Niveau | Questions | Temps/question | Points/question |
|--------|-----------|----------------|-----------------|
| Facile | 10 | 30 secondes | 10 pts |
| Moyen | 15 | 20 secondes | 20 pts |
| Difficile | 20 | 10 secondes | 30 pts |

### 7. Progression

- Pays explorés / total (avec barre de progression)
- Quiz complétés
- Meilleur score
- Moyenne de pourcentage
- Historique des 10 derniers quiz

### 8. Badges (10 débloquables)

| Badge | Condition | Icône |
|-------|-----------|-------|
| Premier Quiz | Compléter 1 quiz | `gps_fixed` |
| Score Parfait | 100% à un quiz | `looks_one` |
| Joueur Assidu | 5 quiz complétés | `star` |
| Expert Quiz | 10 quiz complétés | `emoji_events` |
| Explorateur | 10 pays explorés | `explore` |
| Globe-trotter | Tous les pays explorés | `public` |
| Touche-à-tout | Tous les types de quiz joués | `palette` |
| En Forme | 5 bonnes réponses d'affilée | `local_fire_department` |
| Sans Peur | Quiz difficile complété | `fitness_center` |
| Éclair | Réponse en moins de 3s | `bolt` |

### 9. Paramètres

- **À propos** : version, mission, technologies, crédits
- **Politique de confidentialité** : 8 sections détaillées
- **Conditions d'utilisation** : 6 sections
- **Noter l'application** : système d'étoiles
- **Signaler un problème** : formulaire de feedback
- **Synchronisation** : état de la sync Supabase
- **Effacer les données** : suppression du cache local

---

## Architecture technique

### Pattern : Clean Architecture simplifiée

```
+---------------------------------------------+
|           PRESENTATION                       |
|  +----------+  +------------------+         |
|  | Screens  |  |    Widgets       |         |
|  +-----+----+  +--------+---------+         |
|        |                  |                  |
|  +-----+------------------+---------+        |
|  |       Providers (Riverpod)       |        |
|  +----------------+-----------------+        |
+-------------------+-------------------------+
|           DOMAINE / DATA                     |
|  +----------------+-----------------+        |
|  |        Repositories             |        |
|  +---+------------------+----------+        |
|      |                  |                    |
|  +---+------+    +------+--------+          |
|  |  Local   |    |   Remote      |          |
|  | (Prefs)  |    | (Supabase)    |          |
|  +----------+    +--------------+           |
+---------------------------------------------+
|              MODELES                        |
|  Country, Region, Language, Island,         |
|  QuizQuestion, QuizResult, Badge            |
+---------------------------------------------+
```

### Gestion d'état : Riverpod

| Provider | Type | Rôle |
|----------|------|------|
| `sharedPreferencesProvider` | `Provider` | Instance SharedPreferences |
| `localDataSourceProvider` | `Provider` | Accès au stockage local |
| `remoteDataSourceProvider` | `Provider` | Accès à Supabase (nullable) |
| `countryRepositoryProvider` | `Provider` | Repository principal |
| `quizRepositoryProvider` | `Provider` | Génération de quiz |
| `dataInitializerProvider` | `FutureProvider` | Initialisation des données |
| `countriesProvider` | `Provider` | Liste des pays |
| `searchQueryProvider` | `StateProvider` | Recherche en cours |
| `filteredCountriesProvider` | `Provider` | Pays filtrés |
| `regionsByCountryProvider` | `Provider.family` | Régions par pays |
| `languagesByCountryProvider` | `Provider.family` | Langues par pays |
| `languagesByRegionProvider` | `Provider.family` | Langues par région |
| `islandsByCountryProvider` | `Provider.family` | Îles par pays |
| `exploredCountriesProvider` | `StateNotifierProvider` | Pays explorés |
| `quizResultsProvider` | `StateNotifierProvider` | Résultats de quiz |
| `quizStateProvider` | `StateNotifierProvider` | État du quiz en cours |
| `badgesProvider` | `StateNotifierProvider` | État des badges |

---

## Structure du projet

```
lib/
+-- main.dart                          # Point d'entre
+-- app.dart                           # MaterialApp + splash screen
|
+-- core/
|   +-- constants/
|   |   +-- app_strings.dart           # Strings et constantes
|   |   +-- supabase_config.dart       # Configuration Supabase
|   |   +-- constants.dart             # Barrel export
|   +-- router/
|   |   +-- app_router.dart            # Configuration GoRouter
|   +-- theme/
|       +-- app_theme.dart             # Couleurs, textes styles
|       +-- theme.dart                 # ThemeData
|
+-- data/
|   +-- models/
|   |   +-- country.dart               # Modele pays
|   |   +-- region.dart                # Modele region
|   |   +-- language.dart              # Modele langue
|   |   +-- island.dart                # Modele ile
|   |   +-- region_language.dart       # Table jointure
|   |   +-- quiz_models.dart           # Quiz, Badge, Difficulte
|   |   +-- models.dart                # Barrel export
|   +-- datasources/
|   |   +-- local/
|   |   |   +-- local_datasource.dart  # SharedPreferences
|   |   +-- remote/
|   |       +-- remote_datasource.dart # Supabase CRUD
|   +-- repositories/
|   |   +-- country_repository.dart    # Logique donnees
|   |   +-- quiz_repository.dart       # Generation questions
|   +-- seed/
|   |   +-- seed_data.dart             # 54 pays + donnees
|   +-- data.dart                      # Barrel export
|
+-- presentation/
    +-- providers/
    |   +-- providers.dart             # Tous les Riverpod providers
    +-- screens/
    |   +-- onboarding/
    |   |   +-- onboarding_screen.dart
    |   +-- home/
    |   |   +-- home_screen.dart
    |   +-- country_detail/
    |   |   +-- country_detail_screen.dart
    |   +-- region_detail/
    |   |   +-- region_detail_screen.dart
    |   +-- quiz/
    |   |   +-- quiz_screen.dart       # Selection + Jeu + Resultats
    |   +-- progress/
    |   |   +-- progress_screen.dart
    |   +-- settings/
    |       +-- settings_screen.dart
    |       +-- about_screen.dart
    |       +-- privacy_screen.dart
    |       +-- terms_screen.dart
    |       +-- feedback_screen.dart
    +-- widgets/
```

---

## Modele de donnees

### Schema relationnel

```
countries (1) ---- (N) regions
countries (1) ---- (N) islands
regions (N) ---- (M) languages  [via region_languages]
```

### Tables Supabase

#### `countries`
```sql
CREATE TABLE countries (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  flag_url TEXT,
  capital TEXT
);
```

#### `regions`
```sql
CREATE TABLE regions (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  country_id TEXT REFERENCES countries(id)
);
```

#### `languages`
```sql
CREATE TABLE languages (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT DEFAULT 'traditionnelle'
);
```

#### `islands`
```sql
CREATE TABLE islands (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  country_id TEXT REFERENCES countries(id)
);
```

#### `region_languages`
```sql
CREATE TABLE region_languages (
  id TEXT PRIMARY KEY,
  region_id TEXT REFERENCES regions(id),
  language_id TEXT REFERENCES languages(id)
);
```

#### `quiz_results`
```sql
CREATE TABLE quiz_results (
  id TEXT PRIMARY KEY,
  type INT NOT NULL,
  difficulty INT DEFAULT 0,
  total_questions INT NOT NULL,
  correct_answers INT NOT NULL,
  wrong_answers INT DEFAULT 0,
  timeouts INT DEFAULT 0,
  completed_at TIMESTAMPTZ DEFAULT NOW(),
  score INT NOT NULL,
  max_score INT DEFAULT 0,
  device_id TEXT
);
```

### Politiques RLS

```sql
ALTER TABLE countries ENABLE ROW LEVEL SECURITY;
ALTER TABLE regions ENABLE ROW LEVEL SECURITY;
ALTER TABLE languages ENABLE ROW LEVEL SECURITY;
ALTER TABLE islands ENABLE ROW LEVEL SECURITY;
ALTER TABLE region_languages ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_results ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read" ON countries FOR SELECT USING (true);
CREATE POLICY "Public read" ON regions FOR SELECT USING (true);
CREATE POLICY "Public read" ON languages FOR SELECT USING (true);
CREATE POLICY "Public read" ON islands FOR SELECT USING (true);
CREATE POLICY "Public read" ON region_languages FOR SELECT USING (true);
CREATE POLICY "Public insert" ON quiz_results FOR INSERT WITH CHECK (true);
CREATE POLICY "Public read" ON quiz_results FOR SELECT USING (true);
```

### Modeles Dart

```dart
class Country {
  final String id;
  final String name;
  final String flagUrl;
  final String capital;
}

class Region {
  final String id;
  final String name;
  final String countryId;
}

class Language {
  final String id;
  final String name;
  final String type;  // 'officielle' | 'traditionnelle'
  bool get isOfficial => type == 'officielle';
}

class Island {
  final String id;
  final String name;
  final String countryId;
}

class QuizQuestion {
  final String id;
  final QuizType type;
  final String question;
  final String correctAnswer;
  final List<String> options;
  final String? relatedCountryId;
  final String? relatedRegionId;
  final String? flagUrl;
  final String? explanation;
}

class QuizResult {
  final String id;
  final QuizType type;
  final QuizDifficulty difficulty;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int timeouts;
  final DateTime completedAt;
  final int score;
  final int maxScore;
  final List<QuizAnswerDetail> answerDetails;
}
```

---

## Installation et demarrage

### Prerequis

- Flutter SDK >= 3.11.3
- Dart SDK >= 3.x
- Android Studio ou VS Code
- Un emulateur ou appareil physique

### Etapes

```bash
# 1. Cloner le projet
git clone <repository-url>
cd afrimapexplorer

# 2. Installer les dependances
flutter pub get

# 3. Lancer l'application
flutter run

# 4. (Optionnel) Build APK
flutter build apk --release
```

### Build pour differentes plateformes

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

---

## Configuration Supabase

### 1. Creer un projet Supabase

1. Aller sur [supabase.com](https://supabase.com)
2. Creer un compte et un nouveau projet
3. Aller dans **Settings -> API**

### 2. Configurer les cles

Editer `lib/core/constants/supabase_config.dart` :

```dart
class SupabaseConfig {
  static const String url = 'https://VOTRE_PROJET.supabase.co';
  static const String anonKey = 'VOTRE_ANON_KEY';
}
```

### 3. Creer les tables

Executer le SQL complet dans l'editeur SQL de Supabase (voir section "Modele de donnees").

### 4. Fonctionnement

- Si Supabase est configure : les donnees sont synchronisees au demarrage
- Si Supabase est vide : les donnees seedees sont poussees vers Supabase
- Si pas de connexion : les donnees locales sont utilisees

---

## Strategie offline-first

### Flux de chargement des donnees

```
App demarrage
    |
    v
+------------------+
| 1. Cache local   |---- Donnees disponibles ?
|   (Prefs)        |         |
+--------+---------+         |
         |                  | Non
         | Oui              v
         |         +------------------+
         |         | 2. Seed data     |
         |         |   (harcode)      |
         |         +--------+---------+
         |                  |
         v                  v
+-----------------------------+
| 3. Donnees pretes           |
|    (marquer initialized)    |
+-------------+---------------+
              |
              v
+-----------------------------+
| 4. Sync Supabase (arriere) |
|    Si configure et en ligne |
+-----------------------------+
```

### Stockage local (SharedPreferences)

| Cle | Type | Contenu |
|-----|------|---------|
| `onboarding_completed` | bool | Onboarding termine |
| `explored_countries` | List\<String\> | IDs des pays explores |
| `quiz_results` | JSON | Historique des quiz |
| `cached_countries` | JSON | Pays en cache |
| `cached_regions` | JSON | Regions en cache |
| `cached_languages` | JSON | Langues en cache |
| `cached_islands` | JSON | Iles en cache |
| `cached_region_languages` | JSON | Relations region-langue |
| `unlocked_badges` | List\<String\> | IDs des badges debloques |

---

## Systeme de quiz

### Generation de questions

Le `QuizRepository` genere les questions dynamiquement a partir des donnees. Chaque type de quiz a son propre generateur qui selectionne aleatoirement les donnees et cree 4 options de reponse (1 correcte + 3 incorrectes).

### Flow d'un quiz

```
Selection type -> Selection difficulte -> Generation questions
    |
    v
Question 1/N
    |
    +-- Timer (30s/20s/10s)
    +-- Affichage question + options
    +-- Si reponse -> Feedback (correct/incorrect)
    +-- Si timer expire -> Timeout
    |
    v
Question suivante (ou Resultats si derniere)
    |
    v
Resultats : Score, Stats, Revision, Sauvegarde, Badges
```

### Calcul du score

```
score = nombre_bonnes_reponses x points_par_question

Facile   : 10 questions x 10 pts = max 100 pts
Moyen    : 15 questions x 20 pts = max 300 pts
Difficile: 20 questions x 30 pts = max 600 pts
```

### Note finale

| Pourcentage | Note | Message |
|-------------|------|---------|
| >= 90% | A+ | Excellent ! |
| >= 70% | B | Tres bien ! |
| >= 50% | D | Pas mal ! |
| < 50% | E | Courage ! |

---

## Systeme de badges

10 badges sont definis dans `BadgeDefinitions`. Le provider `badgesProvider` verifie automatiquement les conditions a chaque changement de progression (quiz joues, pays explores). Les badges debloques sont sauvegardes dans SharedPreferences.

---

## Routage

### Routes principales

| Route | Ecran | Description |
|-------|-------|-------------|
| `/onboarding` | OnboardingScreen | Introduction |
| `/` | HomeScreen | Liste des pays |
| `/country/:id` | CountryDetailScreen | Detail d'un pays |
| `/country/:id/region/:id` | RegionDetailScreen | Detail region |
| `/quiz` | QuizScreen | Selection du quiz |
| `/quiz/play` | QuizPlayScreen | Jeu en cours |
| `/progress` | ProgressScreen | Statistiques |
| `/settings` | SettingsScreen | Parametres |
| `/settings/about` | AboutScreen | A propos |
| `/settings/privacy` | PrivacyScreen | Confidentialite |
| `/settings/terms` | TermsScreen | Conditions |
| `/settings/feedback` | FeedbackScreen | Feedback |

---

## Theme et UI

### Palette de couleurs

```
primary     = #2196F3  (Bleu)
primaryDark = #1565C0  (Bleu fonce)
accent      = #FF9800  (Orange)
success     = #4CAF50  (Vert)
error       = #F44336  (Rouge)
warning     = #FFC107  (Jaune)
```

### Animations

Utilisation de `flutter_animate` :
- `fadeIn` : apparition progressive
- `slideX` / `slideY` : glissement
- `scale` : zoom (elasticOut pour les icones)
- Delais progressifs pour les listes (cascade)

---

## Dependances

### Production

| Package | Version | Usage |
|---------|---------|-------|
| `flutter_riverpod` | ^2.6.1 | Gestion d'etat |
| `go_router` | ^14.8.1 | Navigation |
| `supabase_flutter` | ^2.8.2 | Backend (optionnel) |
| `cached_network_image` | ^3.4.1 | Cache des drapeaux |
| `equatable` | ^2.0.7 | Egalite des objets |
| `uuid` | ^4.5.1 | Generation d'IDs |
| `shared_preferences` | ^2.5.2 | Stockage local |
| `flutter_animate` | ^4.5.2 | Animations |

---

## Deploiement

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

---

## Evolutions futures

- Ajout d'autres continents (Europe, Ameriques, Asie)
- Audio pour la prononciation des langues
- Mini-jeux (memory, puzzle de drapeaux)
- Mode multijoueur local
- Systeme de classement (leaderboard)
- Quiz quotidiens (daily challenge)
- Mode sombre
- Support multilingue

---

## Licence

Ce projet est sous licence MIT.

---

**AfriMap Explorer** — Decouvre l'Afrique, une question a la fois !
