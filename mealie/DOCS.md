# Mealie

Zelf-gehoste receptenmanager met meal planning, boodschappenlijst en importeren van recepten via URL.

## Eerste gebruik

1. Start de addon.
2. Open de web interface via **Ingress** (knop "Open Web UI" in de addon) of via `http://<ha-ip>:9000`.
3. Log in met de standaard inloggegevens uit de addon opties.
4. **Verander het wachtwoord direct na de eerste login.**

## Opties

| Optie | Standaard | Beschrijving |
|-------|-----------|--------------|
| `data_dir` | `/share/mealie` | Map waar Mealie data (database, afbeeldingen) opslaat |
| `base_url` | _(leeg)_ | Externe URL als je Mealie bereikbaar maakt via een reverse proxy |
| `allow_signup` | `false` | Sta zelf-registratie van nieuwe Mealie-gebruikers toe |
| `visible_for_all_users` | `false` | Mealie zichtbaar in de HA-sidebar voor alle HA-gebruikers (`true`) of alleen voor admins (`false`) |
| `default_email` | `changeme@example.com` | E-mailadres van de standaard admin |
| `default_password` | `changeme` | Wachtwoord van de standaard admin |

## Data structuur

```
share/
└── mealie/
    ├── mealie.db       (SQLite database)
    └── data/
        └── ...         (afbeeldingen, exports)
```

## OIDC / Single Sign-On

Met OIDC kunnen gebruikers inloggen met een bestaand account van een externe identity provider (zoals Authentik, Authelia, Google, of een andere OIDC-provider) in plaats van een apart Mealie-wachtwoord.

| Optie | Standaard | Beschrijving |
|-------|-----------|--------------|
| `oidc_auth_enabled` | `false` | OIDC inschakelen |
| `oidc_configuration_url` | _(leeg)_ | Discovery URL van je OIDC-provider (eindigt op `/.well-known/openid-configuration`) |
| `oidc_client_id` | _(leeg)_ | Client ID uit je OIDC-provider |
| `oidc_client_secret` | _(leeg)_ | Client secret uit je OIDC-provider |
| `oidc_provider_name` | `SSO` | Naam op de inlogknop in Mealie |
| `oidc_signup_enabled` | `true` | Nieuwe Mealie-gebruikers automatisch aanmaken bij eerste OIDC-login |
| `oidc_auto_redirect` | `false` | Meteen doorsturen naar OIDC-login zonder Mealie-loginscherm |

### Voorbeeld met Authentik

1. Maak een nieuwe **OAuth2/OIDC Provider** aan in Authentik
2. Noteer de **Client ID** en **Client Secret**
3. Vul als `oidc_configuration_url` in:
   ```
   https://jouw-authentik.domein/application/o/mealie/.well-known/openid-configuration
   ```

## Reverse proxy

Als je Mealie via een domeinnaam wil bereiken, vul dan `base_url` in, bijvoorbeeld:

```
https://mealie.mijndomein.nl
```
