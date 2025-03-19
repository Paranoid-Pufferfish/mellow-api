## API endpoints :

- Optional : `?page` , default `0`

### Publisher:

- ?by_name
- ?by_book
- ?by_popularity

* [ ] Done

```sql
SELECT publisherName
FROM PUBLISHER
         LEFT JOIN BOOK B ON B.publisher = PUBLISHER.publisherName
WHERE ((?) = 'IGNORE_NAME' OR instr(publisherName, (?)) > 0)
  AND ((?) = 'IGNORE_BOOK' OR serialnum = (?))
GROUP BY publisherName
ORDER BY IIF((?) = 'POPULAR', SUM(hits), COUNT()) DESC
LIMIT 10 OFFSET (? * 10)

```

### Author:

- ?by_name
- ?by_book
- ?by_popularity

* [ ] Done

```sql
SELECT authorName
FROM AUTHOR
         LEFT JOIN AUTHORED A ON AUTHOR.authorName = A.author
         LEFT JOIN BOOK B ON B.serialnum = A.serialnum
WHERE ((?) = 'IGNORE_NAME' OR instr(authorName, (?)) > 0)
  AND ((?) = 'IGNORE_BOOK' OR A.serialnum = (?))
GROUP BY authorName
ORDER BY IIF((?) = 'POPULAR', SUM(hits), COUNT()) DESC
LIMIT 10 OFFSET (? * 10)
```

### Action:

- ?by_name

* [ ] `SELECT actionName FROM ACTION WHERE instr(actionName,(?)) > 0 LIMIT 10 OFFSET (? * 10)`

### Doctype:

- ?by_name
- ?by_book
- ?by_popularity

* [ ] Done

```sql
SELECT typeName
FROM DOCTYPE
         LEFT JOIN BOOK B ON DOCTYPE.typeName = B.type
WHERE ((?) = 'IGNORE_NAME' OR instr(typeName, (?)) > 0)
  AND ((?) = 'IGNORE_BOOK' OR serialnum = (?))
GROUP BY typeName
ORDER BY IIF((?) = 'POPULAR', SUM(hits), COUNT()) DESC
LIMIT 10 OFFSET (? * 10)
```

### Campus:

- ?by_name
- ?by_book
- ?by_account

* [ ] Done

```sql
SELECT campusName
FROM CAMPUS
         LEFT JOIN STOCK S ON CAMPUS.campusName = S.campus
         LEFT JOIN ACCOUNT A on CAMPUS.campusName = A.campus
WHERE ((?) = 'IGNORE_NAME' OR instr(campusName, (?)) > 0)
  AND ((?) = 'IGNORE_BOOK' OR serialnum = (?))
  AND ((?) = 'IGNORE_ACCOUNT' OR UUID = (?))
LIMIT 10 OFFSET (? * 10)
```

### Role:

- ?by_name
- ?by_perm
- ?by_account

* [ ] Done

```sql
SELECT roleName, perms
FROM ROLE
         LEFT JOIN ACCOUNT A ON A.role = ROLE.roleName
WHERE ((?) = 'IGNORE_NAME' OR instr(roleName, (?)) > 0)
  AND ((?) = 'IGNORE_PERMS' OR perms = (?))
  AND ((?) = 'IGNORE_ACCOUNT' OR UUID = (?))
ORDER BY perms DESC
LIMIT 10 OFFSET (? * 10)

```

### Category:

TODO: this....thing

* [ ] `SELECT categoryClass,categoryName,parentCategoryID FROM CATEGORY LIMIT 10 OFFSET (? * 10)`

#### ?cascade:

* [ ] Done

```sql
WITH RECURSIVE CategoryCascade AS (SELECT categoryClass, parentCategoryID
                                   FROM CATEGORY
                                   WHERE 'INITIAL CONDITION'
                                   UNION ALL
                                   SELECT c.categoryClass, c.parentCategoryID
                                   FROM CATEGORY c
                                            INNER JOIN CategoryCascade ct ON c.parentCategoryID = ct.categoryClass 'RELATION CONDITION')
SELECT CATEGORY.categoryClass, CATEGORY.categoryName
FROM CATEGORY,
     CategoryCascade
WHERE CategoryCascade.categoryClass = CATEGORY.categoryClass
LIMIT 10 OFFSET (? * 10);
```

#### ?tree:

* [ ] Done

```sql
SELECT categoryClass, categoryName, parentCategoryID
FROM CATEGORY
WHERE 'INITIAL CONDITION'
SELECT categoryClass, categoryName, parentCategoryID
FROM CATEGORY
WHERE 'RELATION CONDITION'
```

#### ?by_name:

* [ ] 
  `SELECT categoryClass,categoryName,parentCategoryID FROM CATEGORY WHERE instr(categoryName,(?)) > 0 LIMIT 10 OFFSET (? * 10)`

#### ?by_class:

* [ ] 
  `SELECT categoryClass,categoryName,parentCategoryID FROM CATEGORY WHERE instr(categoryClass,(?)) > 0 LIMIT 10 OFFSET (? * 10)`

#### ?by_parent:

* [ ] 
  `SELECT categoryClass,categoryName,parentCategoryID FROM CATEGORY WHERE instr(parentCategoryID,(?)) > 0 LIMIT 10 OFFSET (? * 10)`

#### ?by_book:

* [ ] 
  `SELECT category,categoryName,parentCategoryID FROM CATEGORY,BOOK WHERE serialnum = (?) AND categoryClass = category`

