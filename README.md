# CyberSpryt

Aplikacja mobilna (Android & iOS) do nauki cyberbezpieczeństwa, inspirowana Duolingo, stworzona z myślą o seniorach.

## Funkcje

- **Nauka przez zabawę:** Krótkie lekcje w języku polskim.
- **Dostępność:** Możliwość dostosowania wielkości czcionki i włączenia wysokiego kontrastu przy pierwszym uruchomieniu.
- **Maskotka:** Interaktywny, tekstowy przewodnik `:)`, który reaguje na Twoje postępy (tańczy przy sukcesach, smuci się przy błędach).
- **Grywalizacja:** Zbieraj punkty XP i utrzymuj serie dni nauki (streaks).
- **Brak backendu:** Wszystkie dane są przechowywane bezpiecznie na Twoim urządzeniu.
- **Płynne animacje:** Wykorzystanie efektów "Magic Move" (Hero) dla zapewnienia intuicyjnego interfejsu.

## Technologie

- **Flutter:** Framework do tworzenia aplikacji wieloplatformowych.
- **Provider:** Zarządzanie stanem aplikacji.
- **Shared Preferences:** Lokalna baza danych postępów.
- **Flutter Animate:** System płynnych, organicznych animacji.

## Jak zbudować aplikację?

### Android (APK)

Aby wygenerować plik APK gotowy do instalacji lub wrzucenia do Google Play Store:

```bash
flutter build apk --release
```
Plik znajdziesz w: `build/app/outputs/flutter-apk/app-release.apk`

### iOS (IPA)

Do zbudowania wersji na iOS potrzebujesz komputera z macOS oraz zainstalowanego Xcode.

1. Otwórz terminal w folderze projektu.
2. Wykonaj komendę:
   ```bash
   flutter build ipa
   ```
3. Otwórz plik `ios/Runner.xcworkspace` w Xcode, aby sfinalizować podpisanie aplikacji i wysłać ją do App Store Connect.

## Kategorie lekcji na start

1. **Bezpieczne Hasła:** Jak tworzyć silne klucze do swoich kont.
2. **Uwaga na Oszustów:** Jak rozpoznawać phishing i oszustwa "na wnuczka".
... i wiele więcej wkrótce!
