# Firestore User Profile Schema

## Design Decision: Single `users` Collection

Using a single `users` collection with a `role` field to differentiate between clients and workers. This simplifies queries and allows for potential future role changes.

## Collection: `users`

### Document ID

- Uses Firebase Auth `uid` as document ID
- Path: `users/{uid}`

### Common Fields (All Users)

| Field         | Type      | Required | Description                        |
| ------------- | --------- | -------- | ---------------------------------- |
| `uid`         | string    | ✓        | Firebase Auth UID (same as doc ID) |
| `role`        | string    | ✓        | `"client"` or `"worker"`           |
| `displayName` | string    | ✓        | User's full name                   |
| `email`       | string    | ✓        | Email address                      |
| `photoUrl`    | string    | ✗        | Profile photo URL                  |
| `phone`       | string    | ✗        | Phone number                       |
| `createdAt`   | timestamp | ✓        | Account creation time              |
| `updatedAt`   | timestamp | ✓        | Last profile update time           |

### Client-Specific Fields

| Field     | Type   | Required | Description                   |
| --------- | ------ | -------- | ----------------------------- |
| `address` | string | ✗        | Client's address (future use) |

### Worker-Specific Fields

| Field            | Type   | Required | Description             |
| ---------------- | ------ | -------- | ----------------------- |
| `cityOrZone`     | string | ✓        | Working zone/city       |
| `baseHourlyRate` | number | ✓        | Base hourly rate in COP |

## Sample Documents

### Client Example

```json
{
  "uid": "abc123xyz",
  "role": "client",
  "displayName": "María García",
  "email": "maria@example.com",
  "photoUrl": null,
  "phone": "+573001234567",
  "createdAt": "2025-11-26T09:00:00Z",
  "updatedAt": "2025-11-26T09:00:00Z"
}
```

### Worker Example

```json
{
  "uid": "def456uvw",
  "role": "worker",
  "displayName": "Carlos Rodríguez",
  "email": "carlos@example.com",
  "photoUrl": "https://...",
  "phone": "+573009876543",
  "cityOrZone": "Bogotá - Chapinero",
  "baseHourlyRate": 45000,
  "createdAt": "2025-11-26T09:00:00Z",
  "updatedAt": "2025-11-26T09:00:00Z"
}
```

## Security Rules (Recommended)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      // Users can only read/write their own document
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Usage Notes

1. **On Sign-up/Profile Completion**: Write full document with merge
2. **On Login**: Read document to populate local state
3. **On Profile Edit**: Update specific fields with merge
4. **Null Fields**: Worker-specific fields will be null/missing for clients and vice versa
