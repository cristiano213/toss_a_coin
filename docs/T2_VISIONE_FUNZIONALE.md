# Toss A Coin — Visione Funzionale

**Stato:** Autoritativo / Stabile
**Versione:** 1.0
**Aggiornato:** Maggio 2026

## 1. Ambito del Sistema
L'applicazione implementa un'economia circolare a due livelli (Generazione -> Spesa -> Modifica Estetica) basata interamente su logiche deterministiche e manipolazione grafica procedurale. Non è previsto l'uso di server centralizzati; tutta la progressione è registrata localmente.

## 2. Il Ciclo Economico (Core Loop)
1. **Coin Flip Screen (Generatore di Valuta):**
   - **Lancio Libero:** Animazione visiva slegata dal bilancio economico. Aggiorna unicamente i contatori statistici delle strisce consecutive di risultati identici.
   - **Lancio Scommessa (Testa o Croce):** Richiede la selezione preventiva di un output pronosticato (`CoinSide`). Non ha costi di ingresso.
     - *Esito Vincente:* Erogazione immediata di +100 Gemme.
     - *Esito Perdente:* Erogazione immediata di +25 Gemme (meccanica di salvaguardia del tempo utente).

2. **Gacha Simulator Screen (Distruttore di Valuta):**
   - **Costi:** Pull Singolo = 100 Gemme. Multi-Pull (x10) = 1000 Gemme.
   - **Azione:** Estrazione casuale pesata con protezione statistica (Pity System) per lo sblocco di Skin procedurali.

3. **Dashboard Screen (Modificatore Visivo):**
   - Visualizzazione dell'inventario degli oggetti posseduti.
   - Selezione ed equipaggiamento della Skin attiva, con sovrascrittura globale dei parametri cromatici ed identificativi della moneta nella schermata di lancio.

## 3. Specifiche Matematiche del Gacha System

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