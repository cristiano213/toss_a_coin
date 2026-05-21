# Toss A Coin — Architettura Tecnica

**Stato:** Autoritativo / Stabile
**Versione:** 1.2 (Consolidamento Modulo 2 - Motore Gacha e Skin Procedurali)
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
├── ├── screens/
│    ├── main_navigation_hub.dart   # Scaffold con NavigationBar principale
│    ├── coin_flip_screen.dart      # Schermata di lancio e scommessa
│    ├── gacha_screen.dart          # Schermata simulatore ed estrazioni
│    └── collection/                # Sotto-sistema Modulo 3 (Nuovo)
│         ├── collection_hub_screen.dart # Hub con TabBar (Archivio vs Inventario)
│         ├── archive_page.dart          # Griglia totale di tutte le skin (Wiki)
│         └── inventory_page.dart        # Elenco skin possedute ed equipaggiamento
├── widgets/
│    ├── coin_visual.dart           # Renderizzatore 3D con Matrix4 e AnimatedBuilder
│    └── gacha_result_dialog.dart   # Overlay modale per la visualizzazione animata dei drop
└── main.dart                       # Bootstrapper dell'applicazione, iniezione e precaricamento SharedPreferences


## 2. Layer di Persistenza Locale (SharedPrefsRepository)
Per evitare letture asincrone bloccanti all'interno dei metodi `build` dei widget di Flutter, l'istanza hardware di `SharedPreferences` viene interamente risolta nel thread principale prima dell'esecuzione dell'albero dell'applicazione (Issue ID_001 Risolta).

### Schema di Persistenza dell'Inventario (SharedPreferences)
L'inventario delle skin viene segmentato su disco locale utilizzando chiavi separate prelevate dal registro immutabile `StorageKeys` in `constants.dart`:

1. **Skin Attiva (`StorageKeys.activeSkinId`):** Salva una stringa semplice contenente l'ID univoco della skin equipaggiata.
   - *Esempio di valore:* `"skin_classic_gold"`

2. **Sblocchi Completi (`StorageKeys.unlockedSkins`):** Salva una stringa JSON che rappresenta l'array serializzato di tutti i codici univoci posseduti dall'utente.
   - *Esempio di struttura sul disco:*
   ```json
   [
     "skin_classic_gold",
     "skin_classic_silver",
     "skin_neon_pulse"
   ]
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