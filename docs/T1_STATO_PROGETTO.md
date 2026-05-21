# Toss A Coin — Stato del Progetto e Configurazione Git

**Stato attuale:** Modulo 2 Terminato (Motore Gacha, Pity System Matematico e UI delle Card Procedurali consolidati).
**Versione Logica:** 1.2
**Prossimo Obiettivo:** Inizializzazione Modulo 3 (Sviluppo Schermata Inventario, Equipaggiamento real-time e Persistenza su disco dei moduli economici).

## 1. Tracciamento Controllo Versione (Git Status)
- **Repository Remoto:** `https://github.com/IL_TUO_USERNAME/toss_a_coin.git`
- **Branch Principale Protettivo:** `main` (Pronto per ricevere il merge commit)
- **Branch di Lavoro Corrente:** `module-2-gacha`
- **Stato Staging:** Tutti i file di configurazione dell'Hub, i repository, i provider iniziali e i file di documentazione aggiornati (`T2_CONVENZIONI`, `T2_ARCHITETTURA`, `T1_PROBLEMI_APERTI`) sono pronti per essere consolidati tramite Pull Request su GitHub.

## 2. Componenti Verificati e Stabili
1. **Modellazione dei Dati:** `CoinState` immutabile e `GachaState` per i contatori incrementali di pity e drops recenti.
2. **Motore di Rendering:** `CoinVisual` svincolato dal tema scuro, guidato dalle proprietà esadecimali procedurali di `SkinModel`.
3. **Registro Centrale Gacha Pool:** `GachaPool` immutabile in `constants.dart` con varianti Common, Rare e Legendary.
4. **Logica Economica e Probabilistica:** `GemNotifier` e `GachaNotifier` integrati con Soft Pity lineare (+2.45%) e Hard Pity garantito al 90° pull.
5. **UI ed Esperienza Utente:** `GachaScreen` reattiva, dotata di monitoraggio gemme e rendering dei drop estratti dalla pool.

## 3. Delta Modifiche Correnti (Maggio 2026)
- Sviluppata la logica Gacha con calcolo probabilistico in `gacha_provider.dart`.
- Reso `CoinVisual` dipendente da `SkinModel` e ripulito `theme.dart`.
- Risolti errori statici sintattici (`TextAlign.center`, `spaceBetween`) in `GachaScreen` e rimossi i `const` ridondanti.
- Eseguito un audit completo, issue ID_002 chiusa ufficialmente e file di stato architetturale allineati alla versione 1.2.