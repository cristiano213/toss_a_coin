# Toss A Coin — Convenzioni operative e regole di interazione

**Tier 2 — Documento stabile.** Caricare all'inizio di ogni sessione.
**Versione:** 1.1 (Integrazione Workflow Git, AI Protocol e Sicurezza Import)
**Aggiornato:** Maggio 2026

> **Scope di questo file**: convenzioni **progetto-specifiche** di Toss A Coin (Flutter, Riverpod, Local SharedPreferences, Shading/Rendering Procedurale). Per workflow trasversali (Git, AI, efficienza sessione), questo file fa da dizionario normativo e mappa di autorità unica per la chat.

---

## 0. Natura del progetto

Toss A Coin — Collector Edition è un'applicazione ludico-collezionistica di livello **production-quality**. Anche se l'interfaccia si basa su un ciclo di gioco focalizzato (Lancio moneta ↔ Spesa Gacha), ogni componente architetturale deve respektare standard professionali rigorosi (immutabilità dello stato, isolamento dei calcoli deterministici, assenza di microscatti nella UI).

I compromessi da codice "demo" sono vietati: la logica matematica delle probabilità e la fluidità delle trasformazioni 3D a 60fps sono i pilastri del progetto.

**Stack Tecnologico:**
* Flutter (SDK ^3.11.5) + Dart
* Riverpod 2.5+ (state management reattivo e dependency injection)
* SharedPreferences (persistenza hardware locale sincrona/asincrona via JSON)
* Costrutti nativi di rendering: `Matrix4`, `AnimatedBuilder`, `CustomPainter`

**REGOLA RIGIDA DI SICUREZZA DEGLI IMPORT:**
Il nome nativo del pacchetto generato tramite `flutter create` è `antipanic_app`. Questo nome è strutturale e non deve mai essere modificato o rimosso dagli import assoluti esistenti. Tuttavia, per garantire la massima portabilità del codice e prevenire rotture dell'IDE durante i refactoring, all'interno delle cartelle di sviluppo si devono utilizzare tassativamente gli **import relativi** (`../` o `./`).

---

## 1. Disposizioni dell'utente e Approccio Didattico

### 1.1 Modalità operativa
* **Procediamo passo passo:** Sviluppo atomico, un modulo o un file critico alla volta. Aspettare la conferma di compilazione ed esecuzione prima di avanzare.
* **Spiegazioni tecniche mirate:** Evitare spiegazioni sui fondamentali ovvi di Dart. Concentrarsi su algebra delle matrici, flussi di sincronizzazione dei provider e ottimizzazioni di memoria.
* **Script completi ed espliciti:** Fornire blocchi di codice pronti per la sostituzione totale dei file, evitando frammenti orfani ("// inserisci qui il resto").
* **Diagnosi rigorosa:** In caso di bug visivi o logici (es. disallineamento rotazione), analizzare prima lo stato matematico (sintomo/causa/fix) prima di proporre codice correttivo.
* **Niente preconfigurazioni user-friendly limitanti:** Il codice deve essere esplicito, tipizzato e aperto al totale controllo dello sviluppatore. Le scorciatoie sintattiche che nascondono la logica sono vietate.
* **Evidence before claims:** L'AI non deve mai assumere o dichiarare un problema come "risolto" o "funzionante" senza aver prima richiesto all'utente di eseguire verifiche statiche sul terminale locale (`flutter analyze`) o test unitari.

### 1.2 Pattern di spiegazione fisso
Per ogni step implementativo o strutturale, rispettare la tassonomia:
1. **Cosa:** L'obiettivo in una singola frase tecnica.
2. **Perché:** Il problema architetturale o computazionale risolto.
3. **Concetti coinvolti:** I termini specifici in gioco (es. *Hard Pity*, *Matrix Entry*, *Asynchronous Preload*).
4. **Pre-requisiti:** File o stati che devono essere già consolidati.
5. **Codice:** Completo, tipizzato, commentato in lingua inglese solo dove la logica non è immediata.
6. **Verifica:** Istruzioni per testare l'output (Hot Reload, controlli su console, flussi UI).
7. **Cosa hai imparato:** Fissaggio teorico della meccanica.

