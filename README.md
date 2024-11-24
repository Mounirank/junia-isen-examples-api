# Examples API

Simple API that returns example records from a database.

## Prerequisites

- you need to install [uv](https://docs.astral.sh/uv/guides/install-python/)
- you must have a PostgreSQL instance available with an `example` table

## Installation

```shell
# Install Python in the right version
uv python install

# Install dependencies and create virtual env
uv sync
```

## Run

```shell
# Export environment variables to connect to the PostgreSQL database...
export DATABASE_HOST=
export DATABASE_PORT=
export DATABASE_NAME=
export DATABASE_USER=
export DATABASE_PASSWORD='' # Use single quotes to avoid shell interpolation with characters like $ or #
# ...and the storage account
export STORAGE_ACCOUNT_URL=

# Run the application
uv run fastapi dev examples/examples.py
```

## Run tests

```
uv run pytest tests/
```

They go on:

- http://localhost:8000/docs
- http://localhost:8000/
- http://localhost:8000/examples


# Rapport de Mise en Place Infrastructure et CI/CD - API JUNIA ISEN

## MEMBRE DU GROUPE: 
NKAYERE Mounira, KAMDEM Samira


## 1. Objectifs du Projet
- Provisionner l'infrastructure Azure pour une API
- Mettre en place un pipeline CI/CD avec GitHub Actions
- Assurer une communication sécurisée entre les composants

## 2. Infrastructure Azure déployée
### 2.1 Resources Group
- Nom: `junia-isen-api-rg`
- Location: France Central
- Tags appropriés pour l'environnement

### 2.2 Réseau
- Virtual Network avec espace d'adressage `10.0.0.0/16`
- Subnet App Service : `10.0.1.0/24`
- Subnet Database : `10.0.2.0/24`
- Configuration DNS privée pour PostgreSQL

### 2.3 Stockage
- Compte de stockage : `juniaisenapisa`
- Container blob public pour l'API
- Configuration simple sans restrictions réseau

### 2.4 App Service
- Plan : B1 (basique)
- Configuration Docker pour le déploiement
- Variables d'environnement pour les connexions

## 3. Configuration Locale
### 3.1 Environnement de Développement
```yaml
services:
  db:
    image: postgres:15
    environment:
      POSTGRES_USER: nkayere
      POSTGRES_PASSWORD: Mounira18
      POSTGRES_DB: junia_db
  pgadmin:
    image: dpage/pgadmin4
```

### 3.2 Base de Données
```sql
CREATE TABLE examples (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);
```

## 4. Pipeline CI/CD
### 4.1 Workflow Pull Request
- Déclenchement sur PR vers main
- Tests automatisés avec PostgreSQL en container
- Validation de la qualité du code

### 4.2 Workflow Déploiement
- Déclenchement sur push vers main
- Build et push de l'image Docker
- Déploiement sur Azure App Service
- Configuration des variables d'environnement

## 5. Difficultés Rencontrées

### 5.1 Infrastructure Azure
1. **Zones de disponibilité**
   - Erreur initiale avec les zones dans France Central
   - Solution : Retrait de la configuration de zone
   - credit azure fini don cplus accès aux ressources 🥲🥲🥲

2. **Configuration Réseau**
   - Problèmes initiaux avec les service endpoints
   - Simplification de l'architecture réseau

### 5.2 Développement Local
1. **Docker Desktop**
   - Problèmes de démarrage initiaux
   - Résolution par vérification du service

2. **PgAdmin Connection**
   - Erreur de connexion avec localhost
   - Solution : Utilisation de l'host "db"


## 7. État Actuel
- ✅ Infrastructure déployée ( blob storage, db, vnet )
- ✅ Environnement local fonctionnel
- ✅ Pipeline CI/CD configuré
- ✅ Tests automatisés en place
- ✅ Documentation en place


## 9. Commandes Importantes
```bash
# Infrastructure
terraform init
terraform plan
terraform apply

# Local Development
docker-compose up -d
uv run fastapi dev examples/examples.py

# CI/CD
git push origin main  # Déclenche le déploiement
```