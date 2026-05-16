# Signal Messenger

REST API voor Signal Messenger in Home Assistant, gebaseerd op [signal-cli-rest-api](https://github.com/bbernhard/signal-cli-rest-api) door **[@bbernhard](https://github.com/bbernhard)**.

## Registratie

Na het starten moet je je telefoonnummer registreren of een apparaat koppelen.

### Optie 1: Nieuw nummer registreren
```
POST http://<ha-ip>:8080/v1/register/<jouw-nummer>
```

### Optie 2: Koppelen als secundair apparaat (aanbevolen)
1. Ga naar `http://<ha-ip>:8080/v1/qrcodelink?device_name=homeassistant`
2. Scan de QR-code in Signal op je telefoon via **Instellingen → Gekoppelde apparaten → Apparaat koppelen**

> **Let op:** gebruik het IP-adres van je HA machine, niet `localhost` of `127.0.0.1`.

## Home Assistant integratie

Gebruik in `configuration.yaml`:
```yaml
notify:
  - name: signal
    platform: signal_messenger
    url: "http://<ha-ip>:8080"
    number: "+31612345678"
    recipients:
      - "+31698765432"
```

## Opties

| Optie | Standaard | Beschrijving |
|-------|-----------|--------------|
| `mode` | `native` | Uitvoermodus (zie hieronder) |
| `auto_receive` | `true` | Automatisch berichten ophalen |
| `cmd_timeout` | `60` | Timeout in seconden per commando |
| `log_level` | `info` | Logniveau |

### Modi

| Modus | Beschrijving |
|-------|-------------|
| `normal` | Stabielst, langzaamst |
| `native` | Sneller, lager geheugenverbruik (aanbevolen) |
| `json-rpc` | Snelst, hogere geheugengebruik |
| `json-rpc-native` | Snelst én laagste geheugengebruik |

## Credits

Deze addon is een wrapper om [signal-cli-rest-api](https://github.com/bbernhard/signal-cli-rest-api) van **[@bbernhard](https://github.com/bbernhard)**. Alle eer gaat naar hem voor het bouwen en onderhouden van dit project.