---

## 2. Convenzioni Flutter e Architettura del Codice

### 2.1 Struttura del Progetto
L'albero delle directory deve rispettare tassativamente la segmentazione per responsabilità:
lib/
├── core/           # Token cromatici (theme.dart), costanti hardware e chiavi stringa (constants.dart)
├── models/         # Classi dati immutabili (coin_state.dart, gacha_state.dart, skin_model.dart)
├── repositories/   # Layer I/O hardware isolato (shared_prefs_repository.dart)
├── providers/      # State management e logica di business (gem_provider.dart, coin_provider.dart)
├── screens/        # Schermate principali dell'app (Navigation Hub, Coin, Gacha, Dashboard)
└── widgets/        # Componenti grafici isolati e performanti (coin_visual.dart)


### 2.2 Modelli Dati (`models/`)
* **Immutabilità Totale:** Tutti i campi devono essere dichiarati `final`. Costruttori contrassegnati como `const`.
* **Metodi Obbligatori:** Ogni modello deve implementare un metodo `copyWith()` per le mutazioni di stato e i metodi di serializzazione `fromJson()` / `toJson()` per il salvataggio su stringa JSON.
* **Naming:** CamelCase rigoroso nel codice Dart. La conversione da chiavi stringa del database locale avviene esclusivamente nelle funzioni di factory.

### 2.3 State Management (Riverpod)
* **Top-Level Constants:** Tutti i provider sono istanziati come costanti globali non inserite dentro classi.
* **Scelta del Provider:**
  * `Notifier` / `StateNotifier`: Per stati sincroni complessi che richiedono metodi di mutazione (`GemNotifier`, `CoinNotifier`, `InventoryNotifier`).
  * `Provider` (Read-only): Per esporre istanze immutabili o calcolate, o repository hardware precaricati.
* **Consumo dei Segnali:** `ref.watch` tassativo all'interno dei metodi `build` per garantire la reattività. `ref.read` limitato esclusivamente alle closure delle azioni utente (funzioni `onPressed`, callback asincrone).
* **Naming Standard:** Nome dell'istanza in camelCase terminante in `Provider` (es. `coinProvider`). Nome della classe in PascalCase terminante in `Notifier` (es. `CoinNotifier`).

---

## 3. Convenzioni Grafiche e di Rendering (UI Procedurale)

* **Zero Asset Esterni:** Tutti gli elementi della moneta, riflessi, ombreggiature e animazioni di contorno devono essere procedurali. Utilizzare `BoxDecoration`, `LinearGradient`, `BoxShadow` e trasformazioni geometriche nello space tridimensionale.
* **Bypass dell'Angolo di Rotazione:** I widget di animazione 3D (`Transform`) devono scindere lo stato matematico dinamico dallo stato statico definitivo. Durante il volo si utilizza l'interpolazione del controller; a controller fermo, la sorgente di verità assoluta è il valore enum (`CoinSide`) estratto dal provider, per evitare disallineamenti speculari.
* **Layout Stabile ad Altezza Fissa:** I componenti dell'interfaccia che compaiono o scompaiono condizionalmente (es. pulsanti visibili solo quando la moneta è ferma) devono essere racchiusi in container a dimensione fissa (`SizedBox`) per prevenire scatti distruttivi del layout verticale (*Layout Shifts*).
* **Disposizioni sui Colori:** Nessun colore deve essere hardcoded all'interno delle Schermate (`screens/`). Utilizzare esclusivamente `Theme.of(context)` o i token semantici centralizzati nel sistema dei temi.

---

## 4. Convenzioni di Persistenza e Sicurezza Locale

* **Il Client è l'Unica Difesa:** Poiché l'applicazione opera in modalità offline-first, le funzioni di controllo sulla valuta (es. verifica saldo gemme prima di un pull) risiedono all'interno del codice logico dei Notifier e non nella UI.
* **Inizializzazione Sincrona all'Avvio (Issue ID_001):** L'istanza di `SharedPreferences` deve essere risolta in modo asincrono all'interno del metodo `main()` prima di invocare `runApp()`. L'istanza pronta viene iniettata nel container di Riverpod tramite l'overriding del provider di riferimento (`sharedPrefsRepositoryProvider`), consentendo a tutti i Notifier l'accesso sincrono immediato ai dati di salvataggio al frame zero.
* **Prevenzione dei Duplicati nel Gacha:** La logica del codice deve verificare la presenza di una skin nell'inventario locale prima dell'assegnazione. In caso di riscontro positivo, deve eseguire la conversione matematica automatica in valuta di rimborso (gemme).

