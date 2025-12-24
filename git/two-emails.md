# You can use two emails in github

## usecase

- let say you have requirement to use two email one for personal and other one for company

Modify the .gitconfig file

```conf

# This is Git's per-user configuration file.
[user]
    name = Noman Sadiq
    email = noman.sadiq@company.com

[includeIf "gitdir:~/Documents/company/"]
    path = ~/.gitconfig-company

# (Optional) Personal
[includeIf "gitdir:~/Documents/personal/"]
   path = ~/.gitconfig-personal

```

file .gitconfig-company

```conf
[user]
    name = Noman Sadiq
    email = noman.sadiq@company.com
```

file .gitconfig-personal

```conf

[user]
    name = Noman Sadiq
    email = noman.sadiq@personal.com

```
