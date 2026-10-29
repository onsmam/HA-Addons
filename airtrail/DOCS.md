# AirTrail

Persoonlijke vluchten-tracker ([AirTrail](https://github.com/johanohly/AirTrail)).

## Vereisten

- De **Teslamate Database** addon moet draaien. AirTrail gebruikt dezelfde PostgreSQL-server.

## Database

Bij elke start maakt de addon, als ze nog niet bestaan:

- user `airtrail` (geen superuser)
- database `airtrail` (eigenaar `airtrail`)
- extensie `unaccent` in de `airtrail` database

De `teslamate` database wordt niet aangeraakt. De `airtrail` user heeft geen rechten op Teslamate-tabellen.

Let op: een backup van alleen de `teslamate` database (`pg_dump teslamate`) bevat de AirTrail-data niet. Back-up de `airtrail` database apart, of de hele map `share/teslamate/db/`.

## Opties

| Optie | Omschrijving |
| ----- | ------------ |
| `port` | Poort van de webinterface (standaard `3000`). Aanpassen als de poort al bezet is. |
| `origin` | De exacte URL waarmee je AirTrail opent, inclusief poort, bv. `http://homeassistant.local:3000`. Moet overeenkomen met de adresbalk, anders werkt inloggen niet. |
| `teslamate_db_password` | Wachtwoord van de `teslamate` user, gelijk aan `db_password` van de Teslamate Database addon. Alleen gebruikt om de `airtrail` user/database aan te maken. |
| `airtrail_db_password` | Wachtwoord voor de `airtrail` database-user. Wordt bij elke start ingesteld, dus wijzigen kan op elk moment. |

## Data

- Uploads (airline-iconen): `share/airtrail/uploads/`

## Eerste start

Open AirTrail op de ingestelde `origin` en maak het eerste account aan; dit wordt de eigenaar.
Bij de eerste start wordt de luchthavendatabase gedownload, dat kan even duren.
