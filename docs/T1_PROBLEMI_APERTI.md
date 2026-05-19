# Toss A Coin — Problemi Aperti & Issue Tracking

**ID_001 | Inizializzazione Asincrona di SharedPreferences**
- **Sintomo:** All'avvio dell'app, i Notifier Riverpod provano a leggere istantaneamente il disco lanciando un errore di istanza non allocata.
- **Impatto:** Bloccante per lo sviluppo del Modulo 1.
- **Strategia di Risoluzione:** Modificare la firma del `main()` in `Future<void> main() async`, invocare `WidgetsFlutterBinding.ensureInitialized()`, pre-caricare l'istanza di SharedPreferences e passarla al container di Riverpod tramite un meccanismo di dependency injection strutturato con `overrideWithValue`.

**ID_002 | Astrazione Parametri Visivi per le Skin Procedurali**
- **Sintomo:** I gradienti visivi della moneta d'oro e d'argento sono attualmente scritti in modo fisso (*hardcoded*) dentro `theme.dart`.
- **Impatto:** Impedisce al Gacha di iniettare dinamicamente le nuove varianti estetiche sbloccate.
- **Strategia di Risoluzione:** Trasformare le skin in oggetti strutturati `SkinModel` contenenti liste di interi hexadecimali per i colori, mappati e passati al widget `CoinVisual` in base all'ID attivo nell'inventario dell'utente.