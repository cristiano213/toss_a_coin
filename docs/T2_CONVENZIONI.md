# Toss A Coin — Convenzioni Operative e Regole di Interazione

**Tier 2 — Documento Stabile.** Caricare all'inizio di ogni sessione.
**Versione:** 1.2 (Semplificazione Agile ed Efficienza Contesto)
**Aggiornato:** Maggio 2026
**Ambito Applicativo:** Toss A Coin — Collector Edition (Client-Only / Offline-First)

> **Scope di questo file**: Rappresenta il dizionario normativo e la mappa di autorità per la chat. Definisce le regole dello sviluppo assistito da AI, i vincoli tecnici dell'ecosistema Flutter/Riverpod/SharedPreferences e le cerimonie di controllo versione adattate per uno sviluppo fluido e snello.

---

## 0. Natura del Progetto e Filosofia Costruttiva

Toss A Coin — Collector Edition è un'applicazione ludico-collezionistica di livello **production-quality**. Anche se l'interfaccia si basa su un ciclo di gioco focalizzato (Lancio moneta ↔ Spesa Gacha), ogni componente architetturale deve rispettare standard professionali rigorosi. I compromessi tipici dei codici d'esempio o "demo" sono severamente vietati.

### Pilastri Tecnici Invalidabili
* **Immutabilità dello Stato:** Strutture dati protette da mutazioni accidentali.
* **Isolamento dei Calcoli Deterministici:** La logica probabilistica del motore Gacha è rigorosamente separata dai componenti grafici.
* **Fluidità Visiva Massima:** Assenza totale di microscatti (*jank*) o slittamenti di layout nella UI; trasformazioni 3D ancorate a 60fps/120fps.

### Stack Tecnologico Convalidato
* **Framework:** Flutter (SDK ^3.11.5) + Dart.
* **State Management:** Riverpod 2.5+ (Architettura a Notifier accoppiati in modalità reattiva).
* **Persistenza Locale:** SharedPreferences hardware nativa tramite serializzazione/deserializzazione di stringhe JSON.
* **Rendering Core:** Strumenti matematici e procedurali nativi (`Matrix4`, `AnimatedBuilder`, `CustomPainter`).

### Regola Rigida di Sicurezza degli Import
Il nome nativo del pacchetto generato tramite `flutter create` è `antipanic_app`. Questo nome è strutturale e non deve mai essere modificato o rimosso dagli import assoluti esistenti. Tuttavia, per garantire la massima portabilità del codice e prevenire rotture dell'IDE o dei compilatori automatici durante i refactoring, all'interno delle cartelle di sviluppo si devono utilizzare tassativamente gli **import relativi** (`../` o `./`).

---

## 1. Disposizioni dell'Utente e Approccio Didattico

