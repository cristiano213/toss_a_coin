# Toss A Coin — Visione Funzionale

**Stato:** Autoritativo / Stabile
**Versione:** 1.3 (Consolidamento Modulo 3 - Sotto-sistema Collezione)
**Aggiornato:** Maggio 2026

## 1. Ambito del Sistema
L'applicazione implementa un'economia circolare a due livelli (Generazione -> Spesa -> Modifica Estetica) basata interamente su logiche deterministiche e manipolazione grafica procedurale. Non è previsto l'uso di server centralizzati; tutta la progressione è registrata localmente.

## 2. Il Ciclo Economico (Core Loop)
1. **Coin Flip Screen (Generatore di Valuta):**
   - **Lancio Libero:** Animazione visiva slegata dal bilancio economico. Aggiorna unicamente i contatori statistici delle strisce consecutive di risultati identici.
   - **Lancio Scommessa (Testa o Croce):** Requires la selezione preventiva di un output pronosticato (`CoinSide`). Non ha costi di ingresso.
     - *Esito Vincente:* Erogazione immediata di +100 Gemme.
     - *Esito Perdente:* Erogazione immediata di +25 Gemme (meccanica di salvaguardia del tempo utente).

2. **Gacha Simulator Screen (Distruttore di Valuta):**
   - **Costi:** Pull Singolo = 100 Gemme. Multi-Pull (x10) = 1000 Gemme.
   - **Azione:** Estrazione casuale pesata con protezione statistica (Pity System) per lo sblocco di Skin procedurali.

3. **Inventory Screen / Collection Hub (Modificatore Visivo):**
   - Sostituisce la vecchia Dashboard d'ambiente con un ecosistema specializzato a due pagine gestito tramite `TabBar` nativa Material 3, integrato reattivamente nell'`IndexedStack` della navigazione principale.

## 3. Sotto-Sistema Collezione e Personalizzazione (Modulo 3)
La gestione delle skin sbloccate e la consultazione della pool applicativa vengono separate strutturalmente in due viste distinte per ottimizzare l'esperienza utente e garantire la massima scalabilità dell'interfaccia.

*Nota di Versione (v1.3):* L'attuale implementazione consolida l'infrastruttura logico-reattiva stabile (Riverpod Notifier) e i widget strutturali di base. I cicli successivi definiscono il restyling grafico evoluto per allontanare l'interfaccia dallo stato iniziale minimalista ed elevarla a qualità production-level.

### 3.1 Galleria Archivio (Vista Wiki)
- **Natura:** Sola lettura (*Read-Only*).
- **Sorgente Dati:** Intero registro immutabile `GachaPool.registry`.
- **Comportamento Visivo MVP Corrente:** Griglia standard a due colonne con mascheramento nativo `ColorFiltered` applicato alle card bloccate e rendering visivo semplice per quelle sbloccate.
- **Specifiche Restyling Completo (Fase Visiva Avanzata):**
  - **Rarità Comuni (3-Stelle):** Sfondo flat solido o micro-gradiente desaturato standard, con bordo sottile geometrico.
  - **Rarità Rare (4-Stelle):** Sfondi basati su gradienti metallici dinamici estratti in tempo reale dalle proprietà esadecimali di `SkinModel`, con maschere di opacità variabili e angoli di riflesso accentuati.
  - **Rarità Leggendarie (5-Stelle):** Card dotate di overlay grafici dinamici, animazioni di shimmer in background ed effetti di *Glow* (bagliore esterno) procedurale che proiettano un'ombra sfumata basata sul colore primario della skin stessa.
  - **Ottimizzazione Filtri:** Affinamento della matrice di trasformazione del `ColorFiltered` per preservare una leggibilità nitida del font anche in scala di grigi, aggiungendo un indicatore con barra di progressione della collezione globale in cima all'interfaccia.

### 3.2 Inventario Personale (Vista Loadout)
- **Natura:** Interattiva (*Read/Write*).
- **Sorgente Dati:** Filtrata reattivamente tramite `inventoryProvider` (`state.unlockedSkinIds`).
- **Comportamento Visivo MVP Corrente:** Lista verticale lineare che visualizza esclusivamente gli sblocchi locali ed offre un bottone per l'attivazione della skin.
- **Specifiche Restyling ed Effetti Estetici:**
  - Rimozione del layout standard in favore di un pannello interattivo in cui la skin attualmente equipaggiata non viene evidenziata da una semplice spunta, ma da una cornice pulsante animata dotata di gradiente ciclico.
  - Al momento del clic sul comando "Equipaggia", i token cromatici devono propagarsi fluidamente all'albero dei widget senza microscatti (*jank*) o ricaricamenti orfani.

### 3.3 Rarità e Distribuzione Base
Il sistema gestisce tre tier di sbloccabili visivi procedurali:
- **3-Stelle (Common - Skin Cromatiche Flat):** Probabilità base di drop = 80.0%
- **4-Stelle (Rare - Gradienti Metallici e Opacità Avanzate):** Probabilità base di drop = 18.0%
- **5-Stelle (Legendary - Effetti Glow Dinamici e Temi Interfaccia):** Probabilità base di drop = 2.0%

