# Dzięki za Twój wkład w rozwój projektu!

## Obowiązkowa lista kontrolna:

### 1. Po otwarciu Pull Request pamiętaj o wykonaniu następujących czynności:
1. [ ] Sprawdź, czy nazwa Pull Request jest zgodna z konwencją "_#{id_zadania_azure_dev_ops} {wymowny opis zmian}_". Przykłady:
   - "#1010 Wydruk faktury sprzedaży - bug fix dot. wyświetlania kursu waluty w specyfikacji VAT PLN"
   - "#1213 Integracja EDI - funkcjonalność eksportu faktur korygujących sprzedaży"
1. [ ] Sprawdź, czy Twój kod jest napisany wg [**standardów kodowania NAV24**](https://dev.azure.com/nav24project/N24_Organization/_wiki/wikis/N24_Organization.wiki/800/Coding-conventions).
1. [ ] Sprawdź, czy wygenerowałeś permissions set w przypadku dodania nowego obiektu (tabela, page, codeunit, raport itd.).
1. [ ] Sprawdź, czy dodałeś uprawnienia (właściwość permissions) w obiekcie w przypadku wykonywania operacji zapisu/modyfikacji/usunięcia na tabelach z zapisami.

### 2. Następnie, jeżeli jesteś gotowy do Code Review:
1. [ ] Dodaj Code Reviewer'a - w przypadku modyfikacji per tenant (tzn. w repozytoriach projektowych) w pierwszej kolejności opiekun techniczny projektu, w zastępstwie lub jeżeli to zasadne Adrian/Mateusz.

### 3. W dalszej kolejności przed samym zamknięciem Pull Request zweryfikuj:
1. [ ] W przypadku domergowania zmian z mastera, czy przebudowałeś extension, wygenerowałeś na nowo translacje i je zweryfikowałeś (po wykonanym merge).
1. [ ] Czy zaktualizowałeś nr wersji extension w app.json i nadal posiadasz aktualny, kolejny nr wersji względem mastera (w międzyczasie ktoś inny mógł domergować zmiany do mastera i podbić nr wersji).
1. [ ] **Czy wszystkie powyższe checkboxy zostały przez Ciebie zaznaczone** :)

### 4. Ostatecznie po zakończeniu Pull Request:
1. Pamiętaj o dodaniu odpowiedniego taga na masterze z oznaczeniem wersji zgodnie z procesem opisanym [**tutaj.**](https://dev.azure.com/nav24project/N24_Organization/_wiki/wikis/N24_Organization.wiki/751/Git-Workflow?anchor=zasady-%26-narz%C4%99dzia)

### Uwagi
1. Pamiętaj, że za ostateczne zakończenie PR jest **odpowiedzialny autor**, a nie osoba wykonująca Code Review i akceptująca zmiany.
1. Więcej informacji o Pull Requests znajdziesz [**tutaj**](https://dev.azure.com/nav24project/N24_Organization/_wiki/wikis/N24_Organization.wiki/801/Pull-Request-conventions).