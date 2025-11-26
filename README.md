# Minor Blue Scale

Bluetooth body-scale app with vendor‑specific handlers (OKOK, Xiaomi Mi) and a generic Weight Scale GATT fallback. The app streams live weight/impedance, derives basic body composition, and stores per-user history.

## Features
- **Scale detection**: Filters to supported patterns only (OKOK broadcast, Mi Scale v1/v2, generic GATT Weight Service).
- **Live readings**: Weight + impedance (when available) mapped into a unified `Measurement`.
- **Body composition (est.)**: BMI, body fat %, fat mass, skeletal muscle %, muscle mass derived from user height/age/gender; impedance-based when possible, BMI fallback otherwise.
- **Broadcast OKOK flow**: One-tap “Measure” captures a short burst and stabilizes the value (median, rejects >0.3 kg swings).
- **History & multi-user**: Per-user storage (Hive), last-selection recall, guest mode (no persistence), chart and stats.
- **UI**: Live card + quick metrics chips, save to history, target comparisons.

## Architecture
- **State**: Provider.
- **BLE**: `flutter_blue_plus`.
- **Handlers**: `ScaleHandler` interface with `ScaleMatch` describing support. Implementations:
  - `OkOkHandler` – broadcast-only variants (V20/V11/VF0/0xC0), weight + impedance.
  - `MiScaleHandler` – GATT, v1/v2 detection, history/live notify, optional time sync.
  - `GenericGattHandler` – Weight Scale Service or readable/notifiable 2-byte fallback.
- **Measurement model**: `Measurement(weightKg, impedanceOhm)` feeds body-composition calculator.
- **Stabilization**: In `ScaleProvider.takeStableMeasurement()` for broadcast devices.

## Quick Start
```bash
flutter pub get
flutter run
```

## Project Layout (high level)
- `lib/`
  - `services/scale_handlers/` — device-specific parsers + generic handler
  - `services/ble_scale_service.dart` — scanning/connection orchestration
  - `providers/` — scale, user, history state
  - `screens/` — home, measure tab (live & controls), history tab (chart/list)
  - `utils/body_composition.dart` — composition formulas & BMI fallback
- `docs/PLAN.md` — original feature plan in Korean

## Development Notes
- Targeted platforms: Android/iOS (Flutter desktop/web scaffolding present but unverified).
- OKOK works via advertisements only; “Measure” triggers a short capture window instead of GATT pairing.
- Mi Scale uses notify on the history characteristic; impedance included when firmware provides it.

## License
This repository includes code derived from openScale handlers; consult upstream project license (GPLv3) if redistributing. All new code here follows the same compatibility expectations.***