### 3.4 Algoritmo di Pity Dinamico (Soft & Hard Pity)
Il calcolo delle probabilità viene alterato dinamicamente a ogni pull consecutivo che non produce un drop 5-Stelle, tracciato dal contatore interno `pityCounter`.

1. **Fase Base (Pull da 1 a 50):** La probabilità di estrarre un 5-Stelle rimane fissa al 2.0%.
2. **Fase Soft Pity (Pull da 51 a 89):** Ad ogni pull fallito consecutivo dopo il 50esimo, la probabilità lineare del Tier 5-Stelle aumenta di un fattore fisso del +2.45% per pull, riducendo proporzionalmente la probabilità del Tier 3-Stelle.
   - Formula di incremento: $P(N) = 2\% + (N - 50) \\times 2.45\%$ (dove $N$ è il pull corrente).
3. **Fase Hard Pity (Pull 90):** La probabilità di estrazione del Tier 5-Stelle è forzata al 100.0%.
4. **Reset Intero:** All'estrazione di un qualsiasi oggetto Tier 5-Stelle, il valore di `pityCounter` viene istantaneamente resettato a 0, ripristinando le distribuzioni probabilistiche della Fase Base.

### 3.5 Requisiti di Flusso e Gestione Duplicati
- L'utente non può possedere duplicati della stessa Skin.
- Se l'algoritmo Gacha estrae un oggetto già presente nell'inventario locale dell'utente, l'oggetto viene convertito automaticamente in valuta di rimborso pari a 200 Gemme, iniettate direttamente nel saldo tramite chiamata sequenziale al `gemProvider`.

---

## 4. Roadmap Prossime Implementazioni (Modulo 3 - Fase Visiva)

Pianificazione dettagliata delle funzionalità estetiche per l'evoluzione strutturale del design:

### 4.1 Correzione delle Anomalie di Contrasto (Issue ID_003)
- **Obiettivo:** Risoluzione del problema visivo legato al tema *Void*. L'attuale accoppiamento cromatico genera una texture nero su nero sulla faccia di croce della moneta. I valori esadecimali verranno ri-calibrati nel registro `GachaPool` per garantire un distacco netto e una leggibilità eccellente dei dettagli grafici vettoriali.

### 4.2 Core Engine delle Animazioni
- **Transizioni di Navigazione:** Integrazione di pattern di movimento avanzati (es. *fade-through* o scorrimenti coordinati) per lo switch tra le pagine interne dell'Hub della collezione.
- **Feedback Tattile ed Visivo:** Sviluppo di un micro-effetto di espansione luminosa o flash particellare sul widget `CoinVisual` innescato nell'istante esatto dell'equipaggiamento, per confermare l'azione con un forte impatto d'interazione.

### 4.3 Estensione Tematica Globale dell'App
- Evoluzione del sistema per fare in modo che la skin attiva non alteri solo la moneta nel `CoinFlipScreen`, ma ridefinisca l'intero layout d'ambiente: i colori delle AppBar, i background degli Scaffold e le sfumature dei dialog di pull si adatteranno dinamicamente allo stile della skin equipaggiata, trasformando l'estetica dell'intera applicazione in tempo reale.

### Rarità e Distribuzione Base
Il sistema gestisce tre tier di sbloccabili visivi procedurali:
- **3-Stelle (Common - Skin Cromatiche Flat):** Probabilità base di drop = 80.0%
- **4-Stelle (Rare - Gradienti Metallici e Opacità Avanzate):** Probabilità base di drop = 18.0%
- **5-Stelle (Legendary - Effetti Glow Dinamici e Temi Interfaccia):** Probabilità base di drop = 2.0%

### Algoritmo di Pity Dinamico (Soft & Hard Pity)
Il calcolo delle probabilità viene alterato dinamicamente a ogni pull consecutivo che non produce un drop 5-Stelle, tracciato dal contatore interno `pityCounter`.

1. **Fase Base (Pull da 1 a 50):** La probabilità di estrarre un 5-Stelle rimane fissa al 2.0%.
2. **Fase Soft Pity (Pull da 51 a 89):** Ad ogni pull fallito consecutivo dopo il 50esimo, la probabilità lineare del Tier 5-Stelle aumenta di un fattore fisso del +2.45% per pull, riducendo proporzionalmente la probabilità del Tier 3-Stelle.
   - Formula di incremento: $P(N) = 2\% + (N - 50) \times 2.45\%$ (dove $N$ è il pull corrente).
3. **Fase Hard Pity (Pull 90):** La probabilità di estrazione del Tier 5-Stelle è forzata al 100.0%.
4. **Reset Intero:** All'estrazione di un qualsiasi oggetto Tier 5-Stelle, il valore di `pityCounter` viene istantaneamente resettato a 0, ripristinando le distribuzioni probabilistiche della Fase Base.

## 4. Requisiti di Flusso della Dashboard
- L'utente non può possedere duplicati della stessa Skin.
- Se l'algoritmo Gacha estrae un oggetto già presente nell'inventario locale dell'utente, l'oggetto viene convertito automaticamente in valuta di rimborso pari a 200 Gemme, iniettate direttamente nel saldo.