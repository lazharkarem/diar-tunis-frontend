# Backend Integration Setup Guide

## Overview
This document provides instructions for setting up and running the Laravel backend with the Flutter frontend.

## Backend Setup (Laravel)

### 1. Environment Setup
```bash
cd /Users/petrovemerak/Desktop/projects/Freelance/myProject/diar-tunis-fixy-backend

# Copy environment file
cp .env.example .env

# Install dependencies
composer install

# Generate application key
php artisan key:generate

# Create database (SQLite by default)
touch database/database.sqlite

# Run migrations
php artisan migrate

# Create roles and permissions
php artisan db:seed --class=RolesAndPermissionsSeeder
```

### 2. Required Environment Variables
Update your `.env` file with:
```env
APP_NAME="Diar Tunis"
APP_ENV=local
APP_KEY=base64:YOUR_KEY_HERE
APP_DEBUG=true
APP_URL=http://localhost:8000

DB_CONNECTION=sqlite
# DB_HOST=127.0.0.1
# DB_PORT=3306
# DB_DATABASE=diar_tunis
# DB_USERNAME=root
# DB_PASSWORD=

BROADCAST_CONNECTION=log
FILESYSTEM_DISK=local
QUEUE_CONNECTION=database

CACHE_STORE=database
```

### 3. Start the Backend Server
```bash
# Start Laravel development server
php artisan serve

# The server will be available at http://localhost:8000
```

### 4. API Endpoints Created

#### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `POST /api/auth/logout` - User logout (requires auth)
- `POST /api/auth/refresh` - Refresh token (requires auth)
- `GET /api/auth/profile` - Get user profile (requires auth)
- `PUT /api/auth/profile` - Update user profile (requires auth)
- `POST /api/auth/forgot-password` - Send password reset link
- `POST /api/auth/reset-password` - Reset password

#### Properties (Public)
- `GET /api/properties` - Get all active properties
- `GET /api/properties/{id}` - Get single property

#### Host Features (requires 'host' role)
- `GET /api/host/properties` - Get host's properties
- `POST /api/host/properties` - Create new property
- `PUT /api/host/properties/{id}` - Update property
- `DELETE /api/host/properties/{id}` - Delete property
- `GET /api/host/bookings` - Get host's bookings
- `GET /api/host/earnings` - Get host earnings

#### Guest Features (requires 'guest' role)
- `POST /api/guest/bookings` - Create booking
- `GET /api/guest/bookings` - Get guest's bookings
- `GET /api/guest/bookings/{id}` - Get single booking
- `PUT /api/guest/bookings/{id}/cancel` - Cancel booking

#### Admin Features (requires 'admin' role)
- `GET /api/admin/users` - Get all users
- `GET /api/admin/properties` - Get all properties
- `PUT /api/admin/properties/{id}/status` - Update property status
- `GET /api/admin/bookings` - Get all bookings
- `GET /api/admin/statistics` - Get dashboard statistics

## Frontend Setup (Flutter)

### 1. Update API Configuration
The Flutter app is already configured to connect to `http://localhost:8000/api`

### 2. Models Updated
- `AuthResponseModel` - Updated to handle Laravel's API response structure
- `UserModel` - Updated to map Laravel's user fields (name, phone_number, etc.)

### 3. Authentication Flow
The auth flow now supports:
- Registration with user type selection
- Login with email/password
- Token-based authentication using Laravel Sanctum
- Automatic token attachment to API requests
- Token refresh handling

### 4. Error Handling
- Improved error messages from Laravel API responses
- Better handling of validation errors
- 401 unauthorized handling with automatic token cleanup

## Testing the Integration

### 1. Start Backend
```bash
cd /Users/petrovemerak/Desktop/projects/Freelance/myProject/diar-tunis-fixy-backend
php artisan serve
```

### 2. Run Flutter App
```bash
cd /Users/petrovemerak/Desktop/projects/Freelance/myProject/diar_tunis
flutter run
```

### 3. Test Registration/Login
1. Open the Flutter app
2. Navigate to registration
3. Create a new account with user type
4. Try logging in with the created account
5. Verify API calls in backend logs

## Database Structure

### Users Table
- `id` - Primary key
- `name` - Full name
- `email` - Email address
- `password` - Hashed password
- `phone_number` - Phone number
- `user_type` - Enum: guest, host, service_customer, service_provider, admin
- `profile_picture` - Profile image path
- `address` - User address
- `email_verified_at` - Email verification timestamp

### Properties Table
- `id` - Primary key
- `host_id` - Foreign key to users
- `title` - Property title
- `description` - Property description
- `address` - Property address
- `latitude/longitude` - GPS coordinates
- `property_type` - Property type
- `number_of_guests` - Maximum guests
- `number_of_bedrooms` - Bedroom count
- `number_of_beds` - Bed count
- `number_of_bathrooms` - Bathroom count
- `price_per_night` - Nightly rate
- `status` - Enum: pending, active, inactive, rejected

### Bookings Table
- `id` - Primary key
- `guest_id` - Foreign key to users
- `property_id` - Foreign key to properties
- `check_in_date` - Check-in date
- `check_out_date` - Check-out date
- `number_of_guests` - Guest count
- `number_of_nights` - Night count
- `price_per_night` - Rate at booking time
- `total_amount` - Total booking cost
- `special_requests` - Guest requests
- `status` - Enum: pending, confirmed, completed, cancelled

## Role-Based Access

### Guest Role
- Can view properties
- Can create bookings
- Can view own bookings
- Can cancel own bookings

### Host Role
- Can manage own properties
- Can view bookings for own properties
- Can view earnings

### Admin Role
- Can view all users, properties, bookings
- Can update property status
- Can view system statistics

## Next Steps

1. **Test all endpoints** using Postman or Flutter app
2. **Add image upload** for properties and profile pictures
3. **Implement payment integration** for bookings
4. **Add push notifications** for booking updates
5. **Add real-time messaging** between hosts and guests
6. **Implement reviews and ratings** system
7. **Add property search filters** and location-based search

## Troubleshooting

### Common Issues

1. **CORS Issues**: Add CORS configuration in Laravel if needed
2. **Token Issues**: Check Laravel Sanctum configuration
3. **Database Issues**: Ensure SQLite file exists and has proper permissions
4. **Port Conflicts**: Change Laravel port if 8000 is in use: `php artisan serve --port=8080`

### Debug Commands

```bash
# Check Laravel logs
tail -f /Users/petrovemerak/Desktop/projects/Freelance/myProject/diar-tunis-fixy-backend/storage/logs/laravel.log

# Check Flutter logs
flutter logs

# Test API endpoints
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "password"}'
```
