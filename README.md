# Projektowanie prostych aplikacji w R przy uzyciu SHINY

## Spis Treści
* [Ogólne informacje](#ogólne-informacje)
* [Informacje techniczne](#informacje-techniczne)
* [Plan repozytorium](#plan-repozytorium)
* [Konfiguracja](#konfiguracja)
* [O autorze](#o-autorze)

## Ogólne informacje
To repozytorium zawiera wszystkie pliki związane z samouczkiem „Projektowanie prostych aplikacji w R przy uzyciu SHINY”, zarówno te niezbędne do utworzenia samouczka w formacie PDF, jak i załączony działający przykład aplikacji Shiny. Jest to tłumaczenie poprzedniej pracy autora, oryginalny samouczek po angielsku można znaleźć w tym repozytorium: https://github.com/DCS-training/ShinyTutorial bądź poprzez DOI: https://doi.org/10.5281/zenodo.5705151. Samouczek ma na celu zapoznanie czytelnika ze wszystkimi kluczowymi etapami tworzenia aplikacji internetowej w R, w tym ze wszystkimi potrzebnymi bibliotekami.

## Informacje techniczne
Sam dokument PDF zostal zbudowany w RStudio (wersja 1.3.1073; R wersja 4.02), przy uzyciu biblioteki RMarkdown (wersja 2.7) i MiKTeX (dystrybucja Tex). Przedstawione
diagramy (rys. 5-7) zostaly wykonane w programie MS PowerPoint.

Naklejka z logo Shiny, prezentowana na pierwszej stronie, pobrana zostala z repozytorium hex stickers: https://github.com/rstudio/hex-stickers/tree/master/PNG

## Plan repozytorium
```

 .
 └── main
     ├── Tutorial.Rmd
     ├── Tutorial.pdf
     ├── LICENSE.md 
     ├── README.md
     ├── visual
     │   ├── AppStructure.jpg
     │   ├── Customization.jpg  
     │   ├── DCS.jpg   
     │   ├── Difference.jpg
     │   ├── GitHubRep.jpg
     │   ├── InputWidgets.jpg
     │   ├── NewShinyWebApp.jpg
     │   ├── RunningAppRStudio.jpg
     │   ├── Shiny.png
     │   ├── Shinyapp.jpg
     │   ├── SideLayout.jpg
     │   ├── Starting.jpg
     │   ├── TabsetLayout.jpg
     │   ├── TextExamples.jpg
     │   └── UoELogo.png
     └── appexample  
         └── app.R
```

sekcja main/ repozytorium zawiera (oprócz pliku README) Tutorial.Rmd z całym kodem niezbędnym do stworzenia tutoriala w pdf, już wygenerowany Tutorial.pdf oraz dwa foldery. Folder „visual” zawiera wszystkie figury używane przez Tutorial.Rmd. Folder „appexample” zawiera plik app.R, przykładową aplikację R utworzoną przy użyciu biblioteki Shiny.

## Konfiguracja
Aby mieć dostęp do pliku Rmd lub uruchomić aplikację, musisz mieć zainstalowane R i RStudio na swoim komputerze:
* Pakiet R można pobrać z https://cran.r-project.org/bin/windows/base/release.htm
* RStudio można pobrać ze strony: https://rstudio.com/products/rstudio/download/#download

Jeśli masz już zainstalowane R i RStudio:
* Zainstaluj wymagane biblioteki ("shiny","shinythemes","DT","ggplot2","rsconnect","shinyWidgets"), aby móc uruchomić lub zmodyfikować plik aplikacji 
* Aby móc zmienić i/lub połączyć dokument Rmd w plik pdf, zainstaluj wymagane biblioteki ("rmarkdown","knitr") i dystrybucję TeX. Autor sugeruje albo TinyTeX
lub MiKTeX. W razie potrzeby mogą być również potrzebne "devtools"
* Pobierz pliki i foldery z repozytorium, upewnij się, że masz je wszystkie w jednym folderze
* Upewnij się, że katalog roboczy w RStudio jest taki sam jak folder, w którym zapisywane są dane (getwd() do sprawdzania katalogu, setwd() do ustawiania odpowiedniego katalogu)

Alternatywnie, aby uruchomić aplikację za pomocą łącza:
* Zainstaluj wymagane biblioteki („shiny","shinythemes","DT","ggplot2")
* W RStudio uruchom kod shiny::runGitHub("ShinySamouczek","AndrzejRomaniuk", ref = "main", subdir = "appexample")

## O autorze
Ten poradnik zostal oryginalnie napisany w Październiku 2021 roku przez Andrzeja A. Romaniuka dla Centrum Danych, Kultury i Spoleczenstwa Uniwersytetu w Edynburgu
(Centre for Data, Culture and Society, University of Edinburgh). Tlumaczenie na Polski zostalo wykonane przez tego samego autora, w Maju/Czerwcu 2022
roku, z myślą o warsztacie „Projektowanie prostych aplikacji w R przy uzyciu SHINY”, zorganizowanym w ramach konferencji CAA – Forum GIS UW 2022.

Andrzej A. Romaniuk


dr (archeologia), mgr (osteoarcheologia)

Uniwerystet Edynburski, instruktor

Narodowe Muzea Szkocji, wolontariusz naukowy

https://andrzejromaniuk.github.io/CV/

https://www.researchgate.net/profile/Andrzej-Romaniuk

https://github.com/AndrzejRomaniuk

https://orcid.org/0000-0002-4977-9241
