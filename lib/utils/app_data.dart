import '../models/lesson_models.dart';

final List<Category> appCategories = [
  Category(
    id: 'hasla',
    title: 'Bezpieczne Hasła',
    description: 'Naucz się tworzyć hasła, których nikt nie złamie.',
    icon: '🔑',
    lessons: [
      Lesson(
        id: 'h1',
        title: 'Co to jest silne hasło?',
        tasks: [
          Task(
            id: 'h1_t1',
            type: TaskType.trueFalse,
            question: 'Czy "123456" to dobre i bezpieczne hasło?',
            options: ['Tak', 'Nie'],
            correctAnswerIndex: 1,
            explanation: 'Takie hasło jest najłatwiejsze do odgadnięcia przez programy hakerskie.',
          ),
          Task(
            id: 'h1_t2',
            type: TaskType.multipleChoice,
            question: 'Które z tych haseł jest NAJSILNIEJSZE?',
            options: ['kocham_wnuki', 'Admin123', 'Truskawka!2024#', 'password'],
            correctAnswerIndex: 2,
            explanation: 'Silne hasło powinno mieć duże i małe litery, cyfry oraz znaki specjalne.',
          ),
          Task(
            id: 'h1_t3',
            type: TaskType.trueFalse,
            question: 'Czy bezpiecznie jest używać tego samego hasła do wszystkich kont?',
            options: ['Tak', 'Nie'],
            correctAnswerIndex: 1,
            explanation: 'Jeśli haker pozna jedno hasło, uzyska dostęp do wszystkich Twoich kont.',
          ),
        ],
      ),
      Lesson(
        id: 'h2',
        title: 'Menedżery haseł',
        tasks: [
          Task(
            id: 'h2_t1',
            type: TaskType.multipleChoice,
            question: 'Gdzie najlepiej przechowywać trudne do zapamiętania hasła?',
            options: [
              'Na kartce przyklejonej do monitora',
              'W bezpiecznym programie (menedżerze haseł)',
              'W ogóle ich nie zapisywać i resetować co chwilę',
              'W pliku "hasla.txt" na pulpicie'
            ],
            correctAnswerIndex: 1,
            explanation: 'Menedżer haseł to bezpieczny cyfrowy sejf na Twoje klucze.',
          ),
        ],
      ),
    ],
  ),
  Category(
    id: 'oszusci',
    title: 'Uwaga na Oszustów',
    description: 'Rozpoznaj próby wyłudzenia pieniędzy i danych.',
    icon: '🛡️',
    lessons: [
      Lesson(
        id: 'o1',
        title: 'Fałszywe SMS-y (Phishing)',
        tasks: [
          Task(
            id: 'o1_t1',
            type: TaskType.suspiciousElement,
            question: 'Dostałeś SMS: "Twoja paczka została wstrzymana z powodu niedopłaty 1.50 PLN. Wejdź na: http://paczka-poczta-polska.com/zaplat". Co robisz?',
            options: [
              'Klikam i płacę, to tylko mała kwota',
              'Ignoruję i usuwam wiadomość',
              'Dzwonię pod numer z SMS-a'
            ],
            correctAnswerIndex: 1,
            explanation: 'To klasyczny phishing. Banki i firmy kurierskie nie wysyłają takich linków.',
          ),
          Task(
            id: 'o1_t2',
            type: TaskType.trueFalse,
            question: 'Czy bank kiedykolwiek poprosi Cię przez telefon o podanie hasła do logowania?',
            options: ['Tak', 'Nie'],
            correctAnswerIndex: 1,
            explanation: 'Pracownik banku nigdy nie prosi o hasło ani kod PIN.',
          ),
        ],
      ),
      Lesson(
        id: 'o2',
        title: 'Oszustwo "na wnuczka"',
        tasks: [
          Task(
            id: 'o2_t1',
            type: TaskType.multipleChoice,
            question: 'Dzwoni osoba podająca się za wnuka i prosi o szybki przelew na "okazję życia". Co powinieneś zrobić?',
            options: [
              'Natychmiast biec do banku',
              'Rozłączyć się i zadzwonić do wnuka na jego znany Ci numer',
              'Podać swoje dane do konta, żeby wnuk mógł sam przelać pieniądze'
            ],
            correctAnswerIndex: 1,
            explanation: 'Zawsze weryfikuj tożsamość dzwoniącego, dzwoniąc do niego bezpośrednio.',
          ),
        ],
      ),
    ],
  ),
];