### Account:

- ?by_ID
- ?by_name
- ?by_book
- ?by_campus
- ?by_role
- ?frozen

* [ ] Done

```sql
SELECT ACCOUNT.UUID, displayname, pwhash, campus, role, frozen
FROM ACCOUNT
         LEFT JOIN INVENTORY I on ACCOUNT.UUID = I.UUID
WHERE ((?) = 'IGNORE_ID' OR ACCOUNT.UUID = (?))
  AND ((?) = 'IGNORE_NAME' OR instr(displayname, (?)) > 0)
  AND ((?) = 'IGNORE_BOOK' OR serialnum = (?))
  AND ((?) = 'IGNORE_CAMPUS' OR campus = (?))
  AND ((?) = 'IGNORE_ROLE' OR role = (?))
  AND ((?) = 'IGNORE_FREEZE' OR frozen = (?))
ORDER BY ACCOUNT.UUID
LIMIT 10 OFFSET (? * 10)

```

### Book:

- ?by_ID
- ?by_category
- ?by_name
- ?by_lang
- ?by_author
- ?by_type
- ?by_publisher
- ?by_campus
- ?by_account
- ?ignore_empty
- ?from_year
- ?to_year
- ?by_popularity

* [ ] Done

```sql

WITH RECURSIVE CategoryCascade AS (SELECT categoryClass, parentCategoryID
                                   FROM CATEGORY
                                   WHERE ((?) = 'ROOT' AND parentCategoryID IS NULL)
                                      OR categoryClass = (?)
                                   UNION ALL
                                   SELECT c.categoryClass, c.parentCategoryID
                                   FROM CATEGORY c
                                            INNER JOIN CategoryCascade ct ON c.parentCategoryID = ct.categoryClass)
SELECT BOOK.serialnum,
       type,
       category,
       publisher,
       booktitle,
       bookreleaseyear,
       bookcover,
       hits
FROM (BOOK LEFT JOIN INVENTORY I ON BOOK.serialnum = I.serialnum),
     LANGUAGES,
     AUTHORED,
     STOCK,
     CategoryCascade
WHERE category = CategoryCascade.categoryClass
  AND AUTHORED.serialnum = BOOK.serialnum
  AND LANGUAGES.serialnum = BOOK.serialnum
  AND STOCK.serialnum = BOOK.serialnum
  AND ((?) = 'IGNORE_NAME' OR instr(booktitle, (?)))
  AND ((?) = 'IGNORE_LANG' OR lang = (?))
  AND ((?) = 'IGNORE_AUTHOR' OR instr(author, (?)) > 0)
  AND ((?) = 'IGNORE_TYPE' OR type = (?))
  AND ((?) = 'IGNORE_PUBLISHER' OR instr(publisher, (?)) > 0)
  AND ((?) = 'IGNORE_CAMPUS' OR campus = (?))
  AND ((?) = 'IGNORE_ACCOUNT' OR UUID = (?))
  AND ((?) = 'INCLUDE_EMPTY' OR STOCK.instock > 0)
  AND ((?) = 'IGNORE_FROM_DATE' OR bookreleaseyear >= (?))
  AND ((?) = 'IGNORE_TO_DATE' OR bookreleaseyear <= (?))
GROUP BY BOOK.serialnum, hits, booktitle
ORDER BY IIF((?) = 'POPULAR', hits, booktitle) DESC
LIMIT 10 OFFSET (? * 10);

```

### Stock:

- ?by_book
- ?by_campus
- ?ignore_empty
- ?by_popularity

* [ ] Done

```sql
SELECT STOCK.serialnum, campus, instock
FROM STOCK,
     BOOK
WHERE STOCK.serialnum = BOOK.serialnum
  AND ((?) = 'IGNORE_BOOK' OR STOCK.serialnum = (?))
  AND ((?) = 'IGNORE_CAMPUS' OR campus = (?))
  AND IIF((?) = 'AVAILABLE', instock > 0, TRUE)
GROUP BY BOOK.serialnum, campus, instock, hits
ORDER BY IIF((?) = 'POPULAR', hits, instock) DESC
LIMIT 10 OFFSET (? * 10)
```

### Inventory:

- ?by_account | ?self (alias to ?by_account with cookie)
- ?by_book

* [ ] Done

```sql
SELECT UUID, serialnum, rentduration, rentdate, extended
FROM INVENTORY
WHERE ((?) = 'IGNORE_ACCOUNT' OR UUID = (?))
  AND ((?) = 'IGNORE_BOOK' OR serialnum = (?))
ORDER BY rentdate DESC
LIMIT 10 OFFSET (? * 10)
```

### History:

- ?by_account
- ?by_issuer
- ?by_book
- ?by_action
- ?from_date
- ?to_date

* [ ] Done

```sql
SELECT UUID, UUID_ISSUER, serialnum, action, actiondate
FROM HISTORY
WHERE ((?) = 'IGNORE_ACCOUNT' OR UUID = (?))
  AND ((?) = 'IGNORE_ISSUER' OR UUID_ISSUER = (?))
  AND ((?) = 'IGNORE_BOOK' OR serialnum = (?))
  AND ((?) = 'IGNORE_ACTION' OR action = (?))
  AND ((?) = 'IGNORE_FROM_DATE' OR actiondate >= (?))
  AND ((?) = 'IGNORE_TO_DATE' OR actiondate <= (?))
ORDER BY actiondate DESC
LIMIT 10 OFFSET (? * 10)
```