### 1.1 Modalità Operativa Assistita
* **Sviluppo Atomico e Incrementale:** Si procede un singolo sotto-modulo o file critico alla volta. L'AI deve attendere la conferma di compilazione ed esecuzione dell'utente prima di proporre modifiche successive.
* **Spiegazioni Tecniche Mirate:** Evitare spiegazioni pedagogiche sui fondamentali ovvi di Dart o Flutter (es. cos'è un `StatelessWidget`). Concentrarsi esclusivamente su algebra delle matrici, flussi di sincronizzazione dei provider, ottimizzazioni di memoria e allocazione di stringhe JSON sul disco.
* **Script Completi ed Espliciti:** Fornire blocchi di codice pronti per la sostituzione totale del file di riferimento. L'uso di frammenti orfani, omissioni o commenti pigri (es. `// inserisci qui il resto del codice precedente`) è vietato.
* **Diagnosi Rigorosa dei Bug:** In caso di anomalie visive o logiche, l'AI deve esporre un'analisi strutturata in tre parti (Sintomo / Causa Architetturale / Fix Matematico) prima di esibire il codice correttivo.
* **Niente Preconfigurazioni Limitanti:** Il codice deve essere esplicito, fortemente tipizzato e aperto al totale controllo dello sviluppatore. Le scorciatoie sintattiche che nascondono la logica reattiva sottostante sono vietate.
* **Evidence Before Claims (Niente Falsi Positivi):** L'AI non deve mai assumere o dichiarare un problema come "risolto", "stabile" o "funzionante" di propria iniziativa. Ogni stato di risoluzione deve essere validato dall'utente tramite riscontro statico sul terminale locale (`flutter analyze` o test unitari completati).

### 1.2 Pattern di Spiegazione Fisso
Per ogni step implementativo o strutturale di grande rilevanza, l'AI deve strutturare la risposta secondo questa precisa tassonomia:
1. **Cosa:** L'obiettivo in una singola frase tecnica concisa.
2. **Perché:** Il problema architetturale o computazionale specifico che viene risolto.
3. **Concetti Coinvolti:** I termini scientifici e industriali in gioco (es. *Hard Pity*, *Matrix Entry*, *Asynchronous Preload*).
4. **Pre-requisiti:** File, provider o stati che devono essere già stati consolidati nei turni passati.
5. **Codice:** Completo, tipizzato e commentato in lingua inglese esclusivamente nei punti in cui la logica algoritmica non è immediata.
6. **Verifica:** Istruzioni chiare per testare l'output (Hot Reload, log di console, comportamenti attesi nella UI).
7. **Cosa hai imparato:** Fissaggio teorico della meccanica software assimilata.

---

## 2. Convenzioni Flutter e Architettura del Codice

### 2.1 Struttura dell'Albero di Sviluppo
L'albero delle directory deve rispettare tassativamente la segmentazione per responsabilità e separazione dei concetti:
```text
lib/
├── core/           # Token cromatici (theme.dart) e chiavi stringa di persistenza (constants.dart)
├── models/         # Classi dati immutabili e schemi di serializzazione JSON
├── repositories/   # Layer I/O hardware isolato per l'accesso al disco (SharedPreferences)
├── providers/      # State management, contratti probabilistici e logica di business
├── screens/        # Interfacce utente principali (Navigation Hub, Gacha, Dashboard)
└── widgets/        # Componenti grafici isolati e performanti erogati proceduralmente

```

### 2.2 Modelli Dati (`models/`)

* **Immutabilità Totale:** Tutti i campi d'istanza devono essere dichiarato `final`. I costruttori primari devono essere contrassegnati come `const`.
* **Metodi Obbligatori:** Ogni modello deve implementare un metodo `copyWith()` per le mutazioni protette dello stato e i metodi di accoppiamento `fromJson()` e `toJson()` per l'interazione con il repository locale.
* **Naming Policy:** CamelCase rigoroso nel codice Dart. La conversione da chiavi stringa grezze del disco avviene esclusivamente all'interno delle funzioni di factory di deserializzazione.

### 2.3 State Management (Riverpod 2.5+)

* **Top-Level Constants:** Tutti i provider sono istanziati como costanti globali non annidate dentro classi o strutture limitanti.
* **Scelta del Provider Regolata:**
* `Notifier` / `AsyncNotifier`: Per stati sincroni o asincroni complessi che espongono metodi pubblici di mutazione della verità logica (`GemNotifier`, `GachaNotifier`).
* `Provider` (Read-only): Per esporre in sola lettura configurazioni immutabili calcolate o istanze di repository precaricate all'avvio.


* **Consumo dei Segnali:** Uso tassativo di `ref.watch` all'interno dei metodi `build` dei widget per garantire la reattività granulare. L'uso di `ref.read` è limitato ed esclusivo delle closure interne alle azioni utente (funzioni callback `onPressed`, gesture rilevate).
* **Naming Standard:** Istanza globale in camelCase terminante obbligatoriamente con il suffisso `Provider` (es. `gachaProvider`). Classe logica in PascalCase terminante con il suffisso `Notifier` (es. `GachaNotifier`).

---

## 3. Convenzioni Grafiche e Rendering Procedurale (UI)

* **Zero Asset Esterni (No PNG/JPG/SVG):** Tutti gli elementi visivi della moneta, riflessi metallici, spettri cromatici, ombreggiature e animazioni di contorno devono essere generati programmaticamente. Utilizzare `BoxDecoration`, `LinearGradient`, `BoxShadow` e trasformazioni geometriche nello spazio tridimensionale.
* **Bypass dell'Angolo di Rotazione:** I widget di animazione 3D (`Transform`) devono scindere lo stato matematico dinamico del controller dallo stato statico definitivo. Durante il volo si utilizza l'interpolazione della variabile di animazione; a controller fermo, la sorgente di verità assoluta è il valore enum (`CoinSide`) estratto dal provider, eliminando i difetti di disallineamento speculare.
* **Layout Stabile ad Altezza Fissa (Anti-Jank):** I componenti dell'interfaccia che compaiono o scompaiono condizionalmente (pulsanti di scommessa visibili solo a moneta ferma) devono essere racchiusi in container a dimensione geometrica fissa (`SizedBox`) per prevenire scatti distruttivi del layout verticale (*Layout Shifts*).
* **Disposizioni sui Colori:** Nessun colore o valore esadecimale deve essere inserito in modo rigido (*hardcoded*) all'interno dei file delle schermate (`screens/`). Utilizzare esclusivamente `Theme.of(context)` o i token semantici centralizzati nel file dei temi.

---

## 4. Convenzioni di Persistenza e Sicurezza Locale

* **Il Client come Unica Difesa:** Poiché l'applicazione opera interamente in modalità offline-first, le funzioni di controllo e validazione sulla valuta (es. verifica saldo gemme prima di procedere all'estrazione) risiedono all'interno del codice logico dei Notifier e non nei componenti della UI. La UI riflette lo stato, non lo valida.
* **Inizializzazione Sincrona all'Avvio (Issue ID_001 Risolta):** L'istanza di `SharedPreferences` deve essere risolta in modo asincrono all'interno del metodo `main()` prima di invocare `runApp()`. L'istanza pronta viene iniettata nel container di Riverpod tramite l'overriding del provider di riferimento (`sharedPrefsRepositoryProvider`), consentendo a tutti i Notifier l'accesso sincrono immediato ai dati di salvataggio al frame zero dell'applicazione.
* **Prevenzione dei Duplicati nel Gacha:** La logica del codice deve verificare la presenza di una skin nell'inventario locale prima dell'effettiva assegnazione. In caso di riscontro positivo (skin già sbloccata), deve scattare la conversione matematica automatica in valuta di rimborso (gemme) predefinita nelle regole di gioco.

