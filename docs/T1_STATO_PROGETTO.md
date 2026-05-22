# Toss A Coin — Stato del Progetto e Configurazione Git

**Stato attuale:** Modulo 3 - Fase Strutturale Completata (Linguaggio Riverpod 2.5 Notifier consolidato, integrazione della navigazione e scomposizione a doppia pagina Galleria/Loadout pienamente funzionante e stabile).
**Versione Logica:** 1.3
**Prossimo Obiettivo:** Modulo 3 - Fase Visiva e Analitica (Risoluzione del contrasto del Tema Void, restyling avanzato dei materiali procedurali delle monete, implementazione animazioni/temi globali, aggiunta della UI per lo storico/statistiche e integrazione del sistema di logging/audit per la verifica matematica dell'RNG e del Pity System).

## 1. Tracciamento Controllo Versione (Git Status)
- **Repository Remoto:** `https://github.com/cristiano213/toss_a_coin.git`
- **Branch Principale Protettivo:** `main` (Pronto a ricevere l'unione del codice tramite Pull Request)
- **Branch di Lavoro Corrente:** `module-3-inventory`
- **Stato Staging:** Le modifiche logiche sull'inventario, i tre file strutturali della UI nella sottocartella della collezione e i file di documentazione di contesto (`T1_PROBLEMI_APERTI`, `T1_STATO_PROGETTO`, `T2_ARCHITETTURA`, `T2_VISIONE_FUNZIONALE`) sono pronti per essere sottomessi su GitHub per l'apertura della Pull Request formale.

## 2. Componenti Verificati e Stabili
1. **Modellazione dei Dati:** `InventoryState` immutabile con gestione efficiente degli sblocchi unici tramite `Set<String>`.
2. **Logica di business (BMM):** Refactoring completo di `InventoryNotifier` basato sulla sintassi moderna `Notifier` di Riverpod 2.5+, garantendo l'accesso sincrono pulito alle SharedPreferences senza costruttori asincroni instabili.
3. **Persistenza Hardware:** Segmentazione sicura della memoria locale su chiavi separate (`StorageKeys.activeSkinId` e `StorageKeys.unlockedSkins`) anziché JSON monolitici instabili.
4. **UI ed Esperienza Utente:** Scomposizione della Dashboard nell'architettura a due pagine: **Archivio Wiki** (sola lettura con mascheramento nativo `ColorFiltered` delle skin bloccate) e **Equipaggiamento** (interattivo con aggiornamento reattivo immediato).

## 3. Delta Modifiche Correnti (Maggio 2026)
- Migrato l'intero file `inventory_provider.dart` alla sintassi `Notifier`.
- Aggiornato ed emendato il file `inventory_screen.dart` come Hub centrale basato su `DefaultTabController` e `TabBar` Material 3, preservando l'integrità dell'`IndexedStack` nel `MainNavigationHub`.
- Sviluppate in isolamento atomico le viste `archive_page.dart` e `inventory_page.dart`.
- Risolto l'errore di compilazione dell'SDK Flutter relativo al costruttore costante di `ColorFilter`, sostituendolo con matrici identità esplicite in linea.   