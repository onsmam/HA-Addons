# NAS Dashboard

Persoonlijk dashboard geserveerd via Nginx.

## Instellen

1. Start de addon.
2. Plaats je bestanden in `share/nasdashboard/` via Samba of SSH.
3. Open het dashboard via de **Open Web UI** knop of `http://<ha-ip>:8081`.

```
share/
└── nasdashboard/
    ├── index.html
    └── ...
```

Wijzigingen zijn direct zichtbaar na het herladen van de pagina — de addon hoeft niet herstart te worden.
