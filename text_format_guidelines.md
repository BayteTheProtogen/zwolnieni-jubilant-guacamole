# Wytyczne Projektowania Lekcji CyberSpryt (Format JSON)

Ten dokument opisuje format danych, który pozwala na dynamiczną aktualizację treści aplikacji CyberSpryt bez konieczności wydawania nowej wersji w sklepie. Dane są pobierane z pliku tekstowego (np. Pastebin RAW lub GitHub RAW).

## Struktura Pliku

Plik musi być poprawnym dokumentem JSON o następującej strukturze:

```json
{
  "version": "1.0.0",
  "next_db_url": "https://pastebin.com/raw/NOWY_KOD",
  "categories": [
    {
      "id": "kat_id",
      "title": "Tytuł Kategorii",
      "description": "Opis",
      "icon": "🔑",
      "lessons": [
        {
          "id": "les_id",
          "title": "Tytuł Lekcji",
          "xpReward": 10,
          "tasks": [
            {
              "id": "task_id",
              "type": "multipleChoice",
              "question": "Pytanie?",
              "options": ["A", "B", "C"],
              "correctAnswerIndex": 0,
              "explanation": "Wyjaśnienie dlaczego ta odpowiedź.",
              "imageUrl": "https://cdn.com/obraz.png",
              "videoUrl": "https://cdn.com/film.mp4"
            }
          ]
        }
      ]
    }
  ]
}
```

## Kluczowe Pola

### Pole `next_db_url`
Jeśli to pole nie jest puste, aplikacja przy kolejnym sprawdzeniu spróbuje pobrać dane z podanego nowego adresu. Pozwala to na "przeniesienie" bazy danych w inne miejsce.

### Typy Zadań (`type`)
- `info`: Ekran edukacyjny (tylko tekst/media, przycisk "Kontynuuj").
- `multipleChoice`: Quiz jednokrotnego wyboru.
- `multipleResponse`: Quiz wielokrotnego wyboru (pole `correctAnswerIndex` musi być listą numerów, np. `[0, 2]`).
- `trueFalse`: Szybkie pytanie Prawda/Fałsz.
- `suspiciousElement`: Zadanie polegające na wskazaniu podejrzanego elementu (wizualnie identyczne z multipleChoice, ale z innym kontekstem).

### Multimedia
- `imageUrl`: Link do obrazu (JPG, PNG). Aplikacja automatycznie go pobierze i zapisze w pamięci podręcznej.
- `videoUrl`: Link do filmu (MP4). Filmy są odtwarzane bezpośrednio wewnątrz lekcji.

## Zasady Pisania Treści dla Seniorów
1. **Język:** Prosty, bez żargonu technicznego.
2. **Ton:** Przyjazny, zachęcający, nie straszący.
3. **Praktyka:** Skupiaj się na codziennych sytuacjach (SMS od banku, telefon od "wnuczka").
4. **Wyjaśnienia:** Każde zadanie powinno mieć pole `explanation`, które tłumaczy zasadę bezpieczeństwa.

## Walidacja
Przed wrzuceniem pliku na Pastebin, upewnij się, że JSON jest poprawny (użyj np. [jsonlint.com](https://jsonlint.com/)). Błąd w strukturze spowoduje, że aplikacja nie załaduje nowych lekcji i zostanie przy ostatniej poprawnej wersji.
