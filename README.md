# Slang Dictionary



## Description

This is a demo API quickly built to replicate Urban Dictionary. My second Ruby on Rails API, there's definitely room for improvement.

**Not recommended for deployment**

Would need proper rate limiting and probably other features after testing with a front-end application. Would also need proper cleanup and seperating some variables as environment variables.

## Dependencies

This application requires:

* Ruby 3.0.3
* Rails 6.1.4.1

How to install [Ruby on Rails](https://www.youtube.com/watch?v=3D9d0wmwHVQ).

## Configure Application

```
bundle install
```

```
yarn
```

## Create Demo DB

```
rails db:create
```
```
rails db:migrate
```
The following command creates demo data in the DB
```
rails db:seed
```

## Start Rails Server

```
rails s
```

## Test API routes

```
bundle exec rspec
```

## Admin Account

The following details for the admin account is only available when you've finished seeding the database.

Email: `admin@fake.com`  
Password: `password`

## API

### Register

Allows you to create accounts.

```
http://127.0.0.1:3000/api/v1/register
```

Post:

```
{
    "user": {
        "username": "user",
        "email": "user@fake.com",
        "password": "Password1",
        "password_confirm": "Password1"
    }
}
```

Response:

```
{
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w"
}
```

### Authentication

Firstly you need to athenticate at the following url which will return a JWT token.

```
http://127.0.0.1:3000/api/v1/authenticate
```

Post:

```
{
    "email": "user@fake.com",
    "password": "Password1"
}
```

Response:

```
{
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w"
}
```

### Slangs

#### Fetch

Doesn't require JWT token.

```
http://127.0.0.1:3000/api/v1/slangs
```

Response:

```
[
    {
        "id": 189,
        "user_id": 1,
        "word": "Empty",
        "definition": "Hello New Slang",
        "is_approved": true,
        "created_at": "2021-12-21T15:49:22.542Z",
        "updated_at": "2021-12-21T20:25:36.520Z",
        "upvote_count": 1,
        "downvote_count": 1,
        "user": {
            "id": 1,
            "username": "admin"
        }
    }
]
```

#### Post

Requires a JWT token.

```
http://127.0.0.1:3000/api/v1/slangs
```

Post:

```
{
    "slang": {
        "word": "New Word",
        "definition": "Definition for new word"
    }
}
```

Response:

Returns a `201 Created`

### Votes

#### Post

Requires a JWT token.

```
http://127.0.0.1:3000/api/v1/up_vote/:slang_id
```

```
http://127.0.0.1:3000/api/v1/down_vote/:slang_id
```

Response:

If a slang was succesfully upvoted or downvoted a `201 Created` will be returned. If an existing variant of up_vote or down_vote exists, it'll just return a `204 No Content` when removed.

### Search

#### Get

Doesn't require JWT token.

```
http://127.0.0.1:3000/api/v1/search?q=blog
```

Response:

```
[
    {
        "id": 10,
        "user_id": 5,
        "word": "blog",
        "definition": "I don't want to live in a world where someone else is making the world a better place better than we are.",
        "is_approved": true,
        "created_at": "2021-12-21T13:59:14.564Z",
        "updated_at": "2021-12-21T13:59:14.564Z",
        "upvote_count": 0,
        "downvote_count": 0,
        "user": {
            "id": 5,
            "username": "kelley"
        }
    }
]
```

### User

#### Get

Doesn't require JWT token.

```
http://127.0.0.1:3000/api/v1/user/admin
```

Response:

```
[
    {
        "id": 190,
        "user_id": 1,
        "word": "New Word",
        "definition": "Definition for new word",
        "is_approved": false,
        "created_at": "2021-12-21T23:31:08.494Z",
        "updated_at": "2021-12-21T23:31:08.494Z",
        "upvote_count": 0,
        "downvote_count": 0,
        "user": {
            "id": 1,
            "username": "admin"
        }
    }
]
```

### Settings

#### Get

Requires a JWT token.

```
http://127.0.0.1:3000/api/v1/profile/settings
```

Response:

```
{
    "id": 1,
    "username": "admin",
    "is_admin": true,
    "created_at": "2021-12-21T13:58:47.809Z",
    "updated_at": "2021-12-21T21:45:18.975Z"
}
```

#### Patch

Requires a JWT token.
Only for updating the username.

```
http://127.0.0.1:3000/api/v1/profile/settings
```

Post:

```
{
    "user": {
        "username": "admin"
    }
}
```

Response:

Returns a `204 No Content` if successful

### Admin

#### Get

Requires a JWT token and is_admin.
Returns a list of unapproved slangs.

```
http://127.0.0.1:3000/api/v1/admin
```

Response:

```
[
    {
        "id": 190,
        "user_id": 1,
        "word": "New Word",
        "definition": "Definition for new word",
        "is_approved": false,
        "created_at": "2021-12-21T23:31:08.494Z",
        "updated_at": "2021-12-21T23:31:08.494Z",
        "upvote_count": 0,
        "downvote_count": 0,
        "user": {
            "id": 1,
            "username": "admin"
        }
    }
]
```

#### Patch

Requires a JWT token.

```
http://127.0.0.1:3000/api/v1/admin/slang/190
```

Response:

Returns a `204 Content` if it was updated successfully.

#### Delete

Requires a JWT token.

```
http://127.0.0.1:3000/api/v1/admin/slang/190
```

Response:

Returns a `204 Content` if it was successfully deleted.