# Analyse Consolidée : Revenu, Réservations et Utilisateurs par Mois

## **Description**

Cette requête SQL fournit une analyse consolidée des principaux indicateurs mensuels pour une entreprise de voyage en ligne. Elle combine trois métriques essentielles :

1. **Revenu mensuel par type** (hôtel et voiture).
2. **Nombre de réservations mensuelles par type** (hôtel et voiture).
3. **Nombre d’utilisateurs inscrits chaque mois**.

Le résultat final est une table unifiée contenant les valeurs agrégées par mois et par type, ce qui facilite l’analyse et la visualisation.

---

## **Structure de la Requête**

### **1. Revenu par Mois et par Type**
- **CTEs concernées :**
  - `car_profit` : Calcule le revenu généré par les réservations de voitures.
  - `hotel_profit` : Calcule le revenu généré par les réservations d’hôtels.

- **Logique :**
  - Le revenu est calculé comme suit :
    - **Voitures :** `SUM(price * commission)`
    - **Hôtels :** `SUM(room_price * DATE_DIFF(end_date, start_date, DAY) * commission)`
  - Ces formules prennent en compte :
    - Le prix total de la réservation.
    - La durée (pour les hôtels).
    - Le pourcentage de commission appliqué.

- **Colonnes générées :**
  - `month` : Le mois de la réservation.
  - `value` : Le revenu total pour le mois.
  - `type` : Identifie la source du revenu (`car_profit`, `hotel_profit`).

### **2. Nombre de Réservations par Mois et par Type**
- **CTEs concernées :**
  - `car_booking` : Compte les réservations de voitures par mois.
  - `hotel_booking` : Compte les réservations d’hôtels par mois.

- **Logique :**
  - Les réservations sont comptées avec `COUNT(booked_at)`, chaque enregistrement représentant une réservation unique.

- **Colonnes générées :**
  - `month` : Le mois de la réservation.
  - `value` : Le nombre total de réservations pour le mois.
  - `type` : Identifie le type de réservation (`car_booking`, `hotel_booking`).

### **3. Nombre d’Utilisateurs Inscrits par Mois**
- **CTE concernée :**
  - `users_signed_per_month` : Compte les utilisateurs inscrits par mois.

- **Logique :**
  - Les inscriptions sont comptées avec `COUNT(user_id)`.

- **Colonnes générées :**
  - `month` : Le mois de l’inscription.
  - `value` : Le nombre d’utilisateurs inscrits.
  - `type` : Identifie le type de données (`user_signup`).

---

## **Résultats Finaux**

- Les résultats combinent toutes les CTE mentionnées ci-dessus à l’aide de `UNION ALL`.
- Chaque ligne contient les colonnes suivantes :
  - **`month`** : Mois (au format `YYYY-MM`).
  - **`value`** : Valeur agrégée (revenu, nombre de réservations, ou nombre d’inscriptions).
  - **`type`** : Type de métrique (`car_profit`, `hotel_profit`, `car_booking`, `hotel_booking`, `user_signup`).

### **Exemple de Résultats :**

| Month       | Value   | Type           |
|-------------|---------|----------------|
| 2023-10-01  | 15000   | car_profit     |
| 2023-10-01  | 20000   | hotel_profit   |
| 2023-10-01  | 250     | car_booking    |
| 2023-10-01  | 180     | hotel_booking  |
| 2023-10-01  | 50      | user_signup    |

---

## **Étapes pour Exécuter**

### **1. Configuration des Données**
Assurez-vous que les tables suivantes existent dans votre dataset BigQuery :
- `car_bookings` : Détails des réservations de voitures.
- `car_rental_companies` : Détails des sociétés de location (inclut la commission).
- `hotel_bookings` : Détails des réservations d’hôtels.
- `hotel_rooms` : Détails des chambres d’hôtel (inclut les prix).
- `hotels` : Détails des hôtels (inclut la commission).
- `users` : Informations sur les utilisateurs.

### **2. Exécution de la Requête**
- Collez la requête SQL dans l’éditeur BigQuery.
- Exécutez la requête pour générer les résultats consolidés.

### **3. Vérification des Résultats**
- Vérifiez que les colonnes `month`, `value`, et `type` sont correctement remplies.
- Exportez les résultats pour une analyse ou une visualisation dans un outil BI (comme Tableau ou Google Data Studio).

---

## **Pièges à Éviter**

### 1. **Jointures Incorrectes**
- Assurez-vous que les conditions de jointure (`ON`) sont précises pour éviter les doublons ou des résultats incorrects.
- Exemple : Dans `car_profit`, la jointure entre `car_bookings` et `car_rental_companies` est essentielle pour récupérer le taux de commission.

### 2. **Données Manquantes**
- Vérifiez que les colonnes clés (comme `start_date`, `booked_at`, `user_id`) ne contiennent pas de valeurs NULL.
- **Solution :** Utilisez des filtres `WHERE <colonne> IS NOT NULL` si nécessaire.

### 3. **Problèmes de Performance**
- Les tables volumineuses peuvent ralentir l’exécution.
- **Solution :**
  - Limitez la période d’analyse avec un filtre (`WHERE start_date >= 'YYYY-MM-DD'`).
  - Assurez-vous que des index sont définis sur les colonnes fréquemment utilisées dans les jointures.

---

## **Utilisations Pratiques**
1. **Analyse des Revenus :**
   - Identifier les périodes les plus lucratives pour les hôtels et les voitures.
   - Comparer les performances entre les deux types.

2. **Analyse des Réservations :**
   - Suivre les tendances des réservations mensuelles.
   - Détecter les pics ou les baisses pour ajuster les stratégies marketing.

3. **Suivi des Inscriptions :**
   - Observer la croissance du nombre d’utilisateurs inscrits par mois.
   - Corréler les inscriptions avec des campagnes marketing ou des promotions.

---

## **Améliorations Futures**
1. Ajouter des dimensions supplémentaires (comme la région ou le canal d’acquisition).
2. Calculer des moyennes mobiles ou des comparaisons année sur année.
3. Intégrer d’autres indicateurs comme les taux d’annulation ou les montants remboursés.

---

Ce README fournit une explication complète de la requête SQL, ses objectifs, et comment l'exécuter efficacement. 🚀