---

## 5. Mappa di Autorità Unica Documentale (One-Place Rule)

Al fine di prevenire ridondanze e frammentazione delle informazioni operative, ogni specifica risiede in un solo file dedicato secondo la seguente matrice di autorità unica:

| Tipologia di Contenuto | File Autoritativo di Riferimento |
| --- | --- |
| **Stato Corrente del Progetto** | `lib/docs/T1_STATO_PROGETTO.md` |
| **Bug Tracking & Issue Pendenti** | `lib/docs/T1_PROBLEMI_APERTI.md` |
| **Norme di Scrittura e Standard** | `lib/docs/T2_CONVENZIONI.md` *(Questo File)* |
| **Visione di Gioco e Formule Pity** | `lib/docs/T2_VISIONE_FUNZIONALE.md` |
| **Albero Cartelle e Relazioni Provider** | `lib/docs/T2_ARCHITETTURA.md` |

---

## 6. Workflow Git e Gestione dei Moduli (Lifecycle)

Il lavoro è strutturato in unità isolate (Moduli) per garantire la massima stabilità della cronologia di Git.

* **Gestione dei Branch:** I moduli di sviluppo avanzano su branch dedicati e isolati nominati con il pattern `module-N-descrizione` (es. `module-2-gacha`) o `fix-descrizione`. È vietato il push diretto sul branch protetto `main`.
* **Pull Request e Self-Review:** Al completamento di ogni sotto-obiettivo o modulo, si apre una Pull Request (PR) sul server remoto di GitHub. Prima di effettuare l'unione, lo sviluppatore esegue un'ispezione visiva riga per riga del pannello "Files changed" per intercettare refactoring orfani.
* **Strategia di Merge (Merge Commit):** Per preservare l'integrità storica e l'evidenza visiva della "bolla di lavoro" del modulo, i branch vengono fusi forzando la creazione di un merge commit (tramite interfaccia web di GitHub o in locale con flag `--no-ff`).
* **Tag Annotated (Pietre Miliari):** Al completamento stabile di ogni modulo, la release viene sigillata sul `main` applicando un tag annotato Git firmato contenente il riassunto logico (es. `git tag -a v2.0.0-gacha -m "Release Milestone Module 2: Procedural Skin Registry and Pity Engine"`).
* **Cleanup Post-Merge:** Subito dopo il completamento del merge con successo, i branch di lavoro remoti e locali associati al modulo chiuso devono essere rimossi.
* **Standard dei Commit (Conventional Commits):**
* `feat(modulo):` Introduzione di nuove funzionalità logiche o visive.
* `fix(modulo):` Correzione di bug di calcolo, rendering o anomalie statiche.
* `docs(modulo):` Modifiche o integrazioni alla cartella della documentazione.
* `chore(modulo):` Aggiornamento dipendenze, file d'ambiente o modifiche al `.gitignore`.


* **Messaggi di Commit:** In lingua inglese, utilizzando il tempo presente imperativo (es. `feat(gacha): implement soft pity probability incrementer`).

---

## 7. Gestione Semplificata della Chat AI (Anti-Allucinazione)

Regole pratiche per mantenere l'AI precisa senza appesantire il flusso di lavoro nel piano gratuito.

* **Commit Piccoli e Frequenti:** Appena una funzione o un widget compila senza errori ed esegue l'azione corretta, fai un commit Git locale. Questo congela il progresso sicuro.
* **Cambio Chat Tattico (Reset Contesto):** Quando la chat diventa troppo lunga, l'AI accumula "rumore" e comincia a dimenticare i dettagli o a proporre codice errato. Quando succede, chiedi all'AI un breve riassunto dello stato attuale (Dump) e incollo in una chat nuova per ripartire con prestazioni massime.
* **Modifiche Mirate:** L'AI deve evitare di riscrivere interi file se la modifica riguarda solo poche linee di codice, preferendo blocchi mirati per facilitare il lavoro dello sviluppatore.

```

---
