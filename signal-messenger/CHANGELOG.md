# Changelog

## 0.102
- Update naar [bbernhard/signal-cli-rest-api v0.102](https://github.com/bbernhard/signal-cli-rest-api/releases/tag/0.102)
- Aangepast aan het nieuwe upstream image (draait als `signal-api` met s6-overlay i.p.v. `/entrypoint.sh`)
- Rechten op `/config` worden bij elke start goedgezet voor de `signal-api` gebruiker
- `auto_receive` vervangen door `auto_receive_schedule` (cron); de oude optie werd door upstream niet gebruikt
- `cmd_timeout` en `auto_receive_schedule` worden niet meer doorgegeven in json-rpc modi (upstream stopt daar anders met een fout)

## 0.100
- Update naar [bbernhard/signal-cli-rest-api v0.100](https://github.com/bbernhard/signal-cli-rest-api/releases/tag/0.100)

## 0.99
- Initiële release van deze addon
- Gebaseerd op [bbernhard/signal-cli-rest-api v0.99](https://github.com/bbernhard/signal-cli-rest-api/releases/tag/0.99)

---

Bekijk de volledige release notes van de onderliggende applicatie op:
**https://github.com/bbernhard/signal-cli-rest-api/releases**
