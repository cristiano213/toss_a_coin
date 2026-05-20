# Toss A Coin — Architettura Tecnica

**Stato:** Autoritativo / Stabile
**Versione:** 1.1 (Consolidamento Modulo 1 - Navigazione e Persistenza)
**Aggiornato:** Maggio 2026
**Tecnologie:** Flutter (^3.11.5), Riverpod 2.5+, Shared Preferences.

## 1. Struttura dei File ad Albero Reale
lib/
├── core/
│    ├── theme.dart                 # Token cromatici Material 3 e stili dei componenti
│    └── constants.dart             # Chiavi di persistenza SharedPreferences e parametri Gacha
├── models/
│    ├── coin_state.dart            # Modello immutabile del modulo Coin Flip
│    ├── gacha_state.dart           # Storico estrazioni, contatori pity e pool
│    └── skin_model.dart            # Definizione strutturale delle skin procedurali
├── repositories/
│    └── shared_prefs_repository.dart # Layer I/O di persistenza sincrona/asincrona
├── providers/
│    ├── gem_provider.dart          # Stato economico del portafoglio dell'utente
│    ├── coin_provider.dart         # Logica di calcolo del volo e delle strisce statistiche
│    ├── gacha_provider.dart        # Calcolatore probabilistico del pity e delle estrazioni
│    └── inventory_provider.dart    # Gestore delle skin sbloccate ed equipaggiate
├── screens/
│    ├── main_navigation_hub.dart   # Scaffold con NavigationBar Material 3 per la gestione dei tab
│    ├── coin_flip_screen.dart      # Interfaccia di scommessa e animazione della moneta
│    ├── gacha_screen.dart          # Interfaccia di pull grafica dei tier a stelle (scheletro)
│    └── dashboard_screen.dart      # Lista inventario ed equipaggiamento skin attive (scheletro)
├── widgets/
│    ├── coin_visual.dart           # Renderizzatore 3D con Matrix4 e AnimatedBuilder
│    └── gacha_result_dialog.dart   # Overlay modale per la visualizzazione animata dei drop
└── main.dart                       # Bootstrapper dell'applicazione, iniezione e precaricamento SharedPreferences


## 2. Layer di Persistenza Locale (SharedPrefsRepository)
Per evitare letture asincrone bloccanti all'interno dei metodi `build` dei widget di Flutter, l'istanza hardware di `SharedPreferences` viene interamente risolta nel thread principale prima dell'esecuzione dell'albero dell'applicazione (Issue ID_001 Risolta).

### Schema di Serializzazione JSON dell'Inventario
L'inventario delle skin viene salvato sul disco locale all'interno di una stringa JSON sotto la chiave `toss_coin_inventory`.
```json
{
  "equipped_skin_id": "gold_legacy_01",
  "unlocked_skin_ids": [
    "gold_base",
    "silver_base",
    "neon_pulse_04",
    "gold_legacy_01"
  ]
}
Questa sezione mappa le dipendenze reattive ed economiche tra i componenti logici per evitare accoppiamenti ciclici distruttivi:

coinProvider -> inventoryProvider

Meccanismo: ref.watch(inventoryProvider)

Scopo: Rilevare istantaneamente il cambio della skin attiva per aggiornare i gradienti cromatici da passare al widget CoinVisual.

coinProvider -> gemProvider

Meccanismo: ref.read(gemProvider.notifier).addGems(int amount)

Scopo: Accreditare il premio al termine del timer di animazione del lancio scommessa (+100 per vittoria, +25 per sconfitta).

gachaProvider -> gemProvider

Meccanismo: ref.read(gemProvider.notifier).spendGems(int cost)

Scopo: Decurtare il costo del pull (100 o 1000 gemme). Se gemProvider riscontra un saldo insufficiente, blocca l'esecuzione sollevando un'eccezione prima di elaborare l'estrazione.

gachaProvider -> inventoryProvider

Meccanismo: ref.read(inventoryProvider.notifier).unlockSkin(String id)

Scopo: Registrare la nuova skin sbloccata nell'inventario persistente in caso di estrazione riuscita.


---

## 3. Stato Vivo e Allineamento Finale (`lib/docs/T1_STATO_PROGETTO.md`)

Per completare il quadro informativo ed essere pronti al 100% per il cambio chat, ecco come aggiorniamo l'ultimo file rimasto, inserendo i dati reali del **Modulo 1 Terminato** ed estendendo il tracciamento del Delta Modifiche:

```markdown
# Toss A Coin — Stato del Progetto e Configurazione Git

**Stato attuale:** Modulo 1 Terminato (Persistenza Hardware, Navigazione Hub e Allineamento Statico).
**Versione Logica:** 1.1
**Prossimo Obiettivo:** Inizializzazione Modulo 2 (Sviluppo logica ed estrazioni del Gacha Simulator).

## 1. Tracciamento Controllo Versione (Git Status)
- **Repository Remoto:** `https://github.com/IL_TUO_USERNAME/toss_a_coin.git`
- **Branch Principale Protettivo:** `main` (Pronto per ricevere il merge commit)
- **Branch di Lavoro Corrente:** `module-1-persistence`
- **Stato Staging:** Tutti i file di configurazione dell'Hub, i repository, i provider iniziali e i file di documentazione aggiornati (`T2_CONVENZIONI`, `T2_ARCHITETTURA`, `T1_PROBLEMI_APERTI`) sono pronti per essere consolidati.

## 2. Componenti Verificati e Stabili
1. **Modellazione dei Dati:** `CoinState` immutabile con supporto a strisce consecutive per Testa e Croce.
2. **Motore di Rendering:** `CoinVisual` corretto. Il bug di ancoraggio dell'angolo a fine corsa è stato risolto introducendo un bypass condizionale basato su `_controller.isAnimating`. La moneta risponde correttamente visualizzando la faccia d'argento (X) o d'oro (O).
3. **Logica Economica:** `GemNotifier` e `CoinNotifier` comunicano stabilmente in memoria tramite architettura reattiva Riverpod.
4. **Navigazione e Struttura:** `MainNavigationHub` funzionante con `NavigationBar` di Material 3. Gli scheletri delle schermate per l'Inventario e il Gacha sono integrati e non generano errori di importazione o variabili inutilizzate.
5. **Persistenza Hardware:** Inizializzazione asincrona di SharedPreferences inserita stabilmente nel `main.dart` con override del provider al boot zero dell'applicazione.

## 3. Delta Modifiche Correnti (Maggio 2026)
- Risolto errore statico `MainAxisAlignment.between` -> Corretto in `spaceBetween`.
- Eliminato metodo fittizio `BorderStyle.merge` dal container interno della moneta.
- Integrato parametro nullabile `CoinSide? prediction` all'interno del metodo `flipCoin`.
- Creata l'infrastruttura di navigazione a tab isolando gli import nativi di `antipanic_app`.
- Eseguito un audit completo sui file markdown della cartella `lib/docs/` per ripristinarele specifiche granulari ed evitare bias di compressione dei testi.