---

## 5. Mappa di Autorità Unica Documentale (One-Place Rule)

Ogni regola, dato architetturale o specifica matematica risiede in un solo file dedicato. È vietato duplicare le informazioni.

| Tipologia di Contenuto | File Autoritativo di Riferimento |
| --- | --- |
| **Stato Corrente del Progetto** | `lib/docs/T1_STATO_PROGETTO.md` |
| **Bug Tracking & Issue Pendenti** | `lib/docs/T1_PROBLEMI_APERTI.md` |
| **Norme di Scrittura e Standard** | `lib/docs/T2_CONVENZIONI.md` *(Questo File)* |
| **Visione di Gioco e Formule Pity** | `lib/docs/T2_VISIONE_FUNZIONALE.md` |
| **Albero Cartelle e Relazioni Provider** | `lib/docs/T2_ARCHITETTURA.md` |

---

## 6. Workflow Git e Gestione dei Moduli (Lifecycle)

Il lavoro è strutturato in unità isolate (Moduli) per garantire la tracciabilità storica e la stabilità del branch principale.
* **Gestione dei Branch:** I moduli di sviluppo avanzano esclusivamente su branch dedicati e isolati nominati con il pattern `module-N-descrizione` (es. `module-1-persistence`) o `fix-descrizione`. È vietato il push diretto su `main`.
* **Pull Request e Self-Review:** Ogni volta che si completa un sotto-obiettivo o un modulo, si apre una Pull Request (PR) verso `main`. Prima dell'unione, lo sviluppatore esegue un'ispezione visiva del diff complessivo per scovare codice orfano o refactoring incompleti.
* **Strategia di Merge (Merge Commit):** Per preservare l'integrità storica e la visibilità della "bolla di lavoro" del modulo, i branch vengono uniti su GitHub o localmente forzando la creazione di un merge commit (`git merge --no-ff`), facilitando eventuali operazioni di rollback totali.
* **Tag Annotated (Pietre Miliari):** Al completamento stabile di ogni modulo, la release viene sigillata sul `main` applicando un tag annotato Git firmato (es. `git tag -a v1.0-navigation-hub -m "Consolidamento navigazione e persistenza hardware Modulo 1"`).
* **Cleanup post-merge:** Subito dopo il completamento del merge con successo, i branch di lavoro remoti e locali devono essere rimossi per mantenere pulito l'ambiente.
* **Standard dei Commit (Conventional Commits):**
  * `feat(gacha):` Introduzione di nuove funzionalità logiche o visive.
  * `fix(coin):` Correzione di bug di calcolo, rendering o anomalie di stato.
  * `docs(architecture):` Modifiche o integrazioni alla cartella `lib/docs/`.
  * `chore(config):` Aggiornamento dipendenze, file `.gitignore` o configurazioni dell'ambiente.
* **Messaggi:** Scritti tassativamente in lingua inglese, utilizzando il tempo presente imperativo (es. `feat(wallet): implement shared preferences encryption adapter`).

---

## 7. Efficienza delle Sessioni e Interazione con l'AI

* **Unità di Commit Significativa:** Le chat devono essere focalizzate e brevi. Ogni volta che un file o un sotto-modulo supera i controlli statici di compilazione e viene registrato con un commit Git di successo, si valuta la chiusura della sessione corrente.
* **Pattern Dump-Clear-Resume:** Se la chat si allunga e il consumo della finestra di contesto supera la soglia stimata del 60%, l'AI deve generare un riassunto tecnico ad alta densità (Dump). L'utente chiuderà la chat (Clear) e aprirà una nuova sessione (Resume) incollando il dump per azzerare la latenza e i costi di calcolo.
* **Aggiornamenti in formato Diff:** Quando l'AI modifica i file di stato temporanei (`T1