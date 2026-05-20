# Toss A Coin — Problemi Aperti & Issue Tracking

**Tier 1 — Documento dinamico di stato.** Aggiornare al variare delle anomalie.
**Versione:** 1.1 (Modulo 1 - Chiusura Issue Inizializzazione)
**Aggiornato:** Maggio 2026

> **Scope di questo file**: Tracciamento rigoroso dei bug architetturali, anomalie visive e limitazioni tecniche del codice. Ogni anomalia ha un ID univoco e viene spostata nella sezione "Risolti" solo dopo la verifica statica (`flutter analyze`).

---

## 1. Issue Attive e Pendenti

### ID_002 | Astrazione Parametri Visivi per le Skin Procedurali
* **Sintomo:** I gradienti visivi della moneta d'oro e d'argento sono attualmente scritti in modo fisso (*hardcoded*) dentro `theme.dart`.
* **Impatto:** Impedisce al Gacha di iniettare dinamicamente le nuove varianti estetiche sbloccate.
* **Strategia di Risoluzione:** Trasformare le skin in oggetti strutturati `SkinModel` contenenti liste di interi hexadecimali per i colori, mappati e passati al widget `CoinVisual` in base all'ID attivo nell'inventario dell'utente.
* **Stato:** Aperto (Pendente per lo sviluppo della logica del Gacha e dell'Inventario).

---

## 2. Storico delle Issue Risolte

### ID_001 | Inizializzazione Asincrona di SharedPreferences
* **Sintomo:** All'avvio dell'app, i Notifier Riverpod provano a leggere istantaneamente il disco lanciando un errore di istanza non allocata.
* **Impatto:** Bloccante per lo sviluppo del Modulo 1.
* **Strategia di Risoluzione:** Modificare la firma del `main()` in `Future<void> main() async`, invocare `WidgetsFlutterBinding.ensureInitialized()`, pre-caricare l'istanza di SharedPreferences e passarla al container di Riverpod tramite un meccanismo di dependency injection strutturato con `overrideWithValue`.
* **Risoluzione Effettiva (Maggio 2026):** Implementato con successo durante il completamento del Modulo 1. L'istanza hardware nativa viene catturata in modo asincrono nel thread principale all'interno del file `lib/main.dart` prima del frame zero ed iniettata tramite `overrideWithValue` dentro `sharedPrefsRepositoryProvider`, garantendo l'accesso sincrono immediato ai dati locali a tutti i Notifier.
* **Stato:** RISOLTO (Verificato con `flutter analyze